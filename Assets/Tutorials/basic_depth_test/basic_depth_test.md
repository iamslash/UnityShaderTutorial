# Abstract

깊이 테스트를 정리 해보자.

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

깊이 버퍼 (Depth Buffer) 란 프레임퍼버 (Frame Buffer) 과 가로, 세로의 길이가 같고 각 프래그먼트의 깊이 (z) 값을 저장한다. 즉 같은 개수의 픽셀 을 처리한다. 깊이 테스트란 프래그먼트 쉐이딩 (Fragment Shading) 을 수행한 후에 특정 프래그먼트에 대해서 현재의 깊이버퍼 값을 덮어쓸지 말지 검증하는 절차이다. `UnityShaderLab` 에서는 깊이 버퍼 값이 작을 수록 카메라와 가깝다.

`ZTest` Render Set-up Command 는 다음과 같이 사용한다.

```
ZTest (Less | Greater | LEqual | GEqual | Equal | NotEqual | Always)
* LEqual 이 기본 값이다.
```

각 옵션이 사용된 결과는 다음과 같다.

* `Less`

![](./Image/Less.png)

* `LEqual`

![](./Image/LEqual.png)

* `Greater`

![](./Image/Greater.png)

* `GEqual`

![](./Image/GEqual.png)

+ `Equal`

![](./Image/Equal.png)

* `Not Equal`

![](./Image/NotEqual.png)

* `Always`

![](./Image/Always.png)
