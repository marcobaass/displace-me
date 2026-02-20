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

  float dist = length(uDisplacement - position);
  
  float min_distance = 0.4;

  if (dist < min_distance) {
    float distance_mapped = map(dist, 0.0, min_distance, 1.0, 0.0);
    float val = easeInOutCubic(distance_mapped) * 0.08; 
    new_position.z += val;
  }

  gl_Position = projectionMatrix * modelViewMatrix * vec4(new_position, 1.0);
}
