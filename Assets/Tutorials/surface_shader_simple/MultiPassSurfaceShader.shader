Shader "Custom/MultiPassSurfaceShader" {
	SubShader{
		Tags { "RenderType" = "Opaque" }
		
		Cull Front // 앞면 컬링하고 뒷면 그리기
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		#pragma debug

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void vert(inout appdata_full v) {
			v.normal *= -1; // 
		}
		
		void surf(Input IN, inout SurfaceOutput o) {
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = fixed3(1,0,0);
			o.Alpha = c.a;
		}
		ENDCG

		Cull Back // 뒷면 컬링하고 앞면 그리기
		CGPROGRAM
		#pragma surface surf Lambert
		#pragma debug

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o) {
			half4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = fixed3(0,1,0);
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
