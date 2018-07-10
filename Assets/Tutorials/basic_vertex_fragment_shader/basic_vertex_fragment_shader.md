# Abstract

기본적인 vertex, fragment shader 를 작성하고 좌표변환을 이해하자.

# Shader

```c
Shader "UnityShaderTutorial/basic_vertex_fragment_shader" {
    Properties
    {
        // Color property for material inspector, default to white
        _Color ("Main Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // vertex shader
            // this time instead of using "appdata" struct, just spell inputs manually,
            // and instead of returning v2f struct, also just return a single output
            // float4 clip position
            float4 vert (float4 vertex : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertex);
            }
            
            // color from the material
            fixed4 _Color;

            // pixel shader, no inputs needed
            fixed4 frag () : SV_Target
            {
                return _Color; // just return it
            }
            ENDCG
        }
    }
}
```

# Description

vertex shader 는 vertex 개수 만큼 호출된다. fragment shader 는 fragment 개수 만큼 호출된다. 물체의 표면색을 `_Color` property 로 칠하자.

# Prerequisites

## Transformations
