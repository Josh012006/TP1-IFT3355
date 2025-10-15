uniform int tvChannel;
uniform vec3 remotePosition;

void main() {

	float normalizedPos = remotePosition.y / 4.0;

	// Paint it in different shades depending on the height
	gl_FragColor = vec4(1.0 - normalizedPos, min(normalizedPos / 0.5, 1.0), normalizedPos, 1);
}