# Abstract

서피스 쉐이더를 이용하여 노말맵을 적용해보자

# Shader

```c
Shader "UnityShaderTutorial/surface_shader_normal" {
    Properties {
	_MainTex ("Texture", 2D) = "white" {}
	_BumpMap ("Bumpmap", 2D) = "bump" {}
    }

    SubShader {
      Tags { "RenderType" = "Opaque" }
      
	  CGPROGRAM
      
	  #pragma surface surf Lambert

      struct Input {
        float2 uv_MainTex;
        float2 uv_BumpMap;
      };

      sampler2D _MainTex;
      sampler2D _BumpMap;

      void surf (Input IN, inout SurfaceOutput o) {
        o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
        o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
      }

      ENDCG
    } 
    Fallback "Diffuse"
}
```

# Description

서피스 쉐이더에서 노말맵 적용은 어렵지 않다. 간단하게 아래 4가지 요소만 추가하면 자연스럽게 노말맵이 적용된다.

```
_BumpMap ("Bumpmap", 2D) = "bump" {}

struct Input {
   ...
   float2 uv_BumpMap;
};

sampler2D _BumpMap;

o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
```

핵심은 `o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));` 코드 이고, `SurfaceOutput`에 `Normal` 값을 어떻게 채우느냐에 따라서 최종 결과물에 노말맵이 적용방식이 결정된다.

