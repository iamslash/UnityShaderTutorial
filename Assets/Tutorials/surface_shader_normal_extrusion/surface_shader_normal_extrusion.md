# Abstract

서피스 셰이더 - 법선 기반 돌출에 대해 알아봅니다.

# Shader

```c
Shader "UnityShaderTutorial/surface_shader_normal_extrusion" {
    Properties{
        _MainTex("Texture", 2D) = "white" {}
        _Amount("Extrusion Amount", Range(-1,1)) = 0.5
    }

    SubShader{
        Tags { "RenderType" = "Opaque" }

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert

        struct Input {
            float2 uv_MainTex;
        };

        float _Amount;

        void vert(inout appdata_full v) {
            v.vertex.xyz += v.normal * _Amount;
        }

        sampler2D _MainTex;

        void surf(Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    Fallback "Diffuse"
}
```

# Description

서피스 쉐이더의 `Vertex modifier` 기능을 사용해 모델의 법선을 기반으로 정점을 늘려줍니다.

## Vertex modifier

버텍스 쉐이더에서 수행되는 입력 데이터들을 수정할 수 있습니다.

```
void vert(inout appdata_full v) {
    v.vertex.xyz += v.normal * _Amount;
}
```

컴파일 지시문에 `vertex:functionName`을 선언하고, 함수에선 매개변수로 `appdata_full` 이라는 내장 구조체를 사용합니다.