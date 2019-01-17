# Abstract

물체의 표면에 스카이맵이 반사된 모습을 표현합니다.

# Shader

```c
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "UnityShaderTutorial/skymap_reflect" {
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f {
                half3 worldRefl : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            v2f vert (float4 vertex : POSITION, float3 normal : NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                // compute world space position of the vertex
                float3 worldPos = mul(unity_ObjectToWorld, vertex).xyz;
                // compute world space view direction
                float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
                // world space normal
                float3 worldNormal = UnityObjectToWorldNormal(normal);
                // world space reflection vector
                o.worldRefl = reflect(-worldViewDir, worldNormal);
                return o;
            }
        
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the default reflection cubemap, using the reflection vector
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, i.worldRefl);
                // decode cubemap data into actual color
                half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
                // output it!
                fixed4 c = 0;
                c.rgb = skyColor;
                return c;
            }
            ENDCG
        }
    }
}
```

# Description

물체의 표면에 반사를 표현하기 위해서는 물체 주변의 모든 방향에 대해서 반사되는 부분을 구해야 합니다.<br>

반사 벡터를 구하기 위해 월드 좌표상의 위치와 노말 벡터를 구하고, 카메라 위치에서 오브젝트를 향하는 벡터와 노말 벡터를 이용하여 반사 벡터를 구합니다.

```
// 월드 좌표상의 위치
float3 worldPos = mul(unity_ObjectToWorld, vertex).xyz;
// 카메라 위치에서 오브젝트를 향하는 방향 벡터
float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
// 월드 좌표상의 노말 벡터
float3 worldNormal = UnityObjectToWorldNormal(normal);
// 반사 벡터
o.worldRefl = reflect(-worldViewDir, worldNormal);
```

유니티에서는 씬에서 반사 소스로 스카이박스(스카이맵)가 사용될 때 이 스카이박스 데이터를 담고 있는 디폴트 반사 텍스쳐(반사 프로브)가 반드시 생성됩니다. 또한 이를 사전 정의 해놓았습니다.

```
unity_SpecCube0 : 사용중인 반사 프로브의 데이터를 포함하고 있는 큐브맵
```

`UNITY_SAMPLE_TEXCUBE` 라는 빌트인 매크로를 사용하여 
텍셀을 얻어오고, 큐브맵에는 HDR 색상이 포함되어 있기 때문에 HDR 형식에서 RGB 형식으로 변환하여 사용해야합니다.

## Reflect

```
reflect(i, n) : 입사 광선과 표면 법선을 사용하여 반사 벡터를 반환

i : 입사광의 방향 벡터
n : 반사면의 표면 법선
```

reflect() 함수는 HLSL 함수로위의 함수로 반사 벡터를 구한 뒤 해당 벡터를 스카이맵의 텍셀을 얻어오는 좌표로 사용합니다.

반사벡터를 구하는 과정을 그림으로 설명해보겠습니다.

![](./Images/proc1.PNG)

빛이 물체에 도달했을 때, 즉 입사광을 벡터 V라 하고 물체의 법선벡터를 n이라고 합니다.

![](./Images/proc2.PNG)

반사 벡터를 구하기 위해 첫 과정으로 V 벡터의 방향을 바꿔줍니다.

![](./Images/proc3.PNG)

-V와 물체의 법선벡터인 n을 내적합니다. 내적의 결과로 스칼라값이 나옵니다.

![](./Images/proc4.PNG)

내적의 결과값에 법선벡터 n을 2배하여 곱해줍니다. 
이 때 n에 2를 곱하는 이유는 곱하지 않을경우 지면과 평행한 벡터가 나오기 때문입니다.

![](./Images/proc5.PNG)

위 그림의 결과값에 최초 입사광 벡터인 V를 더하여 반사벡터를 구합니다.

![](./Images/proc6.PNG)

벡터의 성질에 의해 크기와 방향이 같으니 어디에 있던지 결국엔 똑같은 벡터입니다.

![](./Images/img1.PNG)

V : 입사광의 벡터, R : 반사 벡터, n : 법선 벡터

# Prerequisites

## 투영 벡터

반사 벡터를 구하기 위해서는 먼저 벡터의 투영에 대해서 알아야 합니다.

### 투영

어떤 벡터 V 를 단위 벡터 n에 내적하여 V의 n 방향으로의 길이를 구하는것을 뜻합니다.

![](./Images/img2.PNG)

내적값은 스칼라이므로 투영된 방향으로의 벡터를 구하려면 내적값에 방향벡터 n 을 곱해주면 됩니다.

![](./Images/img3.PNG)

이 투영 벡터를 이용하여 반사벡터를 구하는데 쓰입니다.