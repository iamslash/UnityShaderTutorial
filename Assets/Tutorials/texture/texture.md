# Abstract

Vertex, Fragment Shader를 이용하여 물체에 텍스처를 입혀보자.

# Shader

```c
Shader "UnityShaderTutorial/texture"
{
    Properties {
        _Range ("Range", Range(2,50)) = 30
    }

    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float _Range;

            v2f vert (float4 pos : POSITION, float2 uv : TEXCOORD0) {
                v2f o;
                o.vertex = UnityObjectToClipPos(pos);
                o.uv = uv * _Range;
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target {
                float2 c = i.uv;
                c = floor(c) / 2;
                float checker = frac(c.x + c.y) * 2;
                return checker;
            }
            ENDCG
        }
    }
}
```

# Description

UnityObjectToClipPos

```
```

floor

```
HLSL의 내장함수

floor(x) : 내림한 정수를 리턴
```

frac

```
HLSL의 내장함수

frac(x) : x의 소수점 이하 부분을 리턴한다.
```

