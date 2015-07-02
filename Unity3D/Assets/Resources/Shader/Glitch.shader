Shader "Custom/Glitch" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_SamplerVideo ("Video", 2D) = "white" {}
		_SamplerRenderTarget ("Render Texture", 2D) = "white" {}
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
	    	#define PI 3.141592653589
			#define PI2 6.283185307179

		    struct v2f {
		        float4 pos : SV_POSITION;
		        float2 uv : TEXCOORD0;
                float4 screenUV : TEXCOORD1;
		    };   

			sampler2D _SamplerVideo;
	    	float4 _SamplerVideo_ST; 
			sampler2D _SamplerRenderTarget;
	    	float4 _SamplerRenderTarget_ST; 
			fixed4 _Color;
			float _TimeElapsed;

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
			    // angle += cnoise(uv * 100.0) * 2.0;
			    // float2 offset = float2(abs(angle / PI), clamp(1.0 - dist, 0.0, 1.0));
			    // vec4 rtt = texture2D(uRenderTarget, uv.xx);
			    // float angle = snoise(float2(rtt.rg + rtt.b)) * PI;
			    // float2 p = float2(cos(angle), sin(angle)) * 0.001;
			    // rtt = texture2D(uRenderTarget, uv.yy);
			    // angle = snoise(float2(rtt.rg + rtt.b)) * PI;
			    float2 offset = float2(cos(angle), sin(angle)) * 0.005;
			    // p *= abs(snoise(float2(angle * 70.0,0.0)));
			    // float2 p = float2(0.0, -0.01) * abs(snoise(uv.xx * 200.0));

			    half4 video = tex2D(_SamplerVideo, uv);
			    half4 renderTarget = tex2D(_SamplerRenderTarget, uv - offset);

    			half4 color = lerp(renderTarget * float4(0.99, 0.99, 0.99, 1.0), video, step(0.5, distance(video.rgb, renderTarget.rgb)));

		        return color;
		    }
			ENDCG
		} 
	}
	FallBack "Unlit/Transparent"
}
