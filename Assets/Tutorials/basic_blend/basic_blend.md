# Abstract

Blend 커맨드를 사용하여 투명 색상을 만듭니다.

# Shader

```c
Shader "UnityShaderTutorial/basic_blend" {
    Properties {
        _Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D) = "white" {}
    }

    SubShader {
        Tags { "Queue" = "Transparent" }
        Pass {
        	Blend srcAlpha OneMinusSrcAlpha

			SetTexture[_MainTex] {
				ConstantColor[_Color]
				Combine texture lerp(texture) previous, constant
			}
        }
    }
}
```

# Description

오브젝트를 반투명하게 만들기 위해서는 렌더링 할 오브젝트의 결과 색상값을 어떻게 섞을지 명시해줘야 합니다.

```
Blend SrcFactor DstFactor
```

_Blend_ 커맨드를 이용하여 렌더 상태를 변경해주고(Default Off), 어떤식으로 섞을지를 정의합니다.<br>
위 구문은 (이제 나올 결과 색상값 * SrcFactor) + (이미 스크린 버퍼에 존재하는 색상값 * DstFactor) 이렇게 색상을 섞어서 최종 색상값을 결정하겠다는 뜻 입니다.

## ConstantColor

`ConstantColor` 커맨드는 색상을 상수로 지정하겠다는 구문입니다. 예제에서는 에디터에서 알파값을 지정해주기 위해 프로퍼티의 `_Color` 값을 이용하므로 `ConstantColor[_Color]` 라는 구문을 사용하여 색상을 따로 지정해줍니다.

## constant

TextureBlock에 `constant` 라는 구문은 그냥 어떤 상수값을 의미하고 `ConstantColor` 라는 커맨드를 사용하여 지정합니다. 또한 `Combine` 커맨드에서는 색상과 알파 연산을 분리할 수 있습니다. 예제에서는 우리가 따로 지정한 알파값을 사용하기 위해 `,` 를 넣어 색상 연산과 알파 연산을 분리하였습니다.

## Tags { Queue }

`Queue` 태그는 렌더링 순서를 결정하는데 사용합니다. 유니티는 아무런 Queue 태그를 지정하지 않으면 디폴트로 `Geometry` 큐로 지정합니다. 반투명 오브젝트의 경우 다른 오브젝트 보다 늦게 렌더링 되어야 하기 때문에 `Transparent`를 사용하여 렌더링 순서를 지정합니다.

# Prerequisites

## Blend Factor

Blend 커맨드 연산에 사용되는 계수들
+ One : 소스 또는 데스티네이션 색상을 온전히 사용함
+ Zero : 소스 또는 데스티네이션 색상을 삭제함
+ SrcColor : 현재 단계의 값에 소스 색상값을 곱함
+ SrcAlpha : 현재 단계의 값에 소스 알파값을 곱함
+ DstColor : 현재 단계의 값에 프레임버퍼 색상값을 곱함
+ DstAlpha : 현재 단계의 값에 프레임 버퍼 알파값을 곱함
+ OneMinusSrcColor : 현재 단계의 (1 - 소스 색상)값을 곱함
+ OneMinusSrcAlpha : 
+ OneMinusDstColor : 
+ OneMinusDstAlpha : 