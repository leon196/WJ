Shader "Triangle/Tritri" {
  Properties {
    _Color ("Color", Color) = (1,1,1,1)
    _MainTex ("Texture (RGB)", 2D) = "white" {}
      _Size ("Size", Range(0, 1.0)) = 0.01
      _Scale ("Scale", Range(0, 1.0)) = 0.01
      _Offset ("Offset", Range(0, 1.0)) = 0.01
      _LogScale ("Log Scale", Range(1.0, 10.0)) = 1.0
    }
    SubShader {
      Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
      Pass {
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 200
        Cull Off

        CGPROGRAM
        #pragma vertex vert
        #pragma geometry geom
        #pragma fragment frag
        #include "UnityCG.cginc"
        #include "../noise3D.cginc"

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
        float _Scale;
        float _Offset;
        float _LogScale;

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

        float3 getTriangleNormal(float3 a, float3 b, float3 c)
        {
          float3 u = b - a;
          float3 v = c - a;
          float3 normal = float3(1.0, 0.0, 0.0);
          normal.x = u.y * v.z - u.z * v.y;
          normal.y = u.z * v.x - u.x * v.z;
          normal.z = u.x * v.y - u.y * v.x;
          return normalize(normal);
        }

        float getLogCustom(float x)
        {
          return log(x / 100.0 + 0.01) + 2.0;
        }

        float getExpogCustom(float x)
        {
          return pow(x / 7.6, 2.0);
        }

        GS_INPUT vert (appdata_full v)
        {
          GS_INPUT o = (GS_INPUT)0;
          /*float3 p = mul(_Object2World, v.vertex).xyz;
          float t = cos(_Time * 10.0) * 0.5 + 0.5;
          float3 target = _WorldSpaceCameraPos;
          float dist = length(p - target);
          float scale = (100.0) / (dist);
          float angle = scale;*/

          /*color.rgb = clamp(1.0 - scale, 0.0, 1.0);*/

          /*a.y += dist;
          b.y += dist;
          c.y += dist;*/

          /*v.vertex.xyz = v.vertex.xyz + rotateY(p - target, angle);*/
          o.pos =  mul(_Object2World, v.vertex);
          o.normal = v.normal;
          o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
          o.screenUV = ComputeScreenPos(o.pos);
          return o;
        }

        [maxvertexcount(3)]
        void geom(triangle GS_INPUT tri[3], inout TriangleStream<FS_INPUT> triStream)
        {
          float4x4 vp = mul(UNITY_MATRIX_MVP, _World2Object);

          float3 a = tri[0].pos;
          float3 b = tri[1].pos;
          float3 c = tri[2].pos;
          float2 uvA = tri[0].uv;
          float2 uvB = tri[1].uv;
          float2 uvC = tri[2].uv;
          float3 g = (a + b + c) / 3.0;

          float4 color = float4(1.0,1.0,1.0,1.0);
          float t = cos(_Time * 30.0) * 0.5 + 0.5;
          float tt = _Time * 10.0;

          /*a = lerp(tri[0].pos, tri[1].pos, t);
          b = lerp(tri[1].pos, tri[2].pos, t);
          c = lerp(tri[2].pos, tri[0].pos, t);*/

          /*float scale = 10.0 / log(length(g));*/

          float3 target = _WorldSpaceCameraPos + normalize(UNITY_MATRIX_IT_MV[2].xyz) * 10.0;
          float dist = length(g - target);
          float scale = (1.0 + 1000.0 * t) / (dist);
          float angle = scale;

          /*color.rgb = clamp(1.0 - scale, 0.0, 1.0);*/

          /*a.y += dist;
          b.y += dist;
          c.y += dist;*/

          a = tri[0].pos + rotateY(a - target, angle);
          b = tri[1].pos + rotateY(b - target, angle);
          c = tri[2].pos + rotateY(c - target, angle);
          /*a = rotateY(a, angle + tt);
          b = rotateY(b, angle + tt);
          c = rotateY(c, angle + tt);*/
          float rrr = 100.0;
          float rr = 10000.0;
          /*a = rotateY(a, angle);
          b = rotateY(b, angle);
          c = rotateY(c, angle);*/

          /*float r = clamp(10.0/(dist), 0.0, 1.0);
          a = lerp(a, g, r);
          b = lerp(b, g, r);
          c = lerp(c, g, r);*/

          float3 triNormal = getTriangleNormal(a, b, c);

          FS_INPUT pIn = (FS_INPUT)0;
          pIn.pos = mul(vp, float4(a, 1.0));
          pIn.uv = tri[0].uv;
          pIn.normal = triNormal;
          pIn.color = color;
          triStream.Append(pIn);

          pIn.pos =  mul(vp, float4(b, 1.0));
          pIn.uv = tri[1].uv;
          pIn.normal = triNormal;
          pIn.color = color;
          triStream.Append(pIn);

          pIn.pos =  mul(vp, float4(c, 1.0));
          pIn.uv = tri[2].uv;
          pIn.normal = triNormal;
          pIn.color = color;
          triStream.Append(pIn);

          /*triStream.RestartStrip();*/
        }

        half4 frag (FS_INPUT i) : COLOR
        {
          half4 color = _Color;
          color.rgb = i.normal * 0.5 + 0.5;
          color.rgb *= Luminance(i.color);

          /*float g = clamp((color.r + color.b) - color.g, 0.0, 1.0);
          color.rgb = lerp(float3(1.0, 0.0, 0.0), color.rgb, g);*/

          color.a = 1.0;
          return color;
        }
        ENDCG
      }
    }
    FallBack "Unlit/Transparent"
  }
