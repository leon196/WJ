Shader "Custom/ColorNormal" 
{
    Properties 
    {
      	_MainTex ("Texture", 2D) = "white" {}
    }
    SubShader 
    {
		Tags { "RenderType" = "Opaque" }
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		// https://github.com/ashima/webgl-noise
    	#include "Assets/Shaders/noise3D.cginc"   

      	struct Input 
      	{
			float2 uv_MainTex;
			float3 normal;
			float3 pos;
			float3 viewDir;
      	};

      	float _TimeElapsed;
      	float _MouseX;

      	void vert (inout appdata_full v, out Input o)
      	{
          	UNITY_INITIALIZE_OUTPUT(Input,o);

          	float3 seed = float3(0.0, length(v.normal), length(v.vertex) - _TimeElapsed);
          	float3 offset = v.normal * snoise(seed);//* _MouseX;
          	float3 origin = v.vertex;
          	v.vertex.xyz += offset;
          	o.pos = length(mul (UNITY_MATRIX_MV, v.vertex).xyz);
          	o.normal = normalize(normalize(v.vertex) - normalize(origin));
      	}

      	sampler2D _MainTex;

     	void surf (Input IN, inout SurfaceOutput o) 
      	{
      		half3 color = normalize(IN.normal + 1.0);
          	o.Emission = color;// * shadow;
      	}
      	ENDCG
    } 
    Fallback "Diffuse"
  }