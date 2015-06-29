
#include utils.glsl
#include uniforms.glsl

varying vec2 vUv;

void main()
{
  vec2 uv = gl_FragCoord.xy / uResolution.xy;
  vec4 video = texture2D(uRenderTarget, uv);
  gl_FragColor = video;
}
