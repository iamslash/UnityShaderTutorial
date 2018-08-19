# Abstract

물체를 반투명하게 만들어 보자.

# Shader

```c
Shader "UnityShaderTutorial/basic_translucent" {
    Properties { 
        _Color ("Main Color", COLOR) = (1,1,1,0.5) 
        _MainTex("Texture", 2D) = "white" {} 
    } 
    SubShader {
	Tags { "Queue" = "Transparent" }
        Pass {
            Blend SrcAlpha OneMinusSrcAlpha 
                                                                       
            SetTexture [_MainTex] {
                    constantColor[_Color] 
                    Combine texture, constant
            }
        } 
    } 
} 
```

# Description

오브젝트를 반투명하게 만들기 위해서는 `Blend` command를 사용하여 겹치는 오브젝트의 색상값을 어떻게 표현해야할 지 명시해 주어야 한다. 그렇지 않으면 `Blend`는 비활성화 상태가 되고 현재 오브젝트 뒤에 있는 모든 색상은 덮어씌워져 보이지 않게 된다.

물체의 RGB값은 그대로 두고 알파값만을 수정하여 표현할 것이기 때문에 `Blend` command의 인자는 Alpha 종류가 된다. 


위의 코드에서 `Blend` command의 인자는 `SrcFactor, DstFactor` 두 개이며, `SrcFactor`에는 해당 오브젝트의 알파값이, `DstFactor` '1 - 해당 오브젝트의 알파값'이 들어간다.

`SetTexture Block`에서 오브젝트의 알파값을 텍스쳐에 적용하는 일을 한다. `constantColor` command는 `constant` 색상을 정의하고 `combine` command에서 사용할 수 있도록 만들어준다. `combine` command의 인자 의미는 'texture에 constant의 알파값을 적용한다.' 이다.

`Combine texture * constant` 또한 비슷한 결과가 나오지만, constant의 RGB값이 texture에 적용된다는 것이 차이점이다.

위의 코드에서 `Tags` command는 해당 오브젝트의 렌더링 순서를 "Transparent"로 변경한다. 해당 태그의 값은 Unity에서 지정한 값이며, `Tags` command를 사용하지 않았을 경우 렌더링 순서가 같은 다른 오브젝트들이 해당 오브젝트 위에 그려질 가능성이 있다. 

# Prerequisites

## Unity ShaderLab SubShader Tags

SubShader는 `Tags`를 사용할 수 있으며, SubShader의 `Tags`는 rendering engine에 렌더링할 방법과 시기를 알려줍니다. `Tags`의 [문법](https://docs.unity3d.com/Manual/SL-SubShaderTags.html)은 다음과 같다.

```c
 Tags { "TagName1" = "Value1" "TagName2" = "Value2" }
```

기본적으로 키-값 pair이며, 렌더링 순서와 SubShader의 다른 매개변수를 결정하는 데 사용되는 태그들이 있다. 내장 태그 이외에 자신이 태그를 만들어서 사용할 수도 있다. 
Unity built-in 태그들은 다음과 같다.

* Rendering Order - Queue tag

해당 오브젝트가 그려지는 순서를 결정할 수 있다. 미리 정의된 render queue는 다음과 같다.

`Background` : 다른 것들보다 먼저 렌더링한다. 보통 배경에 위치하는 오브젝트들은 이 값을 사용한다.

`Geometry`(default) : 불투명한 오브젝트들, 기본 물체들이 이 값을 사용한다.

`AlphaTest` : 알파테스트를 한 불투명 오브젝트들이 이 값을 사용한다. solid 오브젝트가 그려진 후 alpha-tested 오브젝트를 그리는 것이 더 효율적이기 때문에 분리되어 있다.

`Transparent` : 유리나 파티클 이펙트 같은 반투명 오브젝트들이 이 값을 사용한다.

`Overlay` : 렌즈 플레어와 같은 overlay 이펙트들이 이 값을 사용한다.

각각의 queue들은 모두 정수형 인덱스로 표현되기 때문에 각 키워드에 정수를 더해 렌더링 순서를 조절할 수 있다. 

Unity render engine은 "Geometry+500"까지를 불투명 오브젝트로 간주하여 최상의 성능을 내도록 그리기 순서를 최적화한다. 더 높은 queue는 투명 오브젝트로 간주하여 거리별로 정렬하여 그린다.


* Rendering Type tag

해당 오브젝트를 미리 정의된 여러 그룹으로 분리하여 [Shader Replacement](https://docs.unity3d.com/Manual/SL-ShaderReplacement.html) 또는 카메라의 depth texture를 생성하는 데 사용된다.


* DisableBatching tag

해당 오브젝트가 Draw Call Batching에 포함되지 않게 하고싶을 때 사용한다.
 
"True", "False"(default), "LODFading"(LOD Fade가 활성화 된 경우 batching 사용 안 함, 주로 나무에서 사용)을 값으로 사용한다.


* ForceNoShadowCasting tag

해당 오브젝트가 그림자를 사용하고 싶지 않을 때 사용한다.


* IgnoreProjector tag

해당 오브젝트가 Projector의 영향을 받지 않게 하기위해 사용한다. 주로 반투명 오브젝트에 사용한다.


* CanUseSpriteAtlas tag

아틀라스를 생성할 때 shader의 영향을 받지 않게 하기위해 사용한다. 자세한 것은 [Sprite Packer](https://docs.unity3d.com/Manual/SpritePacker.html) 참조.


* PreviewType tag

인스펙터에서 미리보기 부분에 material을 표시하는 방법을 변경할 때 사용한다. 기본적으로 구체로 표현되지만, "Plane" 또는 "Skybox"로 설정할 수 있다.