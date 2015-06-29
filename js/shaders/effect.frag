
#include utils.glsl
#include uniforms.glsl
#include noise2D.glsl

varying vec2 vUv;

void main()
{
    vec2 uv = gl_FragCoord.xy / uResolution.xy;
    vec2 uvScreen = uv;
    // uvScreen.x *= uResolution.x / uResolution.y;

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

    vec4 rtt = texture2D(uRenderTarget, uv);
    float lum = (rtt.r + rtt.g + rtt.b) / 3.0;

    float minRange = 4.0;
    float maxRange = 16.0;

    // float area = uResolution.x;
    float dist = lum;// + abs(snoise(vec2(uTime * 0.1, 0.0)));//length(uvScreen.yy);//floor(uvScreen.yy*area)/area);

    // dist += 0.25;
    // dist = max(0.0, min(1.0, dist));

    dist = dist * dist;

    float details = minRange + floor(dist * maxRange);

    details = pow(2.0, details);

    uv = floor(uvScreen * details) / details;

    vec2 center = vec2(0.5) - uv;
    // float dist = length(center);
    float angle = atan(center.y, center.x) + dist * 4.0;
    angle += snoise(uv * 10.0) * 0.001;
    // vec2 p = vec2(abs(angle / PI), clamp(1.0 - dist, 0.0, 1.0));
    // vec2 p = vec2(cos(angle), sin(angle)) * 0.01;
    // p *= abs(snoise(vec2(angle * 70.0,0.0)));

    vec2 p = vec2(0.0, -0.01) * abs(snoise(uv.xx * 200.0));

    // float angle = noise()

    vec4 video = texture2D(uVideo, uv);
    vec4 renderTarget = texture2D(uRenderTarget, uv);// + p);

    // if (dist < 1.0 / uResolution.x) video = vec4(vec3(0.0), 1.0);//vec4(snoise(vec2(uTime * 0.1)), snoise(vec2(uTime * 0.01)), snoise(vec2(uTime * 0.5)), 1.0);

    vec4 color = mix(renderTarget, video, step(0.25, distance(video.rgb, renderTarget.rgb)));
    color = mix(color, video, clamp(filter5x5(uFilter5x5, uVideo, uv, uResolution), 0.0, 1.0));
    // vec4 color = mix(renderTarget, video, clamp(filter5x5(uFilter5x5, uVideo, uv, uResolution), 0.0, 1.0));

    // color = mix(color, color, p.x);

    // Hop
    gl_FragColor = color;
  }
