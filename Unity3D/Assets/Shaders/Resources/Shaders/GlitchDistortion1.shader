Shader "Custom/GlitchDistortion1" {
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
		    #pragma vertex vert
		    #pragma fragment frag   
	    	#include "UnityCG.cginc"   
	    	#include "Assets/Shaders/Utils.cginc"   
			// https://github.com/ashima/webgl-noise
	    	#include "Assets/Shaders/ClassicNoise2D.cginc"   
	    	#define PI 3.141592653589
			#define PI2 6.283185307179

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
			    float2 offset = float2(cos(angle), sin(angle)) * dist * 0.01;

		    	// float random = cnoise(uv * (1.0 + 2.0 * _RatioRandom1) + float2(_TimeElapsed * 0.01, 0.0));
		    	// float angle = random * PI2;
		    	// float2 offset = float2(cos(angle), sin(angle)) * 0.003;

			    half4 video = tex2D(_SamplerVideo, uv);
			    half4 renderTarget = tex2D(_SamplerRenderTarget, uv + offset);

    			half4 color = lerp(renderTarget, video, step(0.75, distance(video.rgb, renderTarget.rgb)));

		        return color;
		    }
			ENDCG
		} 
	}
	FallBack "Unlit/Transparent"
}
