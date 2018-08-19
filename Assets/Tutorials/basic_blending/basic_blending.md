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

`fixed-style function command` 에서 제공하는 `Lighting`과 `SetTexture` 의 `combine`을 이용하여 텍스처에 라이트와 컬러를 혼합 할 수 있다. 

`constantColor`는 `combine`에서 사용 할 색상을 설정 할 수 있다. `constanceColor`의 값은 `(Red, Green, Blue, Alpha)` 이다. `combine` 에서 `constantColor`를 사용하기 위해 `constant`를 이용한다.
 
* `Lighting`에 관한 자세한 내용은 [basic_light](/Assets/Tutorials/basic_light/basic_light.md)를 참고하도록 한다.
* `SetTexure`에 관한 자세한 내용은 [basic_texture](/Assets/Tutorials/basic_texture/basic_texture.md)를 참고하도록 한다.
