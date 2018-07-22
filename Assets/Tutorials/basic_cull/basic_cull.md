# Abstract

물체의 앞면 혹은 뒷면을 그리지 않게 하자

# Shader

```c
Shader "UnityShaderTutorial/basic_cull" {
	Properties { 
	        _MainTex ("Base Texture", 2D) = "white" {} 
    } 
    SubShader {
        Pass {
            Lighting On
            Cull Back
            SetTexture [_MainTex]
        }
    }
}
```

# Description

`Cull` 은 쉐이더의 문법 중 하나이다.
폴리곤의 어떤 영역을 그리지 않도록 설정 할 수 있다.

문법은 아래와 같다

```c
Cull Back | Front | Off
```

`Back` : 보이는 부분에서 반대쪽에 해당하는 폴리곤을 그리지 않도록 한다.
`Front` : 보이는 부분쪽에 해당하는 폴리곤을 그리지 않도록 한다.
`Off` : 모든 부분을 그린다.

## Why Use Cull?

`Culling` 은 퍼포먼스에 영향을 준다. `Culling`을 하지 않을경우, 보이지 않는 영역까지 그리려고 노력을 하기 때문에, GPU가 할 일이 많아 진다.

Unity에서 큐브를 하나 띄워 놓고, `Shader` 에서 `Cull Back`과 `Cull Off` 로 했을때 `GPU Profiler` 를 보면 차이를 볼 수 있다.

|  | GPU ms |
|:-------:|:--------:|
| Cull Back  |   0.224  |
| Cull Off  |   0.501  |





