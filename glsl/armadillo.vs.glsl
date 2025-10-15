// Create shared variable for the vertex and fragment shaders
out vec3 interpolatedNormal;
uniform int time;
uniform sampler2D fft;
uniform vec3 remote0;

// Noise function inspired by https://thebookofshaders.com/10/ and simply modified to add the
// time and the low frequencies into the calculations
float random(float frq, vec3 pos) {
    return fract(sin(dot(pos,
                         vec3(float(time) * 0.01 * 12.9898,(frq + 1.0) * 78.233, 31415.926535)))*
        43758.5453123);
}

void main() {

	// Set shared variable to vertex normal
    interpolatedNormal = normal;
	
	// Get the low frequency of sound from the FFT texture
	float fft_bass = texture(fft, vec2(0.1, 0.0)).x;

	// A simple linear distortion depending on the low frequencies and the position of remote 0.
	float distortion = 0.3 * fft_bass * ((remote0.y + 1.0) / 4.0);

	// A shape distortion when remote 0 is 3/4-up the ground for the creative part
	if(remote0.y > 3.0) {
		distortion *= random(fft_bass, position);
	}

	vec3 computedPosition = position + distortion * normal;

    // Final vertex position
	gl_Position = projectionMatrix * modelViewMatrix * vec4(computedPosition, 1.0);
}
