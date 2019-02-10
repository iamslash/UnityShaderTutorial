# Abstract

서피스 쉐이더에 사용자가 정의한 정점계산을 넣어보자.

# Shader

```c
Shader "UnityShaderTutorial/surface_shader_custom_data_computed_per_vertex" {
	Properties {
      _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader {
      Tags { "RenderType" = "Opaque" }

      CGPROGRAM
      #pragma surface surf Lambert vertex:vert

      struct Input {
          float2 uv_MainTex;
          float3 customColor;
      };

      void vert (inout appdata_full v, out Input o) {
          UNITY_INITIALIZE_OUTPUT(Input,o);
          o.customColor = float3(0,1,0);    // 사용자가 원하는 컬러를 입력한다.
          //o.customColor = abs(v.normal);
      }

      sampler2D _MainTex;

      void surf (Input IN, inout SurfaceOutput o) {
          o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
          o.Albedo *= IN.customColor;
      }
      ENDCG
    } 
    Fallback "Diffuse"
}
```

# Description

## vertext:vert

`vertex:VertexFunction`

```
VertexShader에서 호출되도록 사용자가 정의한 계산 처리 함수를 선언.
```

## UNITY_INITIALIZE_OUTPUT

`UNITY_INITIALIZE_OUTPUT(type, name)`

```
주어진 타입의 이름을 0으로 초기화하는 매크로 함수. 
```

```
[HLSLSupport.cginc]

#define UNITY_INITIALIZE_OUTPUT(type,name) name = (type)0;
```