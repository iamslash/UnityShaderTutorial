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

### 월드 좌표 변환
3D 환경에서 큐브를 하나 표현하려고 할때 정점 4개를 이용해서 표현할 수 있다. 그리고 큐브의 사이즈, 회전, 위치를 표현하려고 할때 
기준이되는 좌표계가 필요한데, 가장 쉬운 방법이 큐브 중심을 좌표계 원점으로하는 좌표계를 사용하는 것이다. 이 좌표계를 `로컬 좌표계`라고 한다.

위와 같이 표현된 큐브를 여러개 표현하려고 할 때에는 `로컬좌표계`로는 전체를 표현할 수 없다. `로컬 좌표계`는 각 객체에서만 의미 있기 때문이다.
그래서 `월드 좌표계`가 필요하고, 각 정점의 표현도 `월드 좌표계`를 기준으로한 값으로 다시 표현되어야 한다.

이전 [좌표계 변환](https://github.com/iamslash/UnityShaderTutorial/blob/master/Assets/Tutorials/transformations/transformations.md)
에서 봤듯이 `로컬 좌표계`를 기준으로 하는 특정 좌표를 `월드 좌표계`를 기준으로 하는 새로운 좌표로 표현하려면 좌표계 변환을 하면 된다. 
이 변환을 위해서 사용되는 행렬을 `월드 행렬 (WorldMatrix)` 이라고 하며, 아래와 같이 표현 할 수 있다. 

![](world_matrix.png)
```latex
W =
\begin{bmatrix}
    u_{x} & u_{y} & u_{z} & 0 \\
    v_{x} & v_{y} & v_{z} & 0 \\
    w_{x} & w_{y} & w_{z} & 0 \\
    Q_{x} & Q_{y} & Q_{z} & 1 \\
\end{bmatrix} \\
```

이전 [좌표계 변환](https://github.com/iamslash/UnityShaderTutorial/blob/master/Assets/Tutorials/transformations/transformations.md) 에서도 언급했었듯이, 이 변환 행렬은 새로운 좌표계를 기준으로 새롭게 정의 되는 비례(S), 회전(R), 이동(T) 이 합성된것이다. 그렇기 때문에 아래와 같이 표현된다.

![](world_matrix_2.png)


유니티의 쉐이더에서는 버텍스의 월드 좌표를 구하려고 할때 `unity_ObjectToWorld` 를 이용해서 구할 수 있다.

```c
output.position_in_world_space = mul(unity_ObjectToWorld, input.vertex);
```

### 뷰 좌표 변환

3D 환경을 화면상에 그리기 위해서는 카메라가 필요 하다. 이 카메라의 위치에 따라서, 동일한 환경이라도 보여지는 방식이 달라지게 된다.
이 카메라 또한 환경을 이루는 존재중에 하나 이다. 그렇기 때문에, 로컬 좌표계를 가지게 되는데 이 좌표계를 `뷰 좌표계` 라고 한다.
이전까지 `월드 좌표계`로 변환됬던것을 이제 `뷰 좌표계`로 변환해야 한다.

위 `월드 좌표 변환` 에서 봤듯이, 로컬 좌표계에서 월드 좌표계로 변환을 하기 위해서 사용되는 행렬 `W`를 정의 했었다. `뷰 좌표계` 또한 `카메라의 로컬좌표계` 라고 했으니, `뷰 좌표계`에서 `월드 좌표계`로 변환 할 때 `W`를 사용 할 수 있다는것을 안다. 하지만 우리가 알고 싶은것은 `월드 좌표계`에서 `뷰 좌표계` 로의 변환이기 때문에, `W` 행렬의 역행렬을 이용할 수 있다. 이 행렬을 `시야 행렬 (view matrix)` 라고 하고 아래와 같이 정의 할 수 있다.

![](view_matrix.png)

```latex
\begin{aligned}

V &= W^{-1}\\
  &= (RT)^{-1}\\
  &= T^{-1}R^{-1}\\
  &= T^{-1}R^{T}\\
  &= 
     \begin{bmatrix}
          1 & 0 & 0 & 0 \\
          0 & 1 & 0 & 0 \\
          0 & 0 & 1 & 0 \\
          -Q_{x} & -Q_{y} & -Q_{z} & 1 \\
     \end{bmatrix} 
     \begin{bmatrix}
          u_{x} & v_{x} & w_{x} & 0 \\
          u_{y} & v_{y} & w_{y} & 0 \\
          u_{z} & v_{z} & w_{z} & 0 \\
          0 & 0 & 0 & 1 \\
     \end{bmatrix} \\
  &= \begin{bmatrix}
          u_{x} & v_{x} & w_{x} & 0 \\
          u_{y} & v_{y} & w_{y} & 0 \\
          u_{z} & v_{z} & w_{z} & 0 \\
          -Q\cdot u & -Q\cdot v & -Q\cdot w & 1 \\
     \end{bmatrix} \\
\end{aligned}
```


### 프로젝션 좌표 변환
