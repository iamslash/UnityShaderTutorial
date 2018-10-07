# Abstract

 스텐실 테스트를 적용해 보자

# Shader

```c
Shader "UnityShaderTutorial/basic_stencil_test1" {
    SubShader {
        Tags { "RenderType"="Opaque" "Queue"="Geometry"}
        Pass {
            Stencil {
                Ref 2
                Comp always
                Pass replace
            }
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            struct appdata {
                float4 vertex : POSITION;
            };
            struct v2f {
                float4 pos : SV_POSITION;
            };
            v2f vert(appdata v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            half4 frag(v2f i) : SV_Target {
                return half4(1, 0, 0, 1); // red
            }
            ENDCG
        }
    } 
}

Shader "UnityShaderTutorial/basic_stencil_test2" {
    Stencil {
        Ref 2
	    Comp equal
	    Pass keep
	    ZFail decrWrap
    }

    ...

    half4 frag(v2f i) : SV_Target {
        return half4(0, 1, 0, 1); // green
    }
}

Shader "UnityShaderTutorial/basic_stencil_test3" {
    Stencil {
        Ref 1
	    Comp equal
    }

    ...

    half4 frag(v2f i) : SV_Target {
        return half4(0, 0, 1, 1); // blue
    }
}
```

## Description

스텐실 버퍼는 픽셀을 저장 또는 폐기하기 위한 용도의 픽셀 마스크로 사용이 가능하다.

보통 한 픽셀당 8비트 정수값이며 사용자가 정한 값(참조값)과 버퍼의 크다, 작다, 같다 등등 옵션을 통해 매치하여 해당 픽셀을 사용할지 말지를 결정한다.

스텐실 작업의 문법은 아래와 같다.

```
Stencil {
	[Ref 0 ~ 255]
	[Comp always]
        [ReadMask 0 ~ 255]
        [WriteMask 0 ~ 255]
	[Pass keep]
	[Fail keep]
	[ZFail keep]
}
```

## Unity ShaderLab Stencil
`Ref`

```
Ref (0 ~ 255)
- Comp가 always가 아니고 다른 것일 때 비교하는 값이며, 
  Pass, Fail이나 ZFail이 replace로 설정된 경우 버퍼에 써넣을 값. 0-255 정수
```

`ReadMask`

```
ReadMask (0 ~ 255)
- Ref 값을 버퍼의 내용과 비교할 때 사용
  (referenceValue & readMask) 비교 함수 (stencilBufferValue & readMask)
```

`Comp`

```
Comp (비교 함수)
- 버퍼 안의 현재 값과 참조 값을 비교할 때 사용할 함수. 기본 always.
```

`Pass`

```
Pass (스텐실 작업)
- 스텐실 검사(와 깊이 검사)가 통과한 경우 버퍼 안의 값을 어떻게 할지 정합니다. 기본 keep.
```

`Fail`

```
Fail (스텐실 작업)
- 스텐실 검사가 실패한 경우 버퍼 안의 값을 어떻게 할지 정합니다. 기본 keep.
```

`ZFail`

```
ZFail (스텐실 작업)
- 스텐실 검사는 통과했지만 깊이 검사가 실패한 경우 버퍼 안의 값을 어떻게 할지 정합니다. 기본 keep.
```

`비교 함수`

|||
|:-:|:-:|
|Greater	|버퍼의 값보다 참조 값이 큰 픽셀만 그립니다.|
|GEqual	 	|버퍼의 값보다 참조 값이 크거나 같은 픽셀만 그립니다.|
|Less	 	|버퍼의 값보다 참조 값이 작은 픽셀만 그립니다.|
|LEqual  	|버퍼의 값보다 참조 값이 작거나 같은 픽셀만 그립니다.|
|Equal	 	|버퍼의 값과 참조 값이 같은 픽셀만 그립니다.|
|NotEqual	|버퍼의 값과 참조 값이 다른 픽셀만 그립니다.|
|Always	 	|스텐실 검사가 무조건 통과됩니다.|
|Never	 	|스텐실 검사가 무조건 실패합니다.|

`스텐실 작업`

|||
|:-:|:-:|
|Keep		|버퍼의 현재 값을 유지합니다.|
|Zero		|버퍼에 0을 써넣습니다.|
|Replace	|버퍼에 참조 값을 써넣습니다.|
|IncrSat	|버퍼의 현재 값을 올립니다. 값이 이미 255이면 255를 유지합니다.|
|DecrSat	|버퍼의 현재 값을 내립니다. 값이 이미 0이면 0을 유지합니다.|
|Invert		|모든 비트를 반전합니다.|
|IncrWarp	|버퍼의 현재 값을 올립니다. 값이 이미 255이면 0으로 변합니다.|
|DecrWarp	|버퍼의 현재 값을 내립니다. 값이 이미 0이면 255로 변합니다.|
