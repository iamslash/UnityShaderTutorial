# Abstract

 스텐실 테스트를 적용해 보자

# Shader

```c
Shader "UnityShaderTutorial/basic_stencil_test" {
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
                return half4(1,0,0,1);
            }
            ENDCG
        }
    } 
}
```

# Description

`Stencil`을 이용하여 버퍼에 있는 픽셀값을 버리거나 변경처리를 한다.
`Stencil` 의 [문법]은 아래와 같다.
```
Stencil {
	Ref (0~255)
	[Comp always]
	[Pass keep]
	[Fail keep]
	[ZFail keep]
}
```

# Prerequisites

## Unity ShaderLab Overview
`Ref`

```
Ref (참조할 값)
- Comp가 always가 아니고 다른 것일 때 비교하는 값이며, 
  Pass, Fail이나 ZFail이 replace로 설정된 경우 버퍼에 써넣을 값. 0-255 정수
```

`Comp`

```
Comp (비교 함수)
- 버퍼 안의 현재 값과 참조 값을 비교할 때 사용할 함수. 기본 always.
```

`비교 함수`

|||
|-|-|-|
|Greater	|버퍼의 값보다 참조 값이 큰 픽셀만 그립니다.|
|GEqual	 	|버퍼의 값보다 참조 값이 크거나 같은 픽셀만 그립니다.|
|Less	 	|버퍼의 값보다 참조 값이 작은 픽셀만 그립니다.|
|LEqual  	|버퍼의 값보다 참조 값이 작거나 같은 픽셀만 그립니다.|
|Equal	 	|버퍼의 값과 참조 값이 같은 픽셀만 그립니다.|
|NotEqual	|버퍼의 값과 참조 값이 다른 픽셀만 그립니다.|
|Always	 	|스텐실 검사가 무조건 통과됩니다.|
|Never	 	|스텐실 검사가 무조건 실패합니다.|
|||

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

`스텐실 작업`

|||
|-|-|-|
|Keep		|버퍼의 현재 값을 유지합니다.|
|Zero		|버퍼에 0을 써넣습니다.|
|Replace	|버퍼에 참조 값을 써넣습니다.|
|IncrSat	|버퍼의 현재 값을 올립니다. 값이 이미 255이면 255를 유지합니다.|
|DecrSat	|버퍼의 현재 값을 내립니다. 값이 이미 0이면 0을 유지합니다.|
|Invert		|모든 비트를 반전합니다.|
|IncrWarp	|버퍼의 현재 값을 올립니다. 값이 이미 255이면 0으로 변합니다.|
|DecrWarp	|버퍼의 현재 값을 내립니다. 값이 이미 0이면 255로 변합니다.|
|||
