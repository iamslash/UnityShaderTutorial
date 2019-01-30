Shader "UnityShaderTutorial/triplanar 2" {
	//show values to edit in inspector
	Properties
	{
		_DiffuseMap("Diffuse Map ", 2D) = "white" {}
		_TextureScale("Texture Scale",float) = 1
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }

			CGPROGRAM
			#pragma target 3.0
			#pragma surface surf Lambert
			#pragma enable_d3d11_debug_symbols

			sampler2D _DiffuseMap;
			float _TextureScale;

			struct Input
			{
				float3 worldPos;
				float3 worldNormal;
			};

			void surf(Input IN, inout SurfaceOutput o)
			{
				// Find our UVs for each axis based on world position of the fragment.
				half2 xUV = IN.worldPos.zy / _TextureScale;
				half2 yUV = IN.worldPos.xz / _TextureScale;
				half2 zUV = IN.worldPos.xy / _TextureScale;
				// Now do texture samples from our diffuse map with each of the 3 UV set's we've just made.
				half3 xDiff = tex2D(_DiffuseMap, xUV);
				half3 yDiff = tex2D(_DiffuseMap, yUV);
				half3 zDiff = tex2D(_DiffuseMap, zUV);
				// Get the absolute value of the world normal.
				// Put the blend weights to the power of BlendSharpness, the higher the value, 
				// the sharper the transition between the planar maps will be.
				half3 blend = abs(IN.worldNormal);
				blend /= dot(blend, 1.0);
				// Finally, blend together all three samples based on the blend mask.
				o.Albedo = xDiff * blend.x + yDiff * blend.y + zDiff * blend.z;
			}
			ENDCG
		}
}