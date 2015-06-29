
varying vec2 vUv;
uniform sampler2D uSampler;

void main()
{
    gl_FragColor = texture2D(uSampler, gl_FragCoord.xy / screenSize.xy);
}