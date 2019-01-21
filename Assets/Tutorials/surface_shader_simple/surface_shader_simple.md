# Abstract

서피스 셰이더에 대해 알아봅니다.

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
즉, 위의 두 쉐이더를 정해진 데이터 구조에 값을 채워넣기만 하면 컴파일러가 코드를 생성함

아래의 그림은 서피스 쉐이더가 어떻게 동작하는지 간략하게 보여주고 있음

![](./Images/surface_shader.PNG)

## Surface Shader 컴파일 지시문

```
#pragma surface surfaceFunction lightModel [optionalparams]

ex) #pragma surface surf Lambert
```

위의 예제 구문을 해석하자면 "해당 쉐이더를 위한 서피스 함수 이름은 surfaceFunction 이고, 라이텡 모델로는 램버시안 라이팅 모델을 사용할 것 이다." 입니다.

## 필수 매개변수

### SurfaceFunction 서피스 함수

void surf (Input IN, inout SurfaceOutput o)

서피스 함수는 모델의 데이터를 입력으로 가져와서 결과값으로 렌더링 프로퍼티들을 반환함

### LightModel 조명 모델

Standard

StandaraSpecular

Lambert or BlinnPhong

## Surface Shader 표준 출력 구조

```
struct SurfaceOutput
{
    fixed3 Albedo;  // diffuse color
    fixed3 Normal;  // tangent space normal, if written
    fixed3 Emission;
    half Specular;  // specular power in 0..1 range
    fixed Gloss;    // specular intensity
    fixed Alpha;    // alpha for transparencies
};
```

SurfaceOutput 구조체 안에는 머티리얼의 최종 모습을 결정하기 위해 사용되는 여러가지 프로퍼티들을 포함하고 있음

## SurfaceInput 서피스 인풋

```
struct Input {
    float4 color : COLOR;
};
```
        
서피스 인풋인 Input 구조체의 변수들은 Unity가 계산할 값으로 채울 수 있음

## Vertex Modifier ??