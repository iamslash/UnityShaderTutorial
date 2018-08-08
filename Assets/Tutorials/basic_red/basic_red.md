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

`SubShader` 는 한개 이상일 수 있다. 여러 개의 `SubShader` 중 target machine 이 지원하는 첫번째 `SubShader` 가 실행된다. 만약 지원가능한 `SubShader` 가 없다면 `FallBack` 이 실행된다.

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

`tags` 는 어떻게 렌더링될지 혹은 언제 렌더링될지를 표현하기 위해 다음과 같이 이름과 값의 형태로 사용한다. 

```c
Tags { 
  "TagName1" = "Value1" 
  "TagName2" = "Value2" 
}
```

`tags` 의 종류는 `LightMode tag, PassFlags tag, RequireOptions tag` 등이 있다.

`Render state set-up` 의 종류는 `Cull, ZTest, ZWrite, Offset, Blend, ColorMask` 등이 있고 다음과 같이 사용한다.

```c
Cull Back | Front | Off

ZTest (Less | Greater | LEqual | GEqual | Equal | NotEqual | Always)

ZWrite On | Off

Offset OffsetFactor, OffsetUnits

Blend sourceBlendMode destBlendMode
Blend sourceBlendMode destBlendMode, alphaSourceBlendMode alphaDestBlendMode
BlendOp colorOp
BlendOp colorOp, alphaOp
AlphaToMask On | Off

ColorMask RGB | A | 0 | any combination of R, G, B, A
```

`fixed-style function commands` 의 종류는 `Lighting, Material, SeparateSpecular, Color, ColorMaterial, Fog, AlphaTest, SetTexture` 등이 있고 다음과 같이 사용한다.

```
Lighting On | Off
Material { Material Block }
SeparateSpecular On | Off
Color Color-value
ColorMaterial AmbientAndDiffuse | Emission

Fog { Fog Block }

AlphaTest (Less | Greater | LEqual | GEqual | Equal | NotEqual | Always) CutoffValue

SetTexture textureProperty { combine options }
```
