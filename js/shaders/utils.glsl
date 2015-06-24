
#define PI 3.141592653589
#define PI2 6.283185307179
#define RADTier 2.094395102
#define RAD2Tier 4.188790205

float oscillation (float t, float speed)
{
  	return sin(t * speed) * 0.5 + 0.5;
}

vec2 segment(vec2 amount, float segments) 
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

float reflectance(vec3 a, vec3 b) 
{ 
	return dot(normalize(a), normalize(b)) * 0.5 + 0.5; 
}

vec2 kaelidoGrid(vec2 p) 
{ 
	return vec2(step(mod(p, 2.0), vec2(1.0))); 
}