Shader "Custom/GlitchScanline" {
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
		    	
		    	// float2 p = uv * 2.0 - 1.0;
		    	// p.x *= _ScreenParams.x / _ScreenParams.y;

		    	// float seed = luminance(tex2D(_SamplerRenderTarget, uv).rgb);
		    	float random = rand(uv.yy) * 2.0 - 1.0;

		    	// float dist = length(p);

		    	float angle = 0.0;//_TimeElapsed;

		    	// float angle = atan2(p.y, p.x);

		    	float lum = luminance(tex2D(_SamplerRenderTarget, uv));
		    	lum = clamp(lum, 0.1, 1.0);
		    	// angle = ;
		    	// tex2D(_SamplerSound, float2(angle / PI * 0.5 + 0.5, 0.0)).r
		    	float sample = clamp(_SamplesTotal, 0.1, 0.5);

		    	float2 offset = float2(1.0, 0.0) * random * 0.05 * _SamplesTotal;

		    	// float seed = luminance(tex2D(_SamplerRenderTarget, uv).rgb);
		    	// float random = rand(uv);
		    	// angle = random * PI2;
		    	// offset += float2(cos(angle), sin(angle)) * 0.001;

			    half4 video = tex2D(_SamplerVideo, uv - offset);
			    half4 renderTarget = tex2D(_SamplerRenderTarget, uv);

			    float radius = 0.01 * sample;

				renderTarget.r = tex2D(_SamplerRenderTarget, uv + float2(cos(angle), 				sin(angle)) 				* radius).r;
				renderTarget.g = tex2D(_SamplerRenderTarget, uv + float2(cos(angle + 2.094395102), 	sin(angle + 2.094395102)) 	* radius).g;
				renderTarget.b = tex2D(_SamplerRenderTarget, uv + float2(cos(angle + 4.188790205), 	sin(angle + 4.188790205)) 	* radius).b;

			    // float oscillo = sin(_TimeElapsed * 10.0) * 0.25 + 0.5;

    			half4 color = lerp(renderTarget, video, step(sample, distance(video.rgb, renderTarget.rgb)));
	

				// float sound = tex2D(_SamplerSound, uv);
				// color = half4(sound, sound, sound, 1.0);

		        return color;
		    }
			ENDCG
		} 
	}
	FallBack "Unlit/Transparent"
}
