# Abstract

서페이스 셰이더에 대해 알아봅니다.

# Shader

```c
Shader "UnityShaderTutorial/surface_shader_simple" {
	SubShader{
		Tags{ "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Lambert
		struct Input {
			float4 color : COLOR;
		};

		void surf(Input IN, inout SurfaceOutput o) {
			o.Albedo = 1;
		}
		ENDCG
	}
	Fallback "Diffuse"
}
```

# Description

서페이스 셰이더는 `vertex` 나 `fragment` 쉐이더를 사용하는 것 보다 더 쉽게 작성할 수 있게 해주는 쉐이더임
즉, 위의 두 쉐이더를 정해진 데이터 구조에 값을 채워넣기만 하면 컴파일러가 코드를 생성한다.

## Surface Shader 컴파일 지시문

```
#pragma surface surfaceFunction lightModel [optionalparams]

ex) #pragma surface surf Lambert
```

### 필수 매개변수

#### SurfaceFunction

void surf (Input IN, inout SurfaceOutput o)

#### LightModel

Standard

StandaraSpecular

Lambert or BlinnPhong