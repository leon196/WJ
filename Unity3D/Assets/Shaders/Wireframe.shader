Shader "Custom/Wireframe" {
  Properties {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Texture (RGB)", 2D) = "white" {}
		_Size ("Size", Range(0, 3)) = 0.5
    }
    SubShader {
      Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
      Pass {
        Blend SrcAlpha OneMinusSrcAlpha
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
					float3 up = float3(0, 1, 0);
					float3 look = _WorldSpaceCameraPos - tri[0].pos;
					look.y = 0;
					look = normalize(look);
					float3 right = cross(up, look);

					float halfS = 0.5f * _Size;
					float halfH = 0.1f * _Size;

					float4 v[12];
					v[0] = float4(tri[0].pos - halfH * up, 1.0f);
					v[1] = float4(tri[0].pos + halfH * up, 1.0f);
					v[2] = float4(tri[0].pos - halfH * up, 1.0f);
					v[3] = float4(tri[0].pos + halfH * up, 1.0f);
					v[4] = float4(tri[1].pos - halfH * up, 1.0f);
					v[5] = float4(tri[1].pos + halfH * up, 1.0f);
					v[6] = float4(tri[1].pos - halfH * up, 1.0f);
					v[7] = float4(tri[1].pos + halfH * up, 1.0f);
					v[8] = float4(tri[2].pos - halfH * up, 1.0f);
					v[9] = float4(tri[2].pos + halfH * up, 1.0f);
					v[10] = float4(tri[2].pos - halfH * up, 1.0f);
					v[11] = float4(tri[2].pos + halfH * up, 1.0f);

					float4x4 vp = mul(UNITY_MATRIX_MVP, _World2Object);
					FS_INPUT pIn = (FS_INPUT)0;
					pIn.pos = mul(vp, v[0]);
					pIn.uv = tri[0].uv;
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[1]);
					pIn.uv = tri[0].uv;
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[2]);
					pIn.uv = tri[1].uv;
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[3]);
					pIn.uv = tri[1].uv;
					triStream.Append(pIn);

					pIn.pos = mul(vp, v[4]);
					pIn.uv = tri[1].uv;
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[5]);
					pIn.uv = tri[1].uv;
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[6]);
					pIn.uv = tri[2].uv;
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[7]);
					pIn.uv = tri[2].uv;
					triStream.Append(pIn);

					pIn.pos = mul(vp, v[8]);
					pIn.uv = tri[2].uv;
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[9]);
					pIn.uv = tri[2].uv;
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[10]);
					pIn.uv = tri[1].uv;
					triStream.Append(pIn);

					pIn.pos =  mul(vp, v[11]);
					pIn.uv = tri[1].uv;
					triStream.Append(pIn);

					/*float4x4 vp = mul(UNITY_MATRIX_MVP, _World2Object);
					FS_INPUT pIn = (FS_INPUT)0;
					pIn.pos = mul(vp, tri[0].pos);//v[0]);
					pIn.uv = tri[0].uv;//float2(1.0f, 0.0f);
					triStream.Append(pIn);

					pIn.pos =  mul(vp, tri[1].pos);//v[1]);
					pIn.uv = tri[1].uv;//float2(1.0f, 1.0f);
					triStream.Append(pIn);*/

					/*pIn.pos =  mul(vp, tri[2].pos);//v[2]);
					pIn.uv = tri[2].uv;//float2(0.0f, 0.0f);
					triStream.Append(pIn);*/

					/*pIn.pos =  mul(vp, v[3]);
					pIn.uv = float2(0.0f, 1.0f);
					triStream.Append(pIn);*/
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
