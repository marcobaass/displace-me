uniform vec3 uDisplacement;
uniform vec2 uContentSize;

varying vec2 vUv;

float easeInOutCubic(float x) {
  return x < 0.5
    ? 4.0 * x * x * x
    : 1.0 - pow(-2.0 * x + 2.0, 3.0) / 2.0;
}

float map(float value, float min1, float max1, float min2, float max2) {
  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}  

void main()
{
  vUv = uv;
  vUv = (position.xy / uContentSize) * 0.5 + 0.5;
  vec3 new_position = position;
  float pi = 3.14159265359;

  float dist = length(uDisplacement - position);
  
  // radius
  float min_distance = 0.55;

  if (dist < min_distance) {
    float distance_mapped = map(dist, 0.0, min_distance, 1.0, 0.0);
    // height
    float val = easeInOutCubic(distance_mapped) * 1.0; 

    // Lift
    new_position.z += val;

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
