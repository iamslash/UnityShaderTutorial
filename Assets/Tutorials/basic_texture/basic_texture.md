# Abstract

물체에 텍스쳐를 입히자

# Shader

```c
Shader "UnityShaderTutorial/basic_texture" {
    Properties {
        _MainTex ("Base Texture", 2D) = "white" {}
    }
	SubShader{
		Pass{
			SetTexture [_MainTex]
		}
	}
}c
```

# Description

`SetTexture` 는 `fixed-style function command` 중 하나이다. 물체의 텍스처를 `_MainTex` 에 설정된 텍스쳐로 변경한다.

# Prerequisites

## What is SetTexture?

`SetTexture` 의 자세한 내용은 [메뉴얼](https://docs.unity3d.com/Manual/SL-SetTexture.html)을 참조하고, 여기선 간략한 키워드만 확인 하자

문법은 아래와 같다

```c
SetTexture [TextureName] {
  Texture Block
}
```

`TextureName` 에는 적용 하고자 하는 텍스쳐의 `Properties`의 이름을 기입해야 한다.

`Texture Block` 에는 `combine` 커맨드가 사용된다.

`combine` 커맨드는 여러가지 텍스쳐 혹은 컬러를 섞는데 사용 된다.

### combine 의 활용

```c
combine src1 * src2 : src1과 src2를 곱한다. 결과값은 더 어두워지는 효과를 얻는다.
combine src1 + src2 : src1에 src2를 더한다. 결과값은 더 밝아지는 효과를 얻는다.
combine src1 - src2 : src1에서 src2를 뺀다.
combine src1 lerp (src2) src3 : src2의 알파값을 이용해서 src1과 src3의 보간한다.
```

`src` 에는 `previous` `constant` `texture` 중에 하나가 될 수 있다.
`previous` : 이전 `SetTexture` 의 결과값
`constant` : `constantColor` 로 선언한 컬러 값
`texture` : 현재 `SetTexture` 에 선언된 `TextureName` 에 해당