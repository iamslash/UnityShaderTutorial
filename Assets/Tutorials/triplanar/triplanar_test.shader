Shader "UnityShaderTutorial/triplanar_test"
{
	Properties
	{
		_MainTexture("MainTexture ", 2D) = "white" {}
		_Scale("Texture Scale", float) = 500
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Lambert

		sampler2D _MainTexture;
		float _Scale;

		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		void surf(Input In, inout SurfaceOutput o)
		{
			half3 blendWeights = abs(In.worldNormal);
			blendWeights /= dot(blendWeights, 1.0f);

			half2 xUV = In.worldPos.zy / _Scale;
			half2 yUV = In.worldPos.xz / _Scale;
			half2 zUV = In.worldPos.xy / _Scale;

			half3 yDiff = tex2D(_MainTexture, yUV);
			half3 xDiff = tex2D(_MainTexture, xUV);
			half3 zDiff = tex2D(_MainTexture, zUV);

			o.Albedo = xDiff * blendWeights.x + yDiff * blendWeights.y + zDiff * blendWeights.z;
		}
		ENDCG
	}
}