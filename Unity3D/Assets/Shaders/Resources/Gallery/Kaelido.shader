Shader "Custom/Kaelido" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Texture (RGB)", 2D) = "white" {}
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
			#define PIHalf 1.570796327
			#define RADTier 2.094395102
			#define RAD2Tier 4.188790205

		    struct v2f {
		        float4 pos : SV_POSITION;
		        float2 uv : TEXCOORD0;
                float4 screenUV : TEXCOORD1;
		    };   

			sampler2D _MainTex;
	    	float4 _MainTex_ST; 
			fixed4 _Color;
			float _TimeElapsed;

			v2f vert (appdata_full v)
			{
		        v2f o;
		        o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
		        o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
		        o.screenUV = ComputeScreenPos(o.pos);
		        return o;

		    }

		    half4 frag (v2f i) : COLOR
		    {
		    	float2 uv = i.screenUV.xy / i.screenUV.w * 2.0 - 1.0;
		    	uv.x *= _ScreenParams.x / _ScreenParams.y;

			    float dist = length(uv);
			    float angle = atan2(uv.y, uv.x) - PIHalf;

			    float a = abs(angle) / PI * 3.0;
			    a += _TimeElapsed * 0.2 * lerp(-1.0, 1.0,  fmod(floor(a), 2.0));
			    float aMod = fmod(abs(a), 1.0);
			    a = lerp(1.0 - aMod, aMod, fmod(floor(abs(a)), 2.0));

			    float d = dist * 2.0;
			    d += _TimeElapsed * 0.4 * lerp(-1.0, 1.0, fmod(floor(abs(d)), 2.0));
			    float dMod = fmod(abs(d), 1.0);
			    d = lerp(1.0 - dMod, dMod, fmod(floor(abs(d)), 2.0));

			    uv = fmod(float2(a, d), 1.0);

		        return tex2D(_MainTex, uv);
		    }
			ENDCG
		} 
	}
	FallBack "Unlit/Transparent"
}
