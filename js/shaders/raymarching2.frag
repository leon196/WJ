// thank to @iquilezles -> http://www.iquilezles.org/www/index.htm
// thank to @uint9 -> http://9bitscience.blogspot.fr/2013/07/raymarching-distance-fields_14.html

#include utils.glsl
#include uniforms.glsl

varying vec2 vUv;

// Raymarching
#define rayCount 64
#define rayEpsilon 0.00001
#define rayMin 0.1
#define rayMax 1000.0

// Camera
uniform vec3 eye;
uniform vec3 front;
uniform vec3 up;
uniform vec3 right;

uniform float repeat;

// Colors
vec3 skyColor = vec3(0.3);
vec3 shadowColor = vec3(0, 0, 0);
vec3 glowColor = vec3(1.0);

void main()
{
    // Ray from UV
    vec2 uv = gl_FragCoord.xy / screenSize.xy * 2.0 - 1.0;
    // vec2 uv = vUv * 2.0 - 1.0;
    uv.x *= screenSize.x / screenSize.y;

    vec3 ray = normalize(front + right * uv.x + up * uv.y);
    
    // Color
    vec3 color = shadowColor;
    
    // Raymarching
    float t = 0.0;
    for (int r = 0; r < rayCount; ++r)
    {
        // Ray Position
        vec3 p = eye + ray * t;
        vec3 originP = p;

        p = mix(p, grid(p, vec3(4.0)), repeat);
        
        // Sphere UV
        float x = atan(p.z, p.x) / PI / 2.0 + 0.5;
        float y = acos(p.y / length(p)) / PI;
        // vec2 uvSphere = kaelidoGrid(uvOffset + vec2(x, y) * uvScale);
        color = texture2D(picture1, vec2(x,y)).rgb;

        // Displacement height from luminance
        p -= normalize(p) * terrainHeight * (color.r + color.g + color.b) / 3.0;
        
        // Distance to Sphere
        float d = substraction(sphere(eye - originP, 0.1), sphere(p, sphereRadius));
        
        // Distance min or max reached
        if (d < rayEpsilon || t > rayMax)
        {
            // Sky color from distance
            color = mix(color, texture2D(picture2, vec2(x,y)).rgb, smoothstep(rayMin, rayMax, t));
            // Shadow from ray count
            color = mix(color, mix(glowColor, shadowColor, reflectance(originP, eye)), float(r) / float(rayCount));
            // Glow from ray direction
            // color = mix(glowColor, shadowColor, reflectance(originP, eye));
            break;
        }
        
        // Distance field step
        t += d;
    }

    // Magma
    color = mix(color, 0.25 / color, ratioMagma);

    // Hop
    gl_FragColor = vec4(color, 1.0);
}