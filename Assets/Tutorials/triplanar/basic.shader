Shader "UnityShaderTutorial/basic" {
    Properties
    {
        _Texture ("Texture", 2D) = "white" {}
        _Tiling ("Tiling", Float) = 1.0
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
				float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            float _Tiling;

            v2f vert (float4 pos : POSITION, float2 uv : TEXCOORD0)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(pos);
				o.uv = uv;
                return o;
            }

            sampler2D _Texture;
            
            fixed4 frag (v2f i) : SV_Target
            {
				return tex2D(_Texture, i.uv);
            }
            ENDCG
        }
    }
}