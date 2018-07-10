# Abstract

라이트를 켜자.

# Shader

```c
Shader "UnityShaderTutorial/basic_light" {
	SubShader{
		Pass{
			Material{
				Diffuse(1,1,1,1)
				Ambient(1,1,1,1)
			}
			Lighting On
		}
	}
}
```

# Description

`fixed-style function command` 중 하나인 `Lighting`  를 이용하여 라이트를 활성화 하자. 이때 `Diffuse, Ambient` 는 고정된 값이다.

# Prerequisites

## Render-state setup commands

Pass 는 `Material, Lighting` 과 같은 다양한 `Render-state setup` 을 포함할 수 있다. `Render-state setup` commands 는 DirectX 를 사용할 때 `Device->Set*` 과 같다.