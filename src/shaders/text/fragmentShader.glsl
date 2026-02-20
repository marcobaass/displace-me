uniform sampler2D uTexture;

varying vec2 vUv;
varying float vLift;

void main()
{
  vec4 color = texture2D(uTexture, vUv);

  // Fade out the higher it screws: vLift is 0 at edge, 1 at center (max lift)
  float fadeStart = 0.0;
  float fadeEnd = 0.6;
  float dissolve = smoothstep(fadeStart, fadeEnd, vLift);
  color.a *= (1.0 - dissolve);
  color.r = smoothstep(0.0, 0.75, dissolve);
  color.g = smoothstep(0.25, 1.0, dissolve);

  gl_FragColor = vec4(color);
}
