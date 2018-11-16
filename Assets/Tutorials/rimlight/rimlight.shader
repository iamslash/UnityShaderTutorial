Shader "UnityShaderTutorial/rimlight"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		//DIFFUSE
		_MainTex ("Main Texture", 2D) = "white" {}
		//RIM LIGHT
		_RimColor ("Rim Color", Color) = (0.8,0.8,0.8,0.6)
		_RimMin ("Rim Min", Range(0,2)) = 0.5
		_RimMax ("Rim Max", Range(0,2)) = 1.0
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		
		CGPROGRAM

		#pragma surface surf Lambert noshadow nofog nolightmap novertexlights noforwardadd interpolateview exclude_path:deferred exclude_path:prepass
		#pragma target 2.5

		//================================================================
		// VARIABLES

		fixed4 _Color;
		sampler2D _MainTex;
		fixed4 _RimColor;
		fixed _RimMin;
		fixed _RimMax;
		float4 _RimDir;

		#define UV_MAINTEX uv_MainTex

		struct Input
		{
			half2 uv_MainTex;
			float3 viewDir;
		};

		//================================================================
		// CUSTOM LIGHTING

		// Instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		//================================================================
		// SURFACE FUNCTION

		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 mainTex = tex2D(_MainTex, IN.UV_MAINTEX);
			o.Albedo = mainTex.rgb * _Color.rgb;
			o.Alpha = mainTex.a * _Color.a;

			//Rim
			float3 viewDir = normalize(IN.viewDir);
			half rim = 1.0f - saturate( dot(viewDir, o.Normal) );
			rim = smoothstep(_RimMin, _RimMax, rim);
			o.Emission += (_RimColor.rgb * rim) * _RimColor.a;
		}

		ENDCG
	}

	Fallback "Diffuse"
}
