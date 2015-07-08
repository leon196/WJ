
float oscillation (float t, float speed)
{
  	return sin(t * speed) * 0.5 + 0.5;
}

float segment(float amount, float segments)
{
	return floor(amount * segments) / segments;
}

float2 pixelize(float2 uv, float segments)
{
	return floor(uv * segments) / segments;
}

float4 posterize ( float4 color, float segments )
{
	return float4(floor(color.rgb * segments) / segments, 1.0);
}

float2 videoUV (float2 uv)
{
	return float2(uv.x, 1.0 - uv.y);
}

float2 wrapUV (float2 uv)
{
	return fmod(abs(uv), 1.0);
}

float2 kaelidoGrid(float2 p)
{
	return fmod(lerp(p, 1.0 - p, float2(step(fmod(p, 2.0), float2(1.0, 1.0)))), 1.0);
}

float kaleido (float d, float t)
{
  d += t * lerp(-1.0, 1.0, fmod(floor(abs(d)), 2.0));
  float dMod = fmod(abs(d), 1.0);
  return lerp(1.0 - dMod, dMod, fmod(floor(abs(d)), 2.0));
}

float2 mouseFromCenter (float2 mouse, float2 resolution)
{
	mouse /= resolution;
	mouse = (mouse - float2(0.5, 0.5)) * 2.0;
	mouse.y *= -1.0;
	return mouse;
}

float luminance ( float3 color )
{
	return (color.r + color.g + color.b) / 3.0;
}

float reflectance(float3 a, float3 b)
{
	return dot(normalize(a), normalize(b)) * 0.5 + 0.5;
}

half4 filter (sampler2D bitmap, float2 uv, float2 dimension)
{
  half4 color = half4(0.0, 0.0, 0.0, 0.0);
  
  color += -1.0 * tex2D(bitmap, uv + float2(-2, -2) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2(-2, -1) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2(-2,  0) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2(-2,  1) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2(-2,  2) / dimension);

  color += -1.0 * tex2D(bitmap, uv + float2(-1, -2) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2(-1, -1) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2(-1,  0) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2(-1,  1) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2(-1,  2) / dimension);

  color += -1.0 * tex2D(bitmap, uv + float2( 0, -2) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2( 0, -1) / dimension);
  color += 24.0 * tex2D(bitmap, uv + float2( 0,  0) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2( 0,  1) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2( 0,  2) / dimension);

  color += -1.0 * tex2D(bitmap, uv + float2( 1, -2) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2( 1, -1) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2( 1,  0) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2( 1,  1) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2( 1,  2) / dimension);
  
  color += -1.0 * tex2D(bitmap, uv + float2( 2, -2) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2( 2, -1) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2( 2,  0) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2( 2,  1) / dimension);
  color += -1.0 * tex2D(bitmap, uv + float2( 2,  2) / dimension);

  return color;
}

half4 cheesyBlur (sampler2D bitmap, float2 uv, float2 dimension)
{
  half4 color = half4(0.0, 0.0, 0.0, 0.0);
  
  color += 0.2 * tex2D(bitmap, uv + float2(-1, -1) / dimension);
  color += 0.2 * tex2D(bitmap, uv + float2(-1,  0) / dimension);
  color += 0.2 * tex2D(bitmap, uv + float2(-2,  0) / dimension);
  color += 0.2 * tex2D(bitmap, uv + float2( 0, -1) / dimension);
  color += 0.2 * tex2D(bitmap, uv + float2( 0,  0) / dimension);

  return color;
}

// http://stackoverflow.com/questions/12964279/whats-the-origin-of-this-glsl-rand-one-liner
float rand(float2 co)
{
  return frac(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
}

// From Anton Roy -> https://www.shadertoy.com/view/Xs23DG
// float4 filter5x5 (float filter[25], sampler2D bitmap, float2 uv, float2 dimension)
// {
//   float4 color = float4(0.0, 0.0, 0.0, 0.0);
//   for (int i = 0; i < 5; ++i)
//     for (int j = 0; j < 5; ++j)
//       color += filter[i * 5 + j] * tex2D(bitmap, uv + float2(i - 2, j - 2) / dimension);
//   return color;
// }

// by inigo quilez

float3 rotateY(float3 v, float t)
{
    float cost = cos(t); float sint = sin(t);
    return float3(v.x * cost + v.z * sint, v.y, -v.x * sint + v.z * cost);
}
float3 rotateX(float3 v, float t)
{
    float cost = cos(t); float sint = sin(t);
    return float3(v.x, v.y * cost - v.z * sint, v.y * sint + v.z * cost);
}

float sphere( float3 p, float s )
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

float3 grid(float3 p, float3 size)
{
  return fmod(p, size) - size * 0.5;
}

// hash based 3d value noise
// function taken from https://www.shadertoy.com/view/XslGRr
// Created by inigo quilez - iq/2013
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.

// ported from GLSL to HLSL
float hash( float n )
{
    return frac(sin(n)*43758.5453);
}

float noise( float3 x )
{
    // The noise function returns a value in the range -1.0f -> 1.0f
    float3 p = floor(x);
    float3 f = frac(x);
    f       = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0 + 113.0*p.z;
    return lerp(lerp(lerp( hash(n+0.0), hash(n+1.0),f.x),
                   lerp( hash(n+57.0), hash(n+58.0),f.x),f.y),
               lerp(lerp( hash(n+113.0), hash(n+114.0),f.x),
                   lerp( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
}
