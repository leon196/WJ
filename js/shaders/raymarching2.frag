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
vec3 eye = vec3(0.0, 0.0, -1.5);
vec3 front = vec3(0, 0, 1);
vec3 right = vec3(1, 0, 0);
vec3 up = vec3(0, 1, 0);

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
    vec3 ray = normalize(front * mouseWheel + right * uv.x + up * uv.y);
    
    // Color
    vec3 color = shadowColor;
    
    // Raymarching
    float t = 0.0;
    for (int r = 0; r < rayCount; ++r)
    {
        // Ray Position
        vec3 p = eye + ray * t;
        vec3 originP = p;
        
        p = rotateY(rotateX(p, PI2 * mouse.y), PI2 * mouse.x);


        // p = mod(p, vec3(4.0)) - 2.0;
        
        // Transformations
        p = rotateX(rotateY(p, PI2), PIHalf);
        
        // Sphere UV
        vec2 uvSphere = kaelidoGrid(uvOffset + vec2(1.0 - mod(atan(p.y, p.x) / PI + 1.0, 1.0), 1.0 - reflectance(p, eye)) * uvScale);
        color = texture2D(picture1, uvSphere).rgb;

        // Displacement height from luminance
        p -= normalize(p) * terrainHeight * (color.r + color.g + color.b) / 3.0;

        // p += sin(p.z * 10.0 + time) * 0.01;
        // vec3 point = vec3(sphereRadius, 0.0, sphereRadius) * 0.5;
        // p += 0.0 / (eye - originP);//normalize() * log(distance(point, p));
        
        // Distance to Sphere
        float d = sphere(p, sphereRadius);//substraction(sphere(eye - originP, 0.5), sphere(p, sphereRadius));
        
        // Distance min or max reached
        if (d < rayEpsilon || t > rayMax)
        {
            // Sky color from distance
            color = mix(color, texture2D(picture2, uvSphere).rgb, smoothstep(rayMin, rayMax, t));
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