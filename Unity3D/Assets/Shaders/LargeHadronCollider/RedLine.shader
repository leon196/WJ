Shader "LargeHadronCollider/RedLine" {
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

        struct v2f {
          float4 pos : SV_POSITION;
          float2 uv : TEXCOORD0;
          float3 wpos : TEXCOORD1;
        };

        sampler2D _MainTex;
        float4 _MainTex_ST;
        fixed4 _Color;

        v2f vert (appdata_full v)
        {
          v2f o;
          o.wpos = mul(_Object2World, v.vertex).xyz;
          o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
          o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
          return o;
        }

        half4 frag (v2f i) : COLOR
        {
          half4 color = _Color;
          float t = _Time * 12.0;
          color.a = step(fmod(i.wpos.x / 4.0 + t, 1.0), 0.5);
          return color;
        }
        ENDCG
      }
    }
    FallBack "Unlit/Transparent"
  }
