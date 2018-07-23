# Abstract

물체에 텍스처, 컬러, 라이트를 혼합해보자.

# Shader

```c
Shader "UnityShaderTutorial/basic_blend" {
    Properties {
        _MainTex ("Texture to blend", 2D) = ""
    }
    SubShader {
        Tags { "Queue" = "Transparent" }
        Pass {
        	Material {
                Diffuse (1,1,1,1)
                Ambient (1,1,1,1)
            }
            Lighting On

            SetTexture [_MainTex] {
                constantColor (1, 1, 1, 1)
                combine constant lerp(texture) previous
            }
        }
    }
}
```

# Description

`fixed-style function command` 에서 제공하는 `Lighting`과 `SetTexture` 의 combine을 이용하여 텍스처에 라이트와 컬러를 혼합 할 수 있다.

`constantColor`는 combine에서 사용 할 색상을 설정 할 수 있다. 값은 앞에서 부터 (Red, Green, Blue, Alpha) 순으로 설정한다.
설정된 색상을 사용할때는 `constant`를 이용하도록 한다.

+ Lighting에 관한 자세한 내용은 이전 챕터인 `basic_light`를 참고하도록 한다.
+ SetTexure에 관한 자세한 내용은 이전 챕터인 `basic_texture`를 참고하도록 한다.
