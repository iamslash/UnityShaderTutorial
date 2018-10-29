Shader "UnityShaderTutorial/texture"
{
    Properties {
        _Range ("Range", Range(2,50)) = 30
    }

    SubShader {
        Pass
        {
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