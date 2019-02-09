# Abstract

서피스 쉐이더를 이용하여 디테일 텍스처를 적용해보자

# Shader

```c
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
```

# Description

* 디테일 텍스처는 텍스처와 타일링이 다르므로 UV좌표를 따로 가짐
* 디테일 텍스처의 색상값을 텍스처에 곱해주는것이기 때문에 디테일 텍스처의 명암에 따라 텍스처 색상도 달라지지만 
일반적으로 디테일 텍스처는 회색이므로 텍스처의 밝기를 유지하기 위해 2를 곱해줌
* UnpackNormal : 디바이스에 따라 연산방법을 다르게 적용한다 