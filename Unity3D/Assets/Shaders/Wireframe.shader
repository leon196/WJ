Shader "Custom/Wireframe" {
  Properties {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Texture (RGB)", 2D) = "white" {}
		_Size ("Size", Range(0, 1.0)) = 0.01
    }
    SubShader {
      Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
      Pass {
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        LOD 200

        CGPROGRAM
  			#pragma target 5.0
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
        };

        sampler2D _MainTex;
        float4 _MainTex_ST;
        fixed4 _Color;
        float _Size;

        GS_INPUT vert (appdata_full v)
        {
					GS_INPUT o = (GS_INPUT)0;
					o.pos =  mul(_Object2World, v.vertex);
					o.normal = v.normal;
          o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
          o.screenUV = ComputeScreenPos(o.pos);
          return o;
        }

        [maxvertexcount(12)]
				void geom(triangle GS_INPUT tri[3], inout TriangleStream<FS_INPUT> triStream)
				/*void geom(line GS_INPUT l[2], inout TriangleStream<FS_INPUT> triStream)*/
				{
					/*float3 up = float3(0, 1, 0);
					float3 look = _WorldSpaceCameraPos - tri[0].pos;
					look.y = 0;
					look = normalize(look);
					float3 right = cross(up, look);

					float halfS = 0.5f * _Size;
					float halfH = 0.1f * _Size;*/

          float3 a = tri[0].pos;
          float3 b = tri[1].pos;
          float3 c = tri[2].pos;

          float3 d = (a + b) / 2.0;
          float3 e = (c + b) / 2.0;
          float3 f = (c + a) / 2.0;
          float3 g = (a + b + c) / 3.0;
          float3 h = lerp(b, g, 0.8);
          float3 i = lerp(c, g, 0.8);
          float3 j = lerp(a, g, 0.8);

          float3 dRight = normalize(a - b) * _Size * distance(a, b) * 0.5;
          float3 eRight = normalize(b - c) * _Size * distance(c, b) * 0.5;
          float3 fRight = normalize(c - a) * _Size * distance(a, c) * 0.5;

					float4 v[9];

					v[0] = float4(d + dRight, 1.0f);
					v[1] = float4(d - dRight, 1.0f);
					v[2] = float4(g, 1.0f);

					v[3] = float4(e + eRight, 1.0f);
					v[4] = float4(e - eRight, 1.0f);
					v[5] = float4(g, 1.0f);

					v[6] = float4(f + fRight, 1.0f);
					v[7] = float4(f - fRight, 1.0f);
					v[8] = float4(g, 1.0f);

          float2 uvs[9];

          float2 uvAB = lerp(tri[0].uv, tri[1].uv, 0.5);
          float2 uvBC = lerp(tri[1].uv, tri[2].uv, 0.5);
          float2 uvCA = lerp(tri[2].uv, tri[0].uv, 0.5);
          float2 uvG = (tri[0].uv + tri[1].uv + tri[2].uv) / 3.0;

          uvs[0] = lerp(tri[0].uv, uvAB, _Size);
          uvs[1] = lerp(uvAB, tri[1].uv, _Size);
          uvs[3] = lerp(tri[1].uv, uvBC, _Size);
          uvs[4] = lerp(uvBC, tri[2].uv, _Size);
          uvs[6] = lerp(tri[2].uv, uvCA, _Size);
          uvs[7] = lerp(uvCA, tri[0].uv, _Size);

          uvs[2] = uvG;
          uvs[5] = uvG;
          uvs[8] = uvG;

					float4x4 vp = mul(UNITY_MATRIX_MVP, _World2Object);
					FS_INPUT pIn = (FS_INPUT)0;
					pIn.pos = mul(vp, v[0]);
					pIn.uv = uvs[0];
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[1]);
					pIn.uv = uvs[1];
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[2]);
					pIn.uv = uvs[2];
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[3]);
					pIn.uv = uvs[3];
					triStream.Append(pIn);

					pIn.pos = mul(vp, v[4]);
					pIn.uv = uvs[4];
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[5]);
					pIn.uv = uvs[5];
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[6]);
					pIn.uv = uvs[6];
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[7]);
					pIn.uv = uvs[7];
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[8]);
					pIn.uv = uvs[8];
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[0]);
					pIn.uv = uvs[0];
					triStream.Append(pIn);
				}

        half4 frag (FS_INPUT i) : COLOR
        {
          float2 screenUV = i.screenUV.xy / i.screenUV.w;
          half4 color = tex2D(_MainTex, i.uv);

          // color.a = step(fmod(screenUV, 0.1), 0.05);
          return color;
        }
        ENDCG
      }
    }
    FallBack "Unlit/Transparent"
  }
