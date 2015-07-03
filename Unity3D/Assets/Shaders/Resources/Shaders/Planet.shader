Shader "Custom/Planet" {
	Properties {
	}
	SubShader {
   		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
   		Pass {
		    Cull off
	    	Blend SrcAlpha OneMinusSrcAlpha     
		    ZWrite Off
			LOD 200
			
			CGPROGRAM
			#pragma target 3.0
		    #pragma vertex vert
		    #pragma fragment frag   
	    	#include "UnityCG.cginc"   
	    	#include "Assets/Shaders/Utils.cginc"   
			// https://github.com/ashima/webgl-noise
	    	#include "Assets/Shaders/ClassicNoise2D.cginc"   
	    	#define PI 3.141592653589
			#define PI2 6.283185307179
			#define PIHalf 1.570796327

		    struct v2f {

		        float4 pos : SV_POSITION;
		        float2 uv : TEXCOORD0;
                float4 screenUV : TEXCOORD1;
		    };   

			sampler2D _SamplerVideo;

			sampler2D _SamplerRenderTarget;
	    	float4 _SamplerVideo_ST; 

			float _TimeElapsed;
	    	float _RoundEffect;
	    	float _RoundVideo;
	    	float _RatioBufferTreshold;
	    	float _RatioRandom1;

			#define rayEpsilon 0.00001
			#define rayMin 0.1
			#define rayMax 1000.0

	    	float3 _Eye;
	    	float3 _Front;
	    	float3 _Up;
	    	float3 _Right;

			float2 _ScaleUV;
			float2 _OffsetUV;

			float _Repeat;
			float _DisplacementScale;
			float _PlanetRadius;

			half4 _SkyColor;
			half4 _ShadowColor;
			half4 _GlowColor;

			v2f vert (appdata_full v)
			{
		        v2f o;
		        o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
		        o.uv = TRANSFORM_TEX (v.texcoord, _SamplerVideo);
		        o.screenUV = ComputeScreenPos(o.pos);
		        return o;
		    }

		    half4 frag (v2f i) : COLOR
		    {
		    	// Ray from UV
		    	float2 uv = i.screenUV.xy / i.screenUV.w * 2.0 - 1.0;
		    	uv.x *= _ScreenParams.x / _ScreenParams.y;
			    float3 ray = normalize(_Front + _Right * uv.x + _Up * uv.y);

			    // Color
			    float3 color = _ShadowColor;

			    // Raymarching
			    const int rayCount = 32;
			    float t = 0.0;
			    for (int r = 0; r < rayCount; ++r)
			    {
			        // Ray Position
			        float3 p = _Eye + ray * t;
			        float3 originP = p;

			        p = rotateX(p, _TimeElapsed * 0.5);
			        p = rotateY(p, _TimeElapsed * 0.5);

			        // Sphere _V
			        float x = atan2(p.z, p.x) / PI / 2.0 + 0.5;
			        float y = acos(p.y / length(p)) / PI;
			     //    float2 uvSphere = kaelidoGrid(_OffsetUV + float2(x, y) * _ScaleUV.xy);

				    // float2 uvSphereMod = fmod(abs(uvSphere), 1.0);
				    // uvSphere = lerp(1.0 - uvSphereMod, uvSphereMod, fmod(floor(abs(uvSphere)), 2.0));

				    x *= _ScaleUV.x;
				    x += _TimeElapsed * 0.2 * lerp(-1.0, 1.0,  fmod(floor(x), 2.0));
				    float xMod = fmod(abs(x), 1.0);
				    x = lerp(1.0 - xMod, xMod, fmod(floor(abs(x)), 2.0));

				    y *= _ScaleUV.y;
				    y += _TimeElapsed * 0.2 * lerp(-1.0, 1.0,  fmod(floor(y), 2.0));
				    float yMod = fmod(abs(y), 1.0);
				    y = lerp(1.0 - yMod, yMod, fmod(floor(abs(y)), 2.0));

			        color = tex2D(_SamplerVideo, float2(x, y)).rgb;

			        // Displacement height from luminance
			        p -= normalize(p) * _PlanetRadius * (color.r + color.g + color.b) / 3.0;

			        // Distance to Sphere
			        float d = substraction(sphere(_Eye - originP, 0.1), sphere(p, _PlanetRadius));

			        // Distance min or max reached
			        if (d < rayEpsilon || t > rayMax)
			        {
			            // Sky color from distance
			            color = lerp(color, _SkyColor, smoothstep(rayMin, rayMax, t));
			            // Shadow from ray count
			            color = lerp(color, lerp(_GlowColor, _ShadowColor, reflectance(originP, _Eye)), float(r) / float(rayCount));
			            break;
			        }

			        // Distance field step
			        t += d;
			    }

			    // Hop
			    return float4(color, 1.0);
		    }
			ENDCG
		} 
	}
	FallBack "Unlit/Transparent"
}
