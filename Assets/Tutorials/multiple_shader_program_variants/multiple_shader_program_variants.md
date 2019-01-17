# Abstract

`#pragma multi_compile` 와 `#pragma shader_feature` 의 사용법을 이해하자

# Shader

```c
Shader "UnityShaderTutorial/shader_variants" {
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vertexShader
            #pragma fragment fragmentShader
            #pragma multi_compile RED GREEN BLUE
            
            float4 vertexShader (float4 vertex : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertex);
            }

            fixed4 fragmentShader () : SV_Target
            {
                fixed4 col = fixed4 (0, 0, 0, 1);
                # ifdef RED
                    col = fixed4 (1, 0, 0, 1);
                # elif GREEN
                    col = fixed4 (0, 1, 0, 1);
                # elif BLUE
                    col = fixed4 (0, 0, 1, 1);
                # endif
                return col;
            }
            ENDCG
        }
    }
}
```

# Description

유니티에는 쉐이더의 `Shader` 나 `Material`의 `[Enable | Disable] Keyword`를 이용해서 원하는 기능을 `ON`, `OFF` 할 수 있도록 제공한다. 

`Keyword`는 아래와 같이 작성 할 수 있다.
```
#pragma multi_compile FEATURE_A FEATURE_B
#pragma shader_feature FEATURE_A FEATURE_B
```

위 예제 쉐이더 코드에서는 `RED` `GREEN` `BLUE`, 3가지 `Keyword`를 선언했다.
```
#pragma multi_compile RED GREEN BLUE
```

각 키워드에 따라서, 쉐이더는 다르게 작동을 한다.
```
    # ifdef RED
        col = fixed4 (1, 0, 0, 1);  //RED 키워드가 활성화 되면, 물체의 색상을 빨간색으로 칠한다.
    # elif GREEN
        col = fixed4 (0, 1, 0, 1); //GREEN 키워드가 활성화 되면, 물체의 색상을 녹색으로 칠한다.
    # elif BLUE
        col = fixed4 (0, 0, 1, 1); //BLUE 키워드가 활성화 되면, 물체의 색상을 파란색으로 칠한다.
    # endif
```

더욱 자세한 내용은 [Unity Manual](https://docs.unity3d.com/Manual/SL-MultipleProgramVariants.html) 에서 확인 할 수 있다.


# multi_compie vs shader feature

만약 아래와 같이 선언 할 경우 `Variants`는 4가지가 나온다.

```
#pragma multi_compile A B
#pragma multi_compile C D
```

*  A + C
*  A + D
*  B + C
*  B + D

위와 같이 `multi_compile` 로 선언했다면, 현재 씬에서 어떻게 사용하던 상관없이 4가지 형태의 쉐이더를 컴파일한다. 


```
#pragma shader_feature A B
#pragma shader_feature C D
```
위와 같이 `shader_feature` 로 선언하고,  현재 씬에서 `A + D` 만 사용한다면, 빌드 할 때 `A + D` 만 컴파일되고 나머지 `Variants`는 컴파일 되지 않는다.

만약 아래와 같이 극단적으로 복합적으로 `Keyword`를 많이 쓰게 될경우 `Variants`는 1024개가 나올 수 있다.

```
#pragma multi_compile A B
#pragma multi_compile C D 
#pragma multi_compile E F
#pragma multi_compile G H
#pragma multi_compile I J
#pragma multi_compile K L
#pragma multi_compile M N
#pragma multi_compile O P
#pragma multi_compile Q R
#pragma multi_compile S T
            
```

`multi_compile`로 한번 빌드 하고, `shader_feature` 로 바꾼후에 빌드 한 이후 각 BuildReport 를 보면 아래와 같이 빌드에 포함된 쉐이더의 용량 차이를 확인 할 수 있다.
```
Build Report
Uncompressed usage by category:
Textures      0.0 kb	 0.0% 
Meshes        0.0 kb	 0.0% 
.... ( 중략 )
Used Assets and files from the Resources folder, sorted by uncompressed size:
 274.6 kb 0.5% multiple_shader_program_variants.shader // multi_compile 일 때
 2.9 kb	 0.0% multiple_shader_program_variants.shader  // shader_feature 일 때
```





























