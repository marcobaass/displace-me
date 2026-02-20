uniform sampler2D uShadowTexture;

varying vec2 vUv;
varying float dist;

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

void main()
{
  vec4 color = texture2D(uShadowTexture, vUv);
  
  float min_distance = 0.4;

  if (dist < min_distance) {
    float alpha = map(dist, min_distance, 0., color.a , 0.);
    color.a = clamp((alpha * 1.5), 0.0, 1.0);
  } else {
    color.a = 0.0;
  }

  gl_FragColor = color;
}