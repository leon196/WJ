Shader "Custom/Glitch2" {
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

		    	float dist = length(p.xy);
		    	float angle = atan2(p.y, p.x);

		    	float lum = luminance(tex2D(_SamplerRenderTarget, uv));


		    	// angle += _TimeElapsed;

		    	float2 offset = float2(cos(angle), sin(angle)) * 0.002 * (1.0 + _SamplesTotal);

		    	angle = rand(lum) * PI2 + _SamplesElapsed * 0.01;
		    	offset += float2(cos(angle), sin(angle)) * 0.001 * (1.0 + _SamplesTotal + dist * 2.0);

			    half4 video = tex2D(_SamplerVideo, uv);
			    half4 renderTarget = tex2D(_SamplerRenderTarget, uv - offset);

    			half4 color = renderTarget;//lerp(renderTarget, video, step(0.5, distance(video.rgb, renderTarget.rgb)));
    			// color *= 0.97;
    			color.a = 1.0;
			    if (dist < 0.004 + 0.01 * _SamplesTotal)
			    {
			    	color.rgb = float3(
			    		0.5 + 0.5 * rand(float2(0, _SamplesElapsed * 0.01)), 
			    		0.5 + 0.5 * rand(float2(0, _SamplesElapsed * 0.05)), 
			    		0.5 + 0.5 * rand(float2(0, _SamplesElapsed * 0.03)));
			    }

		        return color;
		    }
			ENDCG
		} 
	}
	FallBack "Unlit/Transparent"
}
