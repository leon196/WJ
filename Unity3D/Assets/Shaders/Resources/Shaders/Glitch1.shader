Shader "Custom/Glitch1" {
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

		    	float dist = length(p);
		    	float angle = atan2(p.y, p.x);

		    	float lumVideo = luminance(tex2D(_SamplerVideo, uv));
		    	float lumBuffer = luminance(tex2D(_SamplerRenderTarget, uv));

		    	float2 offset = float2(cos(angle), sin(angle)) * 0.1 * _SamplesTotal * dist * lumBuffer;// * sqrt(dist) * clamp(lum * 4.0, 0.0, 1.0);

		    	float sample = lerp(0.25, 0.8, _SamplesTotal);

		    	// float seed = luminance(tex2D(_SamplerRenderTarget, uv).rgb);
		    	// float random = cnoise(float2(lum, _SamplesElapsed * 0.0001));
		    	float random = rand(lumVideo);
		    	angle = random * PI2;// + _SamplesTotal;
		    	offset += float2(cos(angle), sin(angle)) * 0.002 * _SamplesTotal;// * (1.0 + _SamplesTotal * 4.0);

			    half4 video = tex2D(_SamplerVideo, uv);

			    half4 renderTarget = tex2D(_SamplerRenderTarget, uv - offset);
			    // half4 renderTarget = cheesyBlur(_SamplerRenderTarget, uv - offset, _ScreenParams.xy);

    			// half4 color = lerp(renderTarget, video, step(sample, luminance(abs(video - renderTarget))));
    			half4 color = lerp(renderTarget, video, step(sample, length(video - renderTarget)));
    			color = lerp(color, video, clamp(filter(_SamplerVideo, uv, _ScreenParams.xy), 0.0, 1.0));

				color.a = 1.0;

		        return color;
		    }
			ENDCG
		} 
	}
	FallBack "Unlit/Transparent"
}
