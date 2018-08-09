# Abstract

깊이 테스트를 해보자.

# Shader

```c
Shader "UnityShaderTutorial/basic_depth_test" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

		// extra pass that renders to depth buffer only
		Pass {
			ZTEST Less
			Color [_Color]
		}
	}
}
```

# Description

`ZTest` : 기본적으로 LEqual이 활성화. 물체의 깊이에 따라 그려줄지 판단한다.

```
ex) ZTest (Less | Greater | LEqual | GEqual | Equal | NotEqual | Always)
```

# Prerequisites

## Unity ShaderLab Overview

`Z-TEST`

+ `Less`, `LEqual`
```
관찰자와 오브젝트 사이의 거리가 작거나 같은 것들만 그린다.
```

![](./Image/Less.png)
![](./Image/LEqual.png)

+ `Greater`, `GEqual`

```
관찰자와 오브젝트 사이의 거리보다 크거나 같은 것들만 그린다.
```

![](./Image/Greater.png)
![](./Image/GEqual.png)

+ `Equal`

```
관찰자와 오브젝트 사이의 거리가 같은 것들만 그린다.
```

![](./Image/Equal.png)

+ `Not Equal`, `Always`

```
관찰자와 오브젝트 사이의 거리가 같지 않은 것, 깊이에 상관없이 항상 그린다.
```

![](./Image/NotEqual.png)
![](./Image/Always.png)
