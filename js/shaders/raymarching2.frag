// thank to @iquilezles -> http://www.iquilezles.org/www/index.htm
// thank to @uint9 -> http://9bitscience.blogspot.fr/2013/07/raymarching-distance-fields_14.html

#include utils.glsl

varying vec2 vUv;
uniform vec2 bufferSize;
uniform vec2 screenSize;
uniform vec2 mouse;
uniform float mouseWheel;
uniform float time;
uniform sampler2D picture1;
uniform sampler2D picture2;
uniform sampler2D video;
uniform sampler2D fbo;

// Raymarching
const float rayEpsilon = 0.01;
const float rayMin = 0.1;
const float rayMax = 10.0;
const int rayCount = 8;

// Camera
vec3 eye = vec3(0.01, 0.01, -1.5);
vec3 front = vec3(0, 0, 1);
vec3 right = vec3(1, 0, 0);
vec3 up = vec3(0, 1, 0);

// Animation
vec2 uvScale1 = vec2(1.0);
vec2 uvScale2 = vec2(0.5);
float terrainHeight = 0.1;
float sphereRadius = 0.9;
float translationSpeed = 0.001;
float rotationSpeed = 0.1;

// Colors
vec3 skyColor = vec3(0, 0, 0);
vec3 shadowColor = vec3(0, 0, 0);

void main()
{
    // Ray from UV
    vec2 uv = gl_FragCoord.xy / screenSize.xy * 2.0 - 1.0;
    uv.x *= screenSize.x / screenSize.y;
    float fov = 1.0 + 1.0 * mouseWheel;
    vec3 ray = normalize(front * fov + right * uv.x + up * uv.y);
    
    // Color
    vec3 color = shadowColor;
    
    // Animation
    float translationTime = time * translationSpeed;
    
    // Raymarching
    float t = 0.0;
    for (int r = 0; r < rayCount; ++r)
    {
        // Ray Position
        vec3 p = eye + ray * t;
        vec3 originP = p;

        float sphereCamera = sphere(p - eye, 0.1);
        
        p = rotateX(p, PI2 * mouse.y);
        p = rotateY(p, PI2 * mouse.x);

        //p = mod(p, vec3(4.0)) - 2.0;
        
        // Transformations
        p = rotateY(p, PIHalf);
        p = rotateX(p, PIHalf);
        vec2 translate = vec2(0.0, translationTime);
        
        // Sphere UV
        float angleXY = atan(p.y, p.x);
        float angleXZ = atan(p.z, p.x);
        // vec2 sphereP1 = vec2(angleXY / PI, 1.0 - reflectance(p, eye)) * uvScale1;
        vec2 sphereP2 = vec2(angleXY / PI, reflectance(p, eye)) * uvScale2;
        // sphereP1 += 0.5;
        // mix(vec2(-translationTime), vec2(translationTime), 
        //                 vec2(step(angleXY, 0.0), step(angleXZ, 0.0)));
        sphereP2 += mix(vec2(translationTime), vec2(-translationTime), 
                        vec2(step(angleXY, 0.0), step(angleXZ, 0.0)));
        // vec2 uv1 = mod(mix(sphereP1, 1.0 - sphereP1, kaelidoGrid(sphereP1)), 1.0);
        vec2 uv2 = mod(mix(sphereP2, 1.0 - sphereP2, kaelidoGrid(sphereP2)), 1.0);
        
        // Texture color
        vec2 sphereP1 = vec2(1.0 - mod(angleXY / PI + 1.0, 1.0), 1.0 - reflectance(p, eye));
        vec3 texture = texture2D(picture1, abs(sphereP1)).rgb;
        color = texture;

        // Texture Merge
        vec3 texture2 = vec3(noise(vec3(time*0.01,time*0.1,time) + texture2D(picture1, uv2).rgb));
        float water = texture.b - texture.g - texture.r;
        texture = mix(texture, texture2, clamp(water + 0.7, 0.0, 1.0));
        
        // Height from luminance
        float height = (texture.r + texture.g + texture.b) / 3.0;
        // heigh = mix(height, noise(texture2));

        // Displacement
        p -= normalize(p) * terrainHeight * height;// * reflectance(p, eye);
        
        // Distance to Sphere
        float d = substraction(sphereCamera, sphere(p, sphereRadius));
        
        // Distance min or max reached
        if (d < rayEpsilon || t > rayMax)
        {
            // Shadow from ray count
            color = mix(color, shadowColor, float(r) / float(rayCount));
            // Sky color from distance
            color = mix(color, skyColor, smoothstep(rayMin, rayMax, t));
            break;
        }
        
        // Distance field step
        t += d;
    }

    // Hop
    gl_FragColor = vec4(color, 1.0);
}