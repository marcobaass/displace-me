uniform vec3 uColor;

varying float vLife;

void main() {
    gl_FragColor = vec4(uColor, vLife);
}