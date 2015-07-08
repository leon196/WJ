Shader "Custom/Fractal" {
    Properties {}
    SubShader {
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
        Pass {
            Cull off
            Blend SrcAlpha OneMinusSrcAlpha     
            ZWrite Off
            LOD 200
            
            CGPROGRAM
            #pragma target 3.0 
            #pragma vertex vert
            #pragma fragment frag   
            #include "UnityCG.cginc"   
            #include "Assets/Shaders/Utils.cginc"   
            // https://github.com/ashima/webgl-noise
            #include "Assets/Shaders/ClassicNoise2D.cginc"   
            #define PI 3.141592653589
            #define PI2 6.283185307179

            struct v2f 
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 screenUV : TEXCOORD1;
            };   

            sampler2D _SamplerVideo;
            sampler2D _SamplerSound;
            sampler2D _SamplerRenderTarget;
            float4 _SamplerVideo_ST; 

            float _TimeElapsed;
            float _RoundEffect;
            float _RoundVideo;
            float _RatioBufferTreshold;

            float _SamplesTotal;
            float _SamplesElapsed;
            float _MouseX;
            float _MouseY;

            v2f vert (appdata_full v)
            {
                v2f o;
                o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
                o.uv = TRANSFORM_TEX (v.texcoord, _SamplerVideo);
                o.screenUV = ComputeScreenPos(o.pos);
                return o;
            }

            float fractal (float2 c)
            {
                const int iter = 32;
                float2 z = c;
                float dist = 1000.0;
                // z.x += 0.25 * cos(_SamplesElapsed * 0.0001);
                // z.y += 0.25 * sin(_SamplesElapsed * 0.0001);
                z.x += 0.05 * _SamplesTotal;
                z.y += 0.05 * _SamplesTotal;

                // c.x = kaleido(c.x, _SamplesElapsed * 0.00001)- 1.0;
                // c.y = kaleido(c.y, _SamplesElapsed * 0.00001);
                for (int i = 0; i < iter; i++) 
                {
                    float x = (z.x * z.x - z.y * z.y) + c.x;
                    float y = (z.y * z.x + z.x * z.y) + c.y;

                    // x = kaleido(x, _TimeElapsed * 0.1)- 1.0;
                    // y = kaleido(y, _TimeElapsed * 0.1)- 1.0;

                    if((x * x + y * y) > 2.0) return 0.0f;
                    z.x = x;
                    z.y = y;


                    dist = min(dist, sqrt(length(z - c)));
                }
                return sqrt(dist);
            }

            half4 frag (v2f input) : COLOR
            {
                float2 uv = input.screenUV.xy / input.screenUV.w;
                float aspectRatio = _ScreenParams.x / _ScreenParams.y;
                float2 center = uv * 2.0 - 1.0;
                center.x *= aspectRatio;

                float dist = length(center);
                float angle = atan2(center.y, center.x);
                float t = _TimeElapsed * 0.5;

                center = float2(_SamplesTotal * 0.01 / log(dist) + 0.9, sin(angle) / PI2 );// float2(cos(angle), sin(angle)) * log(dist / 2.0);

                // float2 center2 = float2(1.0 - cos(dist / 2.0 - t), angle / PI * 0.5 + 0.5);// float2(cos(angle), sin(angle)) * log(dist / 2.0);

                // center = float2(sin(dist / 2.0 - _TimeElapsed * 0.05), angle / PI * 0.5 + 0.5)
                half4 color = half4(1.0, 0.0, 0.0, 1.0);

                color.rgb *= fractal(center.yx);// + fractal(center2);

                return color;
            }
            ENDCG
        } 
    }
    FallBack "Unlit/Transparent"
}