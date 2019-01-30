Shader "UnityShaderTutorial/triplanar 3" {
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_TextureScale("Scale", Float) = 1.0
		_SecondTex("Texture", 2D) = "white" {}
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
				float2 uv : TEXCOORD2;
            };

            float _TextureScale;

            v2f vert (float4 pos : POSITION, float3 normal : NORMAL, float2 uv : TEXCOORD0)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(pos);
				o.worldPos = mul(unity_ObjectToWorld, pos);
                o.worldNormal = UnityObjectToWorldNormal(normal);
				o.uv = uv;
                return o;
            }

            sampler2D _MainTex;
			sampler2D _SecondTex;
            
            fixed4 frag (v2f i) : SV_Target
            {
				half2 xUV = i.worldPos.zy / _TextureScale;
				half2 yUV = i.worldPos.xz / _TextureScale;
				half2 zUV = i.worldPos.xy / _TextureScale;

				half4 cx = tex2D(_MainTex, xUV);
				half4 cy = tex2D(_MainTex, yUV);
				half4 cz = tex2D(_MainTex, zUV);

				half3 blend = abs(i.worldNormal);
				blend /= dot(blend, 1.0);

				fixed4 c = cx * blend.x + cy * blend.y + cz * blend.z;

				//c *= tex2D(_SecondTex, i.uv);

                return c;
            }
            ENDCG
        }
    }
}