
#include utils.glsl
#include uniforms.glsl

varying vec2 vUv;

void main()
{
    gl_FragColor = texture2D(uVideo, gl_FragCoord.xy / uResolution.xy);
}
