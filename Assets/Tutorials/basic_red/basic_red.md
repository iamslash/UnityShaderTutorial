# Abstract

물체를 빨간색으로 칠한다.

# Shader

```c
Shader "UnityShaderTutorial/basic_red" {
	SubShader{
		Pass{
			Color(1,0,0,1)
		}
	}
}
```

# Description

`fixed-style function command` 중 하나인 `Color`  를 이용하여 물체를 빨간색 `(1, 0, 0, 1)` 으로 칠한다. Color 의 인자는 순서대로 `red, green, blue, alpha` 를 의미한다.

# Prerequisites

## Unity ShaderLab Overview

`Shader` 의 문법은 다음과 같다.

```c
Shader "name" { 
  [Properties] 
  Subshaders 
  [Fallback] 
  [CustomEditor] 
}
```

`Shader` 는 한개만 존재한다. 이름에 `/` 가 사용되면 inspector 에서 구분되어 보여진다.

`SubShader` 의 문법은 다음과 같다.

```c
Subshader { 
  [Tags] 
  [CommonState] 
  Pass 
  [Pass ...] }
```

`SubShader` 는 한개 이상일 수 있다. 여러 개의 `SubShader` 중 target machine 이 지원하는 첫번째 `SubShader` 가 실행된다. 만약 지원가능한 `SubShader` 가 없다면 `FallBack Shader` 가 실행된다.

`Pass` 의 문법은 다음과 같다.

```c
Pass { 
  [Name and Tags] 
  [RenderSetup] 
  [fixed-function style commands] 
}
```

`Pass` 는 한개 이상일 수 있다. 하나의 `Pass`는 `Name`, `tags`, `Render state set-up`, `fixed-function style commands` 등으로 구성된다. 

`Name` 은 `Pass` 의 이름을 표현한다. 다음과 같이 사용한다.

```c
Name "PassName"
```

`tags` 는 어떻게 렌더링될지 언제 렌더링 될지를 표현하기 위해 다음과 같이 이름과 값의 형태로 사용한다. 

```c
Tags { 
  "TagName1" = "Value1" 
  "TagName2" = "Value2" 
}
```

`tags` 의 종류는 `LightMode tag, PassFlags tag, RequireOptions tag` 등이 있다.

`Render state set-up` 의 종류는 `Cull, ZTest, ZWrite, Offset, Blend, ColorMask` 등이 있고 다음과 같이 사용한다.

```c
* Cull
1. 그려야 할 부분 제어.
ex) Cull Back | Front | Off

* ZTest
1. 기본적으로 LEqual이 활성화. (나와 Object 사에에 거리가 같거나 작은 것들은 그리고 그 뒤에 있는 것들은 그리지 않는다).
ex) ZTest (Less | Greater | LEqual | GEqual | Equal | NotEqual | Always)

* ZWrite
1. DepthBuffer에 해당 Object의 Pixel 정보를 저장할지를 제어.
2. 기본적으로 on (반투명한 Object일 경우 off 필요).
ex) ZWrite On | Off

* Offset
1. Factor : 다각형의 Z축을 조정 , Units : DepthBuffer 값을 조정.
ex) Offset OffsetFactor, OffsetUnits

* Blend
1. 알파 블렌딩, 알파 연산 및 알파 적용 모드 설정.
ex)
Blend sourceBlendMode destBlendMode
Blend sourceBlendMode destBlendMode, alphaSourceBlendMode alphaDestBlendMode
BlendOp colorOp
BlendOp colorOp, alphaOp
AlphaToMask On | Off

* ColorMask
1. 사용하고자 하는 컬러 채널을 마스크에 설정.
2. 0 을 사용 할 경우 모든 채널의 색을 랜더링하지 않는다.
ex) ColorMask RGB | A | 0 | any combination of R, G, B, A
```

`fixed-style function commands` 의 종류는 `Lighting, Material, SeparateSpecular, Color, ColorMaterial, Fog, AlphaTest, SetTexture ` 등이 있고 다음과 같이 사용한다.

```c
* Lighting
1. 정점 조명 제어.
ex) Lighting On | Off

* Material
1. Inspector상에서 Material 내용 변경을 쉽게 할 수 있도록 제어.
ex) Material { Diffuse [_Color] }

* SeparateSpecular
1. HighLight를 위한 색 분리 제어.
ex) SeparateSpecular On | Off

* Color
1. 색 제어
ex) color(1, 0, 0, 1)

* ColorMaterial
1. Material에서 사용되고 있는 기존 색상 대신 버텍스별 색상을 만든다.
ex) ColorMaterial AmbientAndDiffuse | Emission

* Fog
1. 카메라와의 거리에 따라 일정한 색으로 블랜딩 처리.
ex) Fog { Fog Block }

AlphaTest (Less | Greater | LEqual | GEqual | Equal | NotEqual | Always) CutoffValue

SetTexture textureProperty { combine options }
```
