# Abstract

물체에 알파 테스트를 적용해보자.

# Shader

```c
Shader "UnityShaderTutorial/basic_alpha_test" {
    Properties {
        _MainTex ("Base (RGB) Transparency (A)", 2D) = "" {}
	_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
	Pass{
	    // Use the Cutoff parameter defined above to determine
	    // what to render.
	    AlphaTest Greater [_Cutoff]
	    SetTexture[_MainTex]{ combine texture }
	}
    }
}
```

# Description

알파 테스트는 픽셀이 화면에 렌더링 될 때, 알파 값에 따라 해당 픽셀을 그릴지 말지 결정하는 테스트이다.

`AlphaTest` command의 인자는 `comparison, AlphaValue` 두 개이며, `comparison`에는 Greater, `AlphaValue`에는 _Cutoff의 값이 들어간다.

코드는 텍스쳐 픽셀 중 _Cutoff의 값보다 큰 알파 값을 가지는 픽셀만 화면에 그리게 한다.

# Prerequisites

## Unity ShaderLab AlphaTest

`AlphaTest`의 [문법](https://docs.unity3d.com/kr/530/Manual/SL-AlphaTest.html)은 다음과 같다.

```c
 AlphaTest comparison AlphaValue
```

기본 값은 `AlphaTest Off` (모든 픽셀을 렌더링)이다.

`comparison`에는 

Greater	: 픽셀의 알파 값이 AlphaValue 보다 큰 경우에만 렌더링.

GEqual	: 픽셀의 알파 값이 AlphaValue 보다 크거나 같은 경우에만 렌더링.

Less	: 픽셀의 알파 값이 AlphaValue 보다 작은 경우에만 렌더링.

LEqual	: 픽셀의 알파 값이 AlphaValue 보다 작거나 같은 경우에만 렌더링.

Equal	: 픽셀의 알파 값이 AlphaValue 와 동일한 경우에만 렌더링.

NotEqual: 픽셀의 알파 값이 AlphaValue 와 동일하지 않은 경우에만 렌더링.

Always	: 모든 픽셀을 렌더링. AlphaTest Off 와 동일한 기능

Never	: 모든 픽셀을 렌더링하지 않는다.

중 1개의 키워드가 들어간다.

`AlphaValue`는 0과 1사이의 float number이다.
