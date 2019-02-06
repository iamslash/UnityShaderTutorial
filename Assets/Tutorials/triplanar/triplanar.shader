Shader "UnityShaderTutorial/triplanar" {
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
                half3 objNormal : TEXCOORD0;
                float3 coords : TEXCOORD1;
                float4 pos : SV_POSITION;
            };

            float _Tiling;

            v2f vert (float4 pos : POSITION, float3 normal : NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(pos);
                o.coords = pos.xyz * _Tiling;
                o.objNormal = normal;
                return o;
            }

            sampler2D _Texture;
            
            fixed4 frag (v2f i) : SV_Target
            {
                // use absolute value of normal as texture weights
                half3 blend = abs(i.objNormal);
                // make sure the weights sum up to 1 (divide by sum of x+y+z)
                blend /= dot(blend, 1.0);
                // read the three texture projections, for x,y,z axes
				fixed4 cx = tex2D(_Texture, i.coords.yz);
                fixed4 cy = tex2D(_Texture, i.coords.xz);
                fixed4 cz = tex2D(_Texture, i.coords.xy);
                // blend the textures based on weights
                return cx * blend.x + cy * blend.y + cz * blend.z;
            }
            ENDCG
        }
    }
}