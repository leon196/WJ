// thank to @iquilezles -> http://www.iquilezles.org/www/index.htm
// thank to @uint9 -> http://9bitscience.blogspot.fr/2013/07/raymarching-distance-fields_14.html

#include utils.glsl

varying vec2 vUv;
uniform vec2 bufferSize;
uniform vec2 screenSize;
uniform vec2 mouse;
uniform sampler2D picture;
uniform sampler2D video;
uniform sampler2D fbo;

// Raymarching
const float rayEpsilon = 0.001;
const float rayMin = 0.1;
const float rayMax = 1000.0;
const int rayCount = 32;

// Camera
vec3 eye = vec3(1.0, 1.0, -10.0);
vec3 front = vec3(0, 0, 1);
vec3 right = vec3(1, 0, 0);
vec3 up = vec3(0, 1, 0);

// Animation
vec2 uvScale1 = vec2(2.0);
vec2 uvScale2 = vec2(2.0);
float terrainHeight = 0.9;
float sphereRadius = 0.9;
float translationSpeed = 0.4;
float rotationSpeed = 0.1;

// Colors
vec3 skyColor = vec3(0, 0, 0.1);
vec3 shadowColor = vec3(0.1, 0, 0);

void main()
{
    // Ray from UV
    vec2 uv = vUv.xy * 2.0 - 1.0;
    uv.x *= screenSize.x / screenSize.y;
    vec3 ray = normalize(front + right * uv.x + up * uv.y);
    
    // Color
    vec3 color = shadowColor;
    
    // Animation
    float translationTime = 0.0;//time * translationSpeed;
    
    // Raymarching
    float t = 0.0;
    for (int r = 0; r < rayCount; ++r)
    {
        // Ray Position
        vec3 p = eye + ray * t;
        vec3 originP = p;

        float sphereCamera = sphere(p - eye, 1.0);
        
        p = rotateX(p, PI2 * mouse.y);
        p = rotateY(p, PI2 * mouse.x);

        p = mod(p, vec3(4.0)) - 2.0;
        
        // Transformations
        p = rotateY(p, PIHalf);
        p = rotateX(p, PIHalf);
        vec2 translate = vec2(0.0, translationTime);
        
        // Sphere UV
        float angleXY = atan(p.y, p.x);
        float angleXZ = atan(p.z, p.x);
        vec2 sphereP1 = vec2(angleXY / PI, 1.0 - reflectance(p, eye)) * uvScale1;
        vec2 sphereP2 = vec2(angleXY / PI, reflectance(p, eye)) * uvScale2;
        sphereP1 += 0.5;
        sphereP2 += mix(vec2(translationTime), vec2(-translationTime), 
                        vec2(step(angleXY, 0.0), step(angleXZ, 0.0)));
        vec2 uv1 = mod(mix(sphereP1, 1.0 - sphereP1, kaelidoGrid(sphereP1)), 1.0);
        vec2 uv2 = mod(mix(sphereP2, 1.0 - sphereP2, kaelidoGrid(sphereP2)), 1.0);
        
        // Texture
        vec3 texture = texture2D(video, uv1).rgb;
        // vec3 texture2 = texture2D(picture, uv2).rgb;

        // vec2 direction = normalize(videoUV(vUv) - vec2(0.5)) * 8.0;
        // vec3 texture = blur(video, uv1, screenSize, direction).rgb;
        color = texture;
        
        // Height from luminance
        float luminance = (texture.r + texture.g + texture.b) / 3.0;
        //texture = mix(texture, texture2, 1.0 - step(texture.g - texture.r - texture.b, -0.3));
        luminance = (texture.r + texture.g + texture.b) / 3.0;
        // luminance = sin(luminance / 0.6355);

        // Displacement
        p -= normalize(p) * terrainHeight * luminance * reflectance(originP, eye);
        
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