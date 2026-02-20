uniform vec3 uDisplacement;
uniform vec2 uShadowContentSize;

varying vec2 vUv;
varying float dist;

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

void main()
{
  vUv = uv;
  vUv = (position.xy / uShadowContentSize) * 0.5 + 0.5;
  vec3 new_position = position;
  float pi = 3.14159265359;

  // dist is a VARYING here – this is correct
  dist = length(uDisplacement - position);

  // radius
  float min_distance = 0.55;

  if (dist < min_distance) {
    float distance_mapped = map(dist, 0.0, min_distance, 1.0, 0.0);

    // Screw
    vec2 center = uDisplacement.xy;
    vec2 offset = position.xy - center;
    float angle = distance_mapped * pi * 2.0;
    float c = cos(angle);
    float s = sin(angle);

    new_position.xy = center + vec2(offset.x * c - offset.y * s, offset.x * s + offset.y * c);
  }

  gl_Position = projectionMatrix * modelViewMatrix * vec4(new_position, 1.0);
}