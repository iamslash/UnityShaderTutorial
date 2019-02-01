Shader "UnityShaderTutorial/triplanar_vert_frag2" {
    Properties
    {
        _DiffuseMap ("Texture", 2D) = "white" {}
		_TextureScale("Scale", Float) = 1.0
    }

    SubShader
    {
        Pass
        {
			Tags { "RenderType" = "Opaque" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#pragma enable_d3d11_debug_symbols
            #include "UnityCG.cginc"

            struct v2f
            {
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float4 pos : SV_POSITION;
            };

            float _TextureScale;

            v2f vert (float4 pos : POSITION, float3 normal : NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(pos);
				o.worldPos = mul(unity_ObjectToWorld, pos);
                o.worldNormal = UnityObjectToWorldNormal(normal);
                return o;
            }

            sampler2D _DiffuseMap;
            
            fixed4 frag (v2f i) : SV_Target
            {
				half2 xUV = i.worldPos.zy / _TextureScale;
				half2 yUV = i.worldPos.xz / _TextureScale;
				half2 zUV = i.worldPos.xy / _TextureScale;

				half4 cx = tex2D(_DiffuseMap, xUV);
				half4 cy = tex2D(_DiffuseMap, yUV);
				half4 cz = tex2D(_DiffuseMap, zUV);

				half3 blend = abs(i.worldNormal);
				blend /= dot(blend, 1.0);

				fixed4 c = cx * blend.x + cy * blend.y + cz * blend.z;

                return c;
            }
            ENDCG
        }
    }
}