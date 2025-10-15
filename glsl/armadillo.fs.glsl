// Create shared variable. The value is given as the interpolation between normals computed in the vertex shader
in vec3 interpolatedNormal;
uniform vec3 remote1;
uniform vec3 remote2;
uniform int time;
uniform sampler2D fft;


// Using the same random function as for remote 0 (https://thebookofshaders.com/10/) but this
// time to modify colors
float random(float frq, vec3 vect) {
    return fract(sin(dot(vect,
                         vec3(float(time) * 0.01 * 12.9898,(frq + 1.0) * 78.233, 31415.926535)))*
        43758.5453123);
}

void main() {
  // Set final rendered color according to the modified normal
  vec3 computedColor = interpolatedNormal;

  // Get the middle and high frequencies of sound from the FFT texture
	float fft_middle = texture(fft, vec2(0.25, 0.0)).x;
	float fft_treble = texture(fft, vec2(0.5, 0.0)).x;

  // Modifying the interpolatedNormal passed to the fragment shader in other to reflect 
	// the middle and high sound frequencies and the remotes' heights
	computedColor.y += fft_middle * 0.5;			  // The shade of green depends on the middle frequencies presence
	computedColor.z += fft_treble * 2.0;        // The shade of blue depends on the high frequencies presence

  computedColor.y *= (remote1.y/4.0 + 0.5);   // The effect of the middle frequencies is complemented by remote 1's position
  computedColor.z *= (remote2.y/4.0 + 0.5);   // The effect of the high frequencies is complemented by remote 2's position


  // A first color distortion when remote 1 is 3/4-up the ground for the creative part
  // It's just a simple pseudo-random noise.
  if(remote1.y > 3.0) {
    computedColor += random(fft_middle, interpolatedNormal);
  }

  // A second color distortion when remote 2 is 3/4-up the ground for the creative part
  // This time I use the length to create a common pattern
  if(remote2.y > 3.0) {
    computedColor += random(fft_treble, vec3(length(interpolatedNormal)));
  }

  gl_FragColor = vec4(normalize(computedColor), 1.0);
}
