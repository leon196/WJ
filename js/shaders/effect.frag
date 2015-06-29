
#include utils.glsl
#include uniforms.glsl
#include noise2D.glsl

varying vec2 vUv;

void main()
{
    vec2 uv = gl_FragCoord.xy / uResolution.xy;
    // uv.x *= uResolution.x / uResolution.y;

    // float index = uv.x + uv.y * uResolution.x;

    // index = index;//index * (1.0 + 0.1 * sin(time * 0.01));
    // index += time * 100000.0;

    // vec3 color = texture2D(uVideo, gl_FragCoord.xy / uResolution).rgb;
    // float lum = (color.r + color.g + color.b) / 3.0;

    // index += lum * uResolution.x;

    // uv.x = mod(index, uResolution.x);
    // uv.y = floor(index / uResolution.x);
    // uv = mod(uv / uResolution, 1.0);

    // color = texture2D(uVideo, uv).rgb;


    // float dist = mod(length(uv), 1.0);
    float angle = atan(0.5 - uv.y, 0.5 - uv.x);
    angle += snoise(uv * 100.0) * 10.0;
    // vec2 p = vec2(abs(angle / PI), clamp(1.0 - dist, 0.0, 1.0));
    vec2 p = vec2(cos(angle), sin(angle)) * 0.002;

    // float angle = noise()

    vec4 video = texture2D(uVideo, uv);
    vec4 renderTarget = texture2D(uRenderTarget, uv + p);
    vec4 color = mix(renderTarget * vec4(vec3(0.98), 1.0), video, step(uMouse.x, distance(video.rgb, renderTarget.rgb)));

    // color = mix(color, color, p.x);

    // Hop
    gl_FragColor = color;
  }
