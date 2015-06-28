
#define PI 3.141592653589
#define PI2 6.283185307179
#define PIHalf 1.570796327
#define RADTier 2.094395102
#define RAD2Tier 4.188790205

float oscillation (float t, float speed)
{
  	return sin(t * speed) * 0.5 + 0.5;
}

float segment(float amount, float segments) 
{ 
	return floor(amount * segments) / segments; 
}

vec2 pixelize(vec2 uv, float segments) 
{ 
	return floor(uv * segments) / segments; 
}

vec4 posterize ( vec4 color, float segments ) 
{ 
	return vec4(floor(color.rgb * segments) / segments, 1.0); 
}

vec2 videoUV (vec2 uv)
{
	return vec2(uv.x, 1.0 - uv.y);
}

vec2 wrapUV (vec2 uv)
{
	return mod(abs(uv), 1.0);
}

vec2 kaelidoGrid(vec2 p) 
{ 
	return mod(mix(p, 1.0 - p, vec2(step(mod(p, 2.0), vec2(1.0)))), 1.0); 
}

vec2 mouseFromCenter (vec2 mouse, vec2 resolution)
{
	mouse /= resolution;
  	mouse = (mouse - vec2(0.5)) * 2.0;
  	mouse.y *= -1.0;
  	return mouse;
}

float luminance ( vec3 color ) 
{ 
	return (color.r + color.g + color.b) / 3.0; 
}

float reflectance(vec3 a, vec3 b) 
{ 
	return dot(normalize(a), normalize(b)) * 0.5 + 0.5; 
}

// by inigo quilez

vec3 rotateY(vec3 v, float t)
{
    float cost = cos(t); float sint = sin(t);
    return vec3(v.x * cost + v.z * sint, v.y, -v.x * sint + v.z * cost);
}
vec3 rotateX(vec3 v, float t)
{
    float cost = cos(t); float sint = sin(t);
    return vec3(v.x, v.y * cost - v.z * sint, v.y * sint + v.z * cost);
}

float sphere( vec3 p, float s ) 
{ 
	return length(p)-s; 
}

float addition( float d1, float d2 )
{
    return min(d1,d2);
}

float substraction( float d1, float d2 )
{
    return max(-d1,d2);
}

float intersection( float d1, float d2 )
{
    return max(d1,d2);
}

vec3 grid(vec3 p, vec3 size)
{
  return mod(p, size) - size * 0.5;
}

// hash based 3d value noise
// function taken from https://www.shadertoy.com/view/XslGRr
// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

// ported from GLSL to HLSL
float hash( float n )
{
    return fract(sin(n)*43758.5453);
}

float noise( vec3 x )
{
    // The noise function returns a value in the range -1.0f -> 1.0f
    vec3 p = floor(x);
    vec3 f = fract(x);
    f       = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0 + 113.0*p.z;
    return mix(mix(mix( hash(n+0.0), hash(n+1.0),f.x),
                   mix( hash(n+57.0), hash(n+58.0),f.x),f.y),
               mix(mix( hash(n+113.0), hash(n+114.0),f.x),
                   mix( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
}
