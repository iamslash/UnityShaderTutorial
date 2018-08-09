# Abstract

텍스처 두장을 섞어봅니다.

# Shader

```c
Shader "UnityShaderTutorial/basic_blending_textures" {
    Properties { 
         _MainTex("Main Texture", 2D) = "white" {} 
         _SubTex("Sub Texture", 2D) = "white" {} 
    }

    SubShader { 
           Pass { 
               SetTexture [_MainTex] {
				 Combine texture
			   }
               SetTexture [_SubTex] { 
                 Combine texture lerp(texture) previous 
               } 
           } 
    } 
}
```

# Description

```c
SetTexture [TextureName] {Texture Block}
```

텍스처 적용 방법을 정의하는 _TextureBlock_ 내부에 `Combine(합성)` 이라는 명령어를 사용하여 텍스처를 섞습니다.

`texture` 는 _SetTexture_ 구문에서 사용된 텍스처를 뜻합니다.

`previous` 는 이전 _SetTexture_의 결과를 뜻합니다.

위 코드의 경우 첫번째 `Combine` 에서  __MainTex_ 의 결과물을 얻고, 두번째 `Combine` 에서 `lerp()`를 사용해 텍스처의 알파값을 반영한 결과물을 얻게됩니다.

## Lerp()

```c
A lerp(B) C
```
A와 C를 보간하여 결과값을 만들게 되는데, 그 기준값으로 B의 알파값을 사용하겠다는 것을 의미합니다.<br>
즉 B의 알파값은 0 ~ 1의 값을 가지며 B = 1(투명하지 않음) 인 경우 결과는 A가 되며, B = 0 인 경우 결과는 C가 됩니다.

# Prerequisites

텍스처 블록 `Combine` 명령

```
combine src1 * src2
```

src1과 src2를 서로 곱합니다. 결과는 두 입력보다 더 어둡습니다 (색상이 점점 0에 가까워 지므로).

```
combine src1 + src2
```

src1과 src2를 함께 추가합니다. 결과는 두 입력보다 밝아집니다 (색상이 점점 1에 가까워 지므로).

```
combine src1 - src2
```

src1에서 src2를 뺍니다.

```
combine src1 lerp ( src2 ) src3
```

src2의 알파를 사용해, src3와 src1를 보간합니다 알파가 1 인 경우 src1이 사용되고 알파가 0 인 경우 src3이 사용됩니다.

``` 
combine src1 * src2 + src3
```

src1에 src2의 알파 성분을 곱한 다음 src3을 더합니다.

src 프로퍼티는 아래의 키워드로 변경이 가능합니다.

+ texture : SetTexture 에서 TextureName으로 지정된 텍스처
+ previous : 이전에 계산한 텍스쳐 연산 결과
+ constant : ConstantColor의 지정된 색상

보정용 키워드

+ 위에 지정된 수식에 선택적으로 키워드 `Double` 또는 `Quad` 를 붙여 결과 색상을 2x 또는 4x 밝게 만들 수 있습니다.

```
Combine texture * previous DOUBLE
```