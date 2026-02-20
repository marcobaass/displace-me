uniform vec3 uDisplacement;
uniform vec2 uContentSize;
uniform float uTime;

varying vec2 vUv;
varying float vLift;

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
  float min_distance = 0.25;

  vLift = 0.0;

  if (dist < min_distance) {
    float distance_mapped = map(dist, 0.0, min_distance, 1.0, 0.0);
    vLift = distance_mapped;


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

    // Flame movement
    float time = uTime;
    float x = new_position.x;
    float y = new_position.y;

    float wave1 = sin(time * 2.0 + x * 3.0);
    float wave2 = cos(time * 2.7 + y * 4.0);

    float wave3 = sin(time * 1.5 + x * 2.0 + y * 2.0);

    float combinedX = wave1 + wave3 * 0.3;
    float combinedY = wave2 + wave3 * 0.5;
    float waveScale = 0.02 * val;
    new_position.x += combinedX * waveScale * 10.0;
    new_position.y += combinedY * waveScale * 10.0;
  }

  gl_Position = projectionMatrix * modelViewMatrix * vec4(new_position, 1.0);
}
