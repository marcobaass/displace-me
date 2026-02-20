uniform vec3 uDisplacement;
uniform vec2 uShadowContentSize;

varying vec2 vUv;
varying float dist;

void main()
{
  vUv = uv;
  vUv = (position.xy / uShadowContentSize) * 0.5 + 0.5;

  // dist is a VARYING here – this is correct
  dist = length(uDisplacement - position);

  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}