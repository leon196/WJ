
#include utils.glsl
#include uniforms.glsl
#include noise2D.glsl
#include classicnoise2D.glsl

varying vec2 vUv;

void main()
{
    vec2 uv = gl_FragCoord.xy / uResolution.xy * 2.0 - 1.0;
    uv.x *= uResolution.x / uResolution.y;

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

    // vec4 rtt = texture2D(uRenderTarget, uv);
    // float lum = (rtt.r + rtt.g + rtt.b) / 3.0;
    // float minRange = 5.0;
    // float maxRange = 8.0;
    // // float area = uResolution.x;
    // float range = length(uvScreen.yy);
    //
    // //mod(lum + oscillation(uTime, 1.0), 1.0);
    // // + abs(snoise(vec2(uTime * 0.1, 0.0)));
    // //length(uvScreen.yy);
    // //floor(uvScreen.yy*area)/area);
    // // range += 0.25;
    // // range = max(0.0, min(1.0, range));
    // range = range * range;
    // float details = minRange + floor(range * maxRange);
    // details = pow(2.0, details);
    // uv = floor(uvScreen * details) / details;

    float dist = length(uv) * 2.0;// - uTime * 1.0;
    float angle = atan(uv.y, uv.x);
    // angle += cnoise(uv * 100.0) * 2.0;
    // vec2 p = vec2(abs(angle / PI), clamp(1.0 - dist, 0.0, 1.0));
    // vec4 rtt = texture2D(uRenderTarget, uv.xx);
    // float angle = snoise(vec2(rtt.rg + rtt.b)) * PI;
    // vec2 p = vec2(cos(angle), sin(angle)) * 0.001;
    // rtt = texture2D(uRenderTarget, uv.yy);
    // angle = snoise(vec2(rtt.rg + rtt.b)) * PI;
    // p += vec2(cos(angle), sin(angle)) * 0.005;
    // p *= abs(snoise(vec2(angle * 70.0,0.0)));
    // vec2 p = vec2(0.0, -0.01) * abs(snoise(uv.xx * 200.0));

    float a = angle / PI;
    a *= 4.0;
    float sens = mod(floor(a), 2.0);
    a += uTime * 0.1 * mix(-1.0, 1.0, sens);
    a = mix(1.0 - a, a, mod(floor(a), 2.0));

    float d = mix(1.0 - dist, dist, mod(floor(dist), 2.0));
    uv = mod(vec2(a, d), 1.0);


    vec4 video = texture2D(uVideo, uv);
    // vec4 renderTarget = texture2D(uRenderTarget, uv);// + p);

    // if (dist < 1.0 / uResolution.x) video = vec4(vec3(0.0), 1.0);//vec4(snoise(vec2(uTime * 0.1)), snoise(vec2(uTime * 0.01)), snoise(vec2(uTime * 0.5)), 1.0);

    // vec4 color = mix(renderTarget, video, step(0.5, distance(video.rgb, renderTarget.rgb)));
    // color = mix(color, video, clamp(filter5x5(uFilter5x5, uVideo, uv, uResolution), 0.0, 1.0));
    // vec4 color = mix(renderTarget, video, clamp(filter5x5(uFilter5x5, uVideo, uv, uResolution), 0.0, 1.0));

    // Hop
    gl_FragColor = video;
  }
