Shader "Custom/SpaceHarrier" {
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

		    struct v2f 
		    {
		        float4 pos : SV_POSITION;
		        float2 uv : TEXCOORD0;
                float4 screenUV : TEXCOORD1;
		    };   

			sampler2D _SamplerVideo;
			sampler2D _SamplerSound;
			sampler2D _SamplerRenderTarget;
	    	float4 _SamplerVideo_ST; 

			float _TimeElapsed;
	    	float _RoundEffect;
	    	float _RoundVideo;
	    	float _RatioBufferTreshold;

	    	float _SamplesTotal;
	    	float _SamplesElapsed;

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
		    	float2 uv = i.screenUV.xy / i.screenUV.w;
		    	
		    	float2 p = uv * 2.0 - 1.0;
		    	p.x *= _ScreenParams.x / _ScreenParams.y;

		    	float distY = length(p.yy) * 4.0;
		    	float dist = length(p.xy) * 1.0;
		    	float angle = atan2(p.y, p.x) / PI + 1.0;

		    	uv = fmod(abs(float2(p.x / distY + _TimeElapsed * 0.01, log(distY) - _TimeElapsed)), 1.0);
		    	// uv = lerp(uv, fmod(abs(float2(angle, dist)), 1.0), cos(_SamplesElapsed * 0.01) * 0.5 + 0.5);

			    float x = uv.x * 2.0;
			    float xMod = fmod(abs(x), 1.0);
			    x = lerp(1.0 - xMod, xMod, fmod(floor(abs(x)), 2.0));

			    float y = uv.y * 2.0;
			    float yMod = fmod(abs(y), 1.0);
			    y = lerp(1.0 - yMod, yMod, fmod(floor(abs(y)), 2.0));

			    uv = float2(x, y);

			    // float2 offset = normalize(float2(0.0, -p.y)) * 0.001 * (1.0  + distY * 4.0);

		    	half4 color = tex2D(_SamplerVideo, uv);
		    	color.rgb *= clamp(distY, 0.0, 1.0);

			    // half4 color = tex2D(_SamplerRenderTarget, uv + offset);

			    // if (distY < 0.01)
			    // {
			    // 	color.rgb = float3(
			    // 		cnoise(float2(_TimeElapsed, _SamplesElapsed * 0.1)), 
			    // 		cnoise(float2(_TimeElapsed * 0.1, _SamplesElapsed * 0.5)), 
			    // 		cnoise(float2(_TimeElapsed * 0.5, _SamplesElapsed)));
			    // }

			    // float oscillo = sin(_TimeElapsed * 10.0) * 0.25 + 0.5;
	


		        return color;
		    }
			ENDCG
		} 
	}
	FallBack "Unlit/Transparent"
}
