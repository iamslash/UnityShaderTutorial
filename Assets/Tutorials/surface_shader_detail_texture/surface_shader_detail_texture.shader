Shader "UnityShaderTutorial/surface_shader_detail_texture" {
	Properties{
	  _MainTex("Texture", 2D) = "white" {}
	  _BumpMap("Bumpmap", 2D) = "bump" {}
	  _Detail("Detail", 2D) = "gray" {}
	}
		SubShader{
		  Tags { "RenderType" = "Opaque" }
		  CGPROGRAM
		  #pragma surface surf Lambert
		  struct Input {
			  float2 uv_MainTex;
			  float2 uv_BumpMap;
			  float2 uv_Detail;
		  };
		  sampler2D _MainTex;
		  sampler2D _BumpMap;
		  sampler2D _Detail;
		  void surf(Input IN, inout SurfaceOutput o) {
			  o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			  o.Albedo *= tex2D(_Detail, IN.uv_Detail).rgb * 2;
			  o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
		  }
		  ENDCG
	}
		Fallback "Diffuse"
}