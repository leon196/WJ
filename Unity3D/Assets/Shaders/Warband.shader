Shader "Custom/Warband" {
  Properties {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Texture (RGB)", 2D) = "white" {}
      _Size ("Size", Range(0, 1.0)) = 0.01
    }
    SubShader {
      Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
      Pass {
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 200
        Cull Back
        ZWrite Off

        CGPROGRAM
        #pragma vertex vert
        #pragma geometry geom
        #pragma fragment frag
        #include "UnityCG.cginc"

				struct GS_INPUT
				{
					float4 pos		: POSITION;
					float3 normal	: NORMAL;
					float2 uv	: TEXCOORD0;
          float4 screenUV : TEXCOORD1;
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


        GS_INPUT vert (appdata_full v)
        {
          GS_INPUT o = (GS_INPUT)0;
          /*float t = cos(_Time * 60.0) * 0.5 + 0.5;
          float angle = pow(length(v.vertex.xyz) * 2.0 + 1.0, 2.0) * t;
          v.vertex.xyz = rotateY(v.vertex.xyz, angle);
          v.vertex.xyz = rotateX(v.vertex.xyz, angle);*/
          o.pos =  mul(_Object2World, v.vertex);
          o.normal = v.normal;
          o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
          o.screenUV = ComputeScreenPos(o.pos);
          return o;
        }

        [maxvertexcount(3)]
        void geom(triangle GS_INPUT tri[3], inout TriangleStream<FS_INPUT> triStream)
        {
          float3 a = tri[0].pos;
          float3 b = tri[1].pos;
          float3 c = tri[2].pos;
          float2 uvA = tri[0].uv;
          float2 uvB = tri[1].uv;
          float2 uvC = tri[2].uv;
          float3 g = (a + b + c) / 3.0;

          float t = cos(_Time * 60.0) * 0.5 + 0.5;

          /*a += normalize(a - g) * t * 4.0;
          b += normalize(b - g) * t * 4.0;
          c += normalize(c - g) * t * 4.0;*/

          /*float angle = pow(noise(g) * 2.0 + 1.0, 2.0) * t * 0.5;
          a = rotateY(a, angle);
          a = rotateX(a, angle);
          b = rotateY(b, angle);
          b = rotateX(b, angle);
          c = rotateY(c, angle);
          c = rotateX(c, angle);*/

          /*a *= lerp(1.0, 0.0, t);*/
          /*a += lerp(0.0, 100.0, t);*/
          /*a += 10.0 * tri[0].normal;*/

          float4x4 vp = mul(UNITY_MATRIX_MVP, _World2Object);

          FS_INPUT pIn = (FS_INPUT)0;
          pIn.pos = mul(vp, float4(a, 1.0));
          pIn.uv = tri[0].uv;
          pIn.normal = tri[0].normal;
          pIn.color = half4(1.0,0.0,0.0,1.0);
          triStream.Append(pIn);

          pIn.pos =  mul(vp, float4(b, 1.0));
          pIn.uv = tri[1].uv;
          pIn.normal = tri[1].normal;
          pIn.color = half4(0.0,1.0,0.0,0.0);
          triStream.Append(pIn);

          pIn.pos =  mul(vp, float4(c, 1.0));
          pIn.uv = tri[2].uv;
          pIn.normal = tri[2].normal;
          pIn.color = half4(0.0,0.0,1.0,1.0);
          triStream.Append(pIn);
        }

        half4 frag (FS_INPUT i) : COLOR
        {
          float2 screenUV = i.screenUV.xy / i.screenUV.w;
          half4 color = tex2D(_MainTex, i.uv);
          i.normal = rotateY(i.normal, _Time * 100.0);
          i.normal = rotateX(i.normal, _Time * 100.0);
          color.rgb = i.normal * 0.5 + 0.5;
          float wireframeSize = 0.05;
          float wireframeStep = step(i.color.r, wireframeSize);
          wireframeStep += step(i.color.g, wireframeSize);
          wireframeStep += step(i.color.b, wireframeSize);
          wireframeStep = clamp(wireframeStep, 0.0, 1.0);
          color.a = wireframeStep;
          return color;
        }
        ENDCG
      }
    }
    FallBack "Unlit/Transparent"
  }
