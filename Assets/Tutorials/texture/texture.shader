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
            float4 _MainTex_ST;	// _Texutre 이름 + _ST를 변수로 가지고 있어야 "TRANSFORM_TEX"를 사용 할 수 있다.
            
            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);	// 매크로를 사용하여 텍스처 스케일 및 오프셋이 올바로 적용되고 있는지 확인.
                //o.uv = v.uv;
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