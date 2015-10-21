Shader "Distortion/Tornado2" {
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
        float getTest1(float x)
        {
          return fmod(20.0, (x - 10.0));
        }
        float getTest2(float x)
        {
          return 10.0 * sin(pow(x/10.0, 2.0));
        }
        float getTest3(float x)
        {
          x /= 6.6;
          return 0.02 * pow(x + sin(x + _Time * 40.0) * 4.0, 2.0);
        }

        float getLogCustom2(float x)
        {
          return (log(x + 2.0));
        }

        GS_INPUT vert (appdata_full v)
        {
          GS_INPUT o = (GS_INPUT)0;

          /*v.vertex.y *= 8.0;*/
          /*v.vertex.y = pow(v.vertex.y + 2.0, 2.0);*/
          /*v.vertex.y += lerp(0.0, 2.0, sin(_Time * 20.0) * 0.5 + 0.5);*/
          /*v.vertex.y += lerp(0.0, 68.0, sin(_Time * 20.0) * 0.5 + 0.5);*/

          float tt = _Time * 24.0;
          float radius = 2.0;
          float3 target = float3(cos(tt) * radius, 0.0, sin(tt) * radius);
          /*float dist = distance(target, v.vertex.xyz);
          dist = pow(dist, 2.0) / 10.0;
          float angle = dist;*/

          /*v.vertex.xyz += target;*/

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
          /*float3 g = (a + b + c) / 3.0;*/

          float t = cos(_Time * 3.0) * 0.5 + 0.5;
          float tt = _Time * 30.0;


          /*a = normalize(a) * pow(length(a), 2.0);
          b = normalize(b) * pow(length(b), 2.0);
          c = normalize(c) * pow(length(c), 2.0);*/
          /*a = _WorldSpaceCameraPos - a;*/
          /*b = _WorldSpaceCameraPos - b;*/
          /*c = _WorldSpaceCameraPos - c;*/

          float scale = 0.0;

          float3 aa = mul(vp, float4(a, 1.0)).xyz;
          float3 bb = mul(vp, float4(b, 1.0)).xyz;
          float3 cc = mul(vp, float4(c, 1.0)).xyz;
          float3 cam = mul(vp, float4(_WorldSpaceCameraPos, 1.0).xyz);


          float aLength = distance(_WorldSpaceCameraPos, a);
          float bLength = distance(_WorldSpaceCameraPos, b);
          float cLength = distance(_WorldSpaceCameraPos, c);
          a = normalize(a + _WorldSpaceCameraPos) * (getExpogCustom(aLength) + aLength);
          b = normalize(b + _WorldSpaceCameraPos) * (getExpogCustom(bLength) + bLength);
          c = normalize(c + _WorldSpaceCameraPos) * (getExpogCustom(cLength) + cLength);

                    float4 color = float4(1.0,1.0,1.0,1.0);
                    /*color.rgb *= clamp(1.0/(distance(_WorldSpaceCameraPos, a)/10.0), 0.0, 1.0);*/
          // Scale
          /*a += normalize(a - g) * t;
          b += normalize(b - g) * t;
          c += normalize(c - g) * t;*/
          /*
          float radius = 10.0;
          float3 target = float3(10.0 + cos(tt) * radius, 0.0, 10.0 + sin(tt) * radius);*/
          /*float dist = distance(target, g) / 10.0;*/
          /*float dist = length()
          dist = pow(dist, 2.0) / 100.0;
          float angle = dist;*/


          /*a = rotateY(a, getLogCustom(length(a)) * scale + tt);
          b = rotateY(b, getLogCustom(length(b)) * scale + tt);
          c = rotateY(c, getLogCustom(length(c)) * scale + tt);*/
          /*a = rotateY(a, getLogCustom2(abs(a.y)*1000.0) + _Time * 10.0);
          b = rotateY(b, getLogCustom2(abs(b.y)*1000.0) + _Time * 10.0);
          c = rotateY(c, getLogCustom2(abs(c.y)*1000.0) + _Time * 10.0);*/

          /*float3 triNormal = getTriangleNormal(a, b, c);*/
          /*float3 triNormal = cross(normalize(c - a), normalize(b - a));*/
          /*float3 triNormal = normalize(rotateY(tri[0].normal, angle));*/

          FS_INPUT pIn = (FS_INPUT)0;
          pIn.pos = mul(vp, float4(a, 1.0));
          pIn.uv = tri[0].uv;
          pIn.normal = tri[0].normal;
          pIn.color = color;
          triStream.Append(pIn);

          pIn.pos =  mul(vp, float4(b, 1.0));
          pIn.uv = tri[1].uv;
          pIn.normal = tri[1].normal;
          pIn.color = color;
          triStream.Append(pIn);

          pIn.pos =  mul(vp, float4(c, 1.0));
          pIn.uv = tri[2].uv;
          pIn.normal = tri[2].normal;
          pIn.color = color;
          triStream.Append(pIn);
        }

        half4 frag (FS_INPUT i) : COLOR
        {
          half4 color = _Color;
          color.rgb = i.normal * 0.5 + 0.5;
          color.rgb *= Luminance(i.color);

          color.a = 1.0;
          return color;
        }
        ENDCG
      }
    }
    FallBack "Unlit/Transparent"
  }
