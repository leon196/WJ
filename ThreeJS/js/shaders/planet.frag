// thank to @iquilezles -> http://www.iquilezles.org/www/index.htm
// thank to @uint9 -> http://9bitscience.blogspot.fr/2013/07/raymarching-distance-fields_14.html

#include utils.glsl
#include uniforms.glsl

#define rayCount 64
#define rayEpsilon 0.00001
#define rayMin 0.1
#define rayMax 1000.0

uniform sampler2D uSamplerPlanet;
uniform sampler2D uSamplerBackground;
uniform vec3 uEye;
uniform vec3 uFront;
uniform vec3 uUp;
uniform vec3 uRight;
uniform vec2 uScaleUV;
uniform vec2 uOffsetUV;
uniform float uRepeat;
uniform float uDisplacementScale;
uniform float uPlanetRadius;
uniform float uRatioMagma;
uniform float uRatioSky;

varying vec2 vUv;

// Colors
vec3 skyColor = vec3(0.3);
vec3 shadowColor = vec3(0, 0, 0);
vec3 glowColor = vec3(1.0);

void main()
{
    // Ray from UV
    vec2 uv = gl_FragCoord.xy / uResolution.xy * 2.0 - 1.0;
    // vec2 uv = vUv * 2.0 - 1.0;
    uv.x *= uResolution.x / uResolution.y;

    vec3 ray = normalize(uFront + uRight * uv.x + uUp * uv.y);

    // Color
    vec3 color = shadowColor;

    // Raymarching
    float t = 0.0;
    for (int r = 0; r < rayCount; ++r)
    {
        // Ray Position
        vec3 p = uEye + ray * t;
        vec3 originP = p;

        p = mix(p, grid(p, vec3(4.0)), uRepeat);

        // Sphere UV
        float x = atan(p.z, p.x) / PI / 2.0 + 0.5;
        float y = acos(p.y / length(p)) / PI;
        vec2 uvSphere = kaelidoGrid(uOffsetUV + vec2(x, y) * uScaleUV);
        color = texture2D(uSamplerPlanet, vec2(x,y)).rgb;

        // Displacement height from luminance
        p -= normalize(p) * uPlanetRadius * (color.r + color.g + color.b) / 3.0;

        // Distance to Sphere
        float d = substraction(sphere(uEye - originP, 0.1), sphere(p, uPlanetRadius));

        // Distance min or max reached
        if (d < rayEpsilon || t > rayMax)
        {
            // color += (step(mod(x, 0.01), 0.0001) + step(mod(y, 0.01), 0.0001));
            // Sky color from distance
            color = mix(color, texture2D(uSamplerBackground, vec2(x,y)).rgb, smoothstep(rayMin, rayMax, t));
            // Shadow from ray count
            color = mix(color, mix(glowColor, shadowColor, reflectance(originP, uEye)), float(r) / float(rayCount));

            // Glow from ray direction
            // color = mix(glowColor, shadowColor, reflectance(originP, eye));
            break;
        }

        // Distance field step
        t += d;
    }

    // Magma
    color = mix(color, 0.25 / color, uRatioMagma);

    // Hop
    gl_FragColor = vec4(color, 1.0);
}
