# Abstract

트리플라나 텍스처링에 대해서 알아봅니다.

# Shader

```c

Shader "UnityShaderTutorial/triplanar" {
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tiling ("Tiling", Float) = 1.0
        _OcclusionMap("Occlusion", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                half3 objNormal : TEXCOORD0;
                float3 coords : TEXCOORD1;
                float2 uv : TEXCOORD2;
                float4 pos : SV_POSITION;
            };

            float _Tiling;

            v2f vert (float4 pos : POSITION, float3 normal : NORMAL, float2 uv : TEXCOORD0)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(pos);
                o.coords = pos.xyz * _Tiling;
                o.objNormal = normal;
                o.uv = uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _OcclusionMap;
            
            fixed4 frag (v2f i) : SV_Target
            {
                // 텍스처 가중치로 법선의 절대값을 사용
                half3 blend = abs(i.objNormal);
                // make sure the weights sum up to 1 (divide by sum of x+y+z)
                blend /= dot(blend,1.0);
                // x,y,z 축에 대한 세 가지 텍스처 투영을 읽음
                fixed4 cx = tex2D(_MainTex, i.coords.yz);
                fixed4 cy = tex2D(_MainTex, i.coords.xz);
                fixed4 cz = tex2D(_MainTex, i.coords.xy);
                // 가중치를 기준으로 텍스처를 혼합
                fixed4 c = cx * blend.x + cy * blend.y + cz * blend.z;
                // modulate by regular occlusion map
                c *= tex2D(_OcclusionMap, i.uv);
                return c;
            }
            ENDCG
        }
    }
}

```

# Description

지형이나 동굴 같은 텍스처에는 UV 좌표를 사용하기가 쉽지 않습니다.
UV 좌표는 그리드에서 펼쳐지며 XY 평면에 고르게 배치되는데 지형의 높이차이를 고려하지 않고 늘이기를 유발하기 때문에 텍스처가 뒤틀려 있습니다.
이 때 트리플라나 텍스처링 기술을 사용합니다.

트리플라나 텍스처링은 텍스처를 물체에 매핑할 때 UV 좌표를 사용하지 않고, 물체의 XYZ 평면에 대해 텍스처 좌표를 다시 계산하여 법선의 방향으로 가중 시키는 기술입니다.