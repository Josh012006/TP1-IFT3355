// The uniform variable is set up in the javascript code and the same for all vertices
uniform vec3 remotePosition;
uniform float xoff;


void main() {

    // Multiply each vertex by the model-view matrix and the projection matrix to get final vertex position
    // Also taking into acount the height to display the points.
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position + vec3(xoff, 0.0, 0.0) + remotePosition, 1.0);
}
 