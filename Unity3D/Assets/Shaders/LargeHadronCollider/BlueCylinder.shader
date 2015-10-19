Shader "LargeHadronCollider/BlueCylinder" {
  Properties {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Texture (RGB)", 2D) = "white" {}
      _Size ("Size", Range(0, 1.0)) = 0.01
      _Scale ("Scale", Range(0, 1.0)) = 0.01
      _Offset ("Offset", Range(0, 1.0)) = 0.01
    }
    SubShader {
      Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
      Pass {
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 200
        Cull Off
        ZWrite Off

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #include "UnityCG.cginc"
        #include "../noise3D.cginc"

				struct GS_INPUT
				{
					float4 pos		: POSITION;
					float3 normal	: NORMAL;
					float2 uv	: TEXCOORD0;
          float4 screenUV : TEXCOORD1;
          half4 color : COLOR;
				};

        struct FS_INPUT {
          float4 pos : SV_POSITION;
          float2 uv : TEXCOORD0;
          float4 screenUV : TEXCOORD1;
          half4 color : COLOR;
          float3 normal : NORMAL;
        };

        sampler2D _MainTex;
        float4 _MainTex_ST;
        fixed4 _Color;
        float _Size;
        float _Scale;
        float _Offset;

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

        float rand ( float2 seed ){ return frac(sin(dot(seed.xy ,float2(12.9898,78.233))) * 43758.5453); }

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

        float3 segment(float3 amount, float segments)
        {
        	return floor(amount * segments) / segments;
        }


        GS_INPUT vert (appdata_full v)
        {
          GS_INPUT o = (GS_INPUT)0;
          /*float t = cos(_Time * 60.0) * 0.5 + 0.5;
          float angle = pow(length(v.vertex.xyz) * 2.0 + 1.0, 2.0) * t;
          v.vertex.xyz = rotateY(v.vertex.xyz, angle);
          v.vertex.xyz = rotateX(v.vertex.xyz, angle);*/
          float3 localPos = mul(UNITY_MATRIX_MVP, v.vertex);
          float seed = segment(localPos.yyy * 200.0, 2.0);
          float rnd = noise(seed) * 0.5 + 0.5;
          v.vertex.xz *= 1.0 + rnd;
          o.pos =  mul(UNITY_MATRIX_MVP, v.vertex);
          o.normal = v.normal;
          o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
          o.screenUV = ComputeScreenPos(o.pos);
          o.color = half4(rnd, rnd, rnd, 1.0);
          return o;
        }

        half4 frag (FS_INPUT i) : COLOR
        {
          half4 color = _Color;
          color.rgb *= clamp(Luminance(i.normal * 0.5 + 0.5) * 2.0, 0.0, 1.0);
          color.rgb *= Luminance(i.color);
          return color;
        }
        ENDCG
      }
    }
    FallBack "Unlit/Transparent"
  }
