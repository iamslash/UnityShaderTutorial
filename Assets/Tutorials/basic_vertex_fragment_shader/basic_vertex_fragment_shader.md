# Abstract

기본적인 vertex, fragment shader 를 작성하고 좌표변환을 이해하자.

# Shader

```c
Shader "UnityShaderTutorial/basic_vertex_fragment_shader" {
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vertexShader
            #pragma fragment fragmentShader

            float4 vertexShader (float4 vertex : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertex);
            }

            fixed4 _Color;

            fixed4 fragmentShader () : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
```

# Description

vertex shader 는 vertex 개수 만큼 호출된다. fragment shader 는 fragment 개수 만큼 호출된다. 물체의 표면색을 `_Color` property 로 칠하자.

`CGPROGRAM` ~ `ENDCG` 키워드의 의미는 '이 키워드 안에서는 **CG Language** 로 작성 하겠다는 의미이다. 

`#pragma` 는 쉐이더 함수를 컴파일하겠다는 지시문으로 사용 된다. 그래서

`#pragma vertex vertexShader` : **vertex shader**의 컴파일 함수의 이름은 *vertexShader* 라는 의미를 가지며

`#pragma fragment fragmentShader` : **fragment shader**의 컴파일 함수의 이름은 *fragmentShader* 라는 의미이다.

```c
float4 vertexShader (float4 vertex : POSITION) : SV_POSITION
fixed4 fragmentShader () : SV_Target
```

함수의 구성은 아래와 같다
```c
[ReturnType] [Function Name] ([Parmeter]) : [Semantic Signifier] 
```
`Semantic Signifier` : 위 `Shader` 코드에서 **: POSITION**,  **:SV_POSITION** , **: SV_TARGET** 을 의미하는데, 각 변수들이 의미하는 바를  `GPU` 에게 설명하기 위함이다.

`Properties` 에 선언해 놓은 `_Color` 를 `CGPROGRAM` 내부에서 사용하기 위해서는 변수 선언을 해줘야 하는데, 반드시 `Properties` 에서 선언한 이름과 동일해야 하며, 코드에서 사용하기 전에 선언해야 한다.

더욱 자세한 내용은 [Unity Manual](https://docs.unity3d.com/Manual/SL-ShaderPrograms.html) 에서 확인 할 수 있다.
# Prerequisites

## Transformations
