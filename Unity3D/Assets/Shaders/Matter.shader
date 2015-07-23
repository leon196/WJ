Shader "Custom/Matter" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
        _LightOffset ("Light Offset", Range (0.0, 2.0)) = 1.0
        _Color ("Color", Color) = (1,1,1,1)
        _Color2 ("Color", Color) = (1,1,1,1)
        _Scale ("Scale", Range (0.1, 10.0)) = 1.0
        _Height ("Height", Range (0.0, 0.05)) = 0.01
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

        // Dat random function for glsl 
        float rand(float2 co){ return frac(sin(dot(co.xy, float2(12.9898,78.233))) * 43758.5453); }

        // Pixelize coordinates
        float2 pixelize(float2 uv, float details) { return floor(uv.xy * details) / details; }

		// hash based 3d value noise
		// function taken from [url]https://www.shadertoy.com/view/XslGRr[/url]
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

		sampler2D _MainTex;
		half4 _Color;
		half4 _Color2;
		float _Scale;
		float _Height;
		float _LightOffset;

		uniform float _TimeElapsed;
		uniform float4 cameraPosition;
		uniform float4 cameraDirection;

		struct Input {
			float2 uv_MainTex;
			float3 viewDir;
			float perlin;
		};

		void vert (inout appdata_full v, out Input o) 
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);

			// float3 uv = 
			//float3(v.vertex * v.normal + float3(0, 0, _TimeElapsed));

			// float perlin;
   //          perlin  = 0.5000 * noise( uv ); uv *= 2.01;
   //          perlin += 0.2500 * noise( uv ); uv *= 2.02;
   //          perlin += 0.1250 * noise( uv ); uv *= 2.03;
   //          perlin += 0.0625 * noise( uv ); uv *= 2.04;

   			v.vertex.xyz += normalize(v.normal.xyz) * sin(v.vertex.z * 10.0 + _TimeElapsed) * _Height;

			// v.vertex.xyz += v.normal.xyz * perlin * _Height;
			//lerp(v.vertex.xyz, 0, perlin);
			//0.5 * v.normal.yzx * dot(normalize(cameraDirection), -v.normal);
			//normalize(cameraPosition.xyz - v.vertex.xyz) * perlin;
			//0.25 * v.normal.xyz * perlin;
			//cos(4.0 * _TimeElapsed + v.vertex.x + v.vertex.z + v.vertex.y);
			// o.perlin = perlin;
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half3 light = dot(IN.viewDir, -o.Normal) + _LightOffset;

			half3 colorNormal = o.Normal * 0.5 + 0.5;

			o.Emission = lerp(tex2D(_MainTex, IN.uv_MainTex).rgb, colorNormal, light);
			o.Alpha = 1.0;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
