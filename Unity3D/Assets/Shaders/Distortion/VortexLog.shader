Shader "Distortion/VertexLog" {
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

        float3 getNormal(GS_INPUT tri[3])
        {
          float3 u = tri[1].pos - tri[0].pos;
          float3 v = tri[2].pos - tri[0].pos;
          float3 normal = float3(1.0, 0.0, 0.0);
          normal.x = u.y * v.z - u.z * v.y;
          normal.y = u.z * v.x - u.x * v.z;
          normal.z = u.x * v.y - u.y * v.x;
          return normalize(normal);
        }

        GS_INPUT vert (appdata_full v)
        {
          GS_INPUT o = (GS_INPUT)0;

          /*float tt = _Time * 4.0;
          float radius = 2.0;
          float3 target = float3(10.0 + cos(tt) * radius, 0.0, 10.0 + sin(tt) * radius);
          float dist = distance(target, v.vertex.xyz);
          dist = pow(dist, 2.0) / 10.0;
          float angle = dist;

          v.vertex.xyz = rotateY(v.vertex.xyz, angle);*/

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

          /*float t = cos(_Time * 30.0) * 0.5 + 0.5;*/

          /*a = normalize(a) * pow(length(a), 2.0);
          b = normalize(b) * pow(length(b), 2.0);
          c = normalize(c) * pow(length(c), 2.0);*/
          /*a = normalize(a) * (log(length(a)) + 2.0) * 4.0;
          b = normalize(b) * (log(length(b)) + 2.0) * 4.0;
          c = normalize(c) * (log(length(c)) + 2.0) * 4.0;*/
          a = normalize(a) * sin(length(a) + _Time) * length(a);
          b = normalize(b) * sin(length(b) + _Time) * length(b);
          c = normalize(c) * sin(length(c) + _Time) * length(c);
          // Scale
          /*a += normalize(a - g) * t;
          b += normalize(b - g) * t;
          c += normalize(c - g) * t;*/

          /*float tt = _Time * 30.0;
          float radius = 10.0;
          float3 target = float3(10.0 + cos(tt) * radius, 0.0, 10.0 + sin(tt) * radius);
          float dist = distance(target, g) / 10.0;
          dist = pow(dist, 2.0) / 100.0;
          float angle = dist;*/

          /*a = rotateY(target + a, angle);
          b = rotateY(target + b, angle);
          c = rotateY(target + c, angle);*/

          float3 triNormal = getNormal(tri);
          /*float3 triNormal = cross(normalize(c - a), normalize(b - a));*/
          /*float3 triNormal = normalize(rotateY(tri[0].normal, angle));*/

          float4x4 vp = mul(UNITY_MATRIX_MVP, _World2Object);

          FS_INPUT pIn = (FS_INPUT)0;
          pIn.pos = mul(vp, float4(a, 1.0));
          pIn.uv = tri[0].uv;
          pIn.normal = triNormal;
          pIn.color = half4(1.0,0.0,0.0,1.0);
          triStream.Append(pIn);

          pIn.pos =  mul(vp, float4(b, 1.0));
          pIn.uv = tri[1].uv;
          pIn.normal = triNormal;
          pIn.color = half4(0.0,1.0,0.0,0.0);
          triStream.Append(pIn);

          pIn.pos =  mul(vp, float4(c, 1.0));
          pIn.uv = tri[2].uv;
          pIn.normal = triNormal;
          pIn.color = half4(0.0,0.0,1.0,1.0);
          triStream.Append(pIn);
        }

        half4 frag (FS_INPUT i) : COLOR
        {
          half4 color = _Color;
          color.rgb = i.normal * 0.5 + 0.5;
          color.a = 1.0;
          return color;
        }
        ENDCG
      }
    }
    FallBack "Unlit/Transparent"
  }
