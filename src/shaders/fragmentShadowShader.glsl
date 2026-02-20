uniform sampler2D uShadowTexture;
uniform float uBlurRadius;

varying vec2 vUv;
varying float dist;

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

void main()
{
  float r = uBlurRadius;
  vec4 color = vec4(0.0);

  color += texture2D(uShadowTexture, vUv + vec2(-r, -r));
  color += texture2D(uShadowTexture, vUv + vec2(-r,  0.));
  color += texture2D(uShadowTexture, vUv + vec2(-r,  r));
  color += texture2D(uShadowTexture, vUv + vec2( 0., -r));
  color += texture2D(uShadowTexture, vUv + vec2( 0.,  0.));
  color += texture2D(uShadowTexture, vUv + vec2( 0.,  r));
  color += texture2D(uShadowTexture, vUv + vec2( r, -r));
  color += texture2D(uShadowTexture, vUv + vec2( r,  0.));
  color += texture2D(uShadowTexture, vUv + vec2( r,  r));

  color /= 9.0;
  
  float min_distance = 0.4;
  float edgeSoftness = 0.4;

  float alphaMask = 1.0 - smoothstep(min_distance - edgeSoftness, min_distance, dist);

  color.a *= alphaMask;
  color.a = clamp(color.a * 1.5, 0.0, 1.0);

  gl_FragColor = color;
}