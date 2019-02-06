# Abstract

서피스 쉐이더를 이용하여 안개를 그려보자

# Shader

```c
Shader "UnityShaderTutorial/surface_shader_custom_fog" {
	Properties {
      _MainTex ("Texture", 2D) = "white" {}
      _FogColor ("Fog Color", Color) = (0.3, 0.4, 0.7, 1.0)
    }
    SubShader {
      Tags { "RenderType" = "Opaque" }
      CGPROGRAM
      #pragma surface surf Lambert finalcolor:mycolor vertex:myvert
      struct Input {
          float2 uv_MainTex;
          half fog;
      };
      void myvert (inout appdata_full v, out Input data)
      {
          UNITY_INITIALIZE_OUTPUT(Input,data);
          float4 hpos = UnityObjectToClipPos(v.vertex);
          hpos.xy/=hpos.w; //Normalized Device 좌표를 얻기 위해
          data.fog = min (1, dot(hpos.xy, hpos.xy)*0.5);
      }
      fixed4 _FogColor;
      void mycolor (Input IN, SurfaceOutput o, inout fixed4 color)
      {
          fixed3 fogColor = _FogColor.rgb;
          #ifdef UNITY_PASS_FORWARDADD
          fogColor = 0;
          #endif
          color.rgb = lerp (color.rgb, fogColor, IN.fog);
      }
      sampler2D _MainTex;
      void surf (Input IN, inout SurfaceOutput o) {
           o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
      }
      ENDCG
    } 
    Fallback "Diffuse"
}
```

# Description

* 화면 중앙으로부터의 거리를 기준으로 안개의 색을 적용
* UNITY_INITIALIZE_OUTPUT(type, name) : type 의 name 변수를 0으로 초기화
* data.fog : 물체의 색상과 안개의 색을 보간할 정도를 저장
![](/Assets/Tutorials/surface_shader_custom_fog/fog.png)
