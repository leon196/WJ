
#include utils.glsl
#include uniforms.glsl

varying vec2 vUv;

void main()
{
    vec2 uv = gl_FragCoord.xy / screenSize.xy * 2.0 - 1.0;
    uv.x *= screenSize.x / screenSize.y;

    // float index = uv.x + uv.y * screenSize.x;

    // index = index;//index * (1.0 + 0.1 * sin(time * 0.01));
    // index += time * 100000.0;

    // vec3 color = texture2D(video, gl_FragCoord.xy / screenSize).rgb;
    // float lum = (color.r + color.g + color.b) / 3.0;

    // index += lum * screenSize.x;

    // uv.x = mod(index, screenSize.x);
    // uv.y = floor(index / screenSize.x);
    // uv = mod(uv / screenSize, 1.0);

    // color = texture2D(video, uv).rgb;


    float dist = mod(length(uv), 1.0);
    float angle = atan(uv.y, uv.x);
    vec2 p = vec2(abs(angle / PI), clamp(1.0 - dist, 0.0, 1.0));


    vec3 color = texture2D(video, p).rgb;

    color = mix(color, color, p.x);

    // Hop
    gl_FragColor = vec4(color, 1.0);
}