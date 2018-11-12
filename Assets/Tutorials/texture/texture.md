# Abstract

Vertex, Fragment Shader를 이용하여 물체에 텍스처를 입혀보자.

# Shader

```c
Shader "Unlit/texture"
{
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            //float4 _MainTex_ST;
            
            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target {
                // sample the texture
                return tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
}
```

# Description

`_MainTex` 프로퍼티를 이용하여 텍스처를 설정 할 수 있다. 텍스처를 설정하지 않을 경우 흰색으로 처리한다.

텍스처의 Tilling과 Offset을 사용하기 위해서는 UnityCG.cginc에서 제공하는 `TRANSFORM_TEX` 메크로를 이용하여 텍스처 스케일 및 오프셋이 올바로 적용되고 있는지 확인 처리를 해야 한다.

`TRANSFORM_TEX`를 사용하기 위해서는 float4 타입이면서, "_Texutre 이름 + _ST"의 이름을 갖는 변수를 선언해줘야 한다.