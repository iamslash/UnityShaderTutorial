# Abstract

물체에 노멀맵을 적용해보자.

# Shader

```c
Shader "UnityShaderTutorial/normal_map" {
    // no Properties block this time!
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f {
                half3 worldNormal : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            v2f vert (float4 vertex : POSITION, float3 normal : NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.worldNormal = UnityObjectToWorldNormal(normal);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 c = 0;
                c.rgb = i.worldNormal*0.5+0.5;
                return c;
            }
            ENDCG
        }
    }
}
```

# Description

노멀매핑은 물체의 법선 벡터 값을 사용하여 물체에 입체감과 질감을 구현하는 방법이다. 노멀맵은 각 픽셀의 컬러값을 노멀 벡터의 값으로 표현해놓은 텍스쳐이며 모든 종류의 그래픽스 이펙트(조명, 반사, 실루엣 등)에 사용된다.

위 셰이더에서는 Unity의 내장 셰이더 첨부 파일을 사용하였다.

```
#include "UnityCG.cginc"
```

여기서 제공하는 함수들 중 UnityObjectToClipPos와 UnityObjectToWorldNormal을 사용하였다. UnityObjectToClipPos는 오브젝트 공간의 한 점을 동일 좌표에 있는 카메라의 클립 공간으로 변환하는 함수이며, UnityObjectToWorldNormal은 오브젝트의 노멀 벡터를 월드 좌표의 벡터로 변환하는 함수이다.

프래그먼트 셰이더에서는 버텍스 셰이더에서 계산된 월드 좌표의 노멀 벡터를 사용하여 해당 픽셀의 컬러값을 정한다.(노멀 벡터의 시각화)

노멀 벡터는 각각의 x,y,z값이 -1 ~ 1의 값을 가지기 때문에 0 ~ 1의 값을 가지는 컬러값으로 변환하는 작업을 한다.

# Prerequisites

## Why Use Normap?

물체를 사실적으로 표현하기 위해서는 물체를 이루고 있는 꼭지점의 개수가 많아야 한다. 그리고 꼭지점의 개수는 파일 크기와 메모리 점유율, 해당 물체를 화면에 그리기 위한 필요 연산량과 비례한다. 

이러한 한계를 개선하기 위해 꼭지점 수가 많은 물체의 법선 벡터를 텍스쳐에 저장하여 실제 물체의 꼭지점 수가 줄어도 티가 나지 않게 처리하는 기술을 사용하게 되었다. 이 기술을 노멀 매핑(Normal Mapping)이라 하고, 이 때 법선 벡터가 저장되는 텍스쳐를 노멀맵(Normal Map) 텍스쳐라고 한다.

노멀맵 텍스쳐를 사용하면 텍스쳐 1장으로 저해상도의 모델 데이터를 고해상도의 모델과 흡사하게 표현해준다. 파일의 용량, 메모리의 사용량, 연산량 전부 획기적으로 줄어든다.

단점은, 고해상도의 모델에서 노말맵을 생성한 뒤 저해상도의 모델을 또 만들어야 하기 때문에 전체적으로 모델을 만드는 시간이 오래 걸린다.

 