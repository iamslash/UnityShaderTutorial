# Abstract

깊이 테스트를 해보자.

# Shader

```c
Shader "UnityShaderTutorial/basic_depth_test" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 200

		// extra pass that renders to depth buffer only
		Pass {
			ZWrite On
			ColorMask 0
		}

		// paste in forward rendering passes from Transparent/Diffuse
		UsePass "Transparent/Diffuse/FORWARD"
	}
	Fallback "Transparent/VertexLit"
}
```

# Description

Render-state setup command 중 `ZWrite, ColorMask` 를 사용하여 깊이버퍼 테스트를 해본다.

# Prerequisites

## Tags

...
