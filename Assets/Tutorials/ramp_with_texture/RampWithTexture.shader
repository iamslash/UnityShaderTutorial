Shader "Custom/RampWithTexture" {
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}

	[Header(RAMP SETTING)]
	_Ramp("Ramp (RGB)", 2D) = "gray" {}
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		Pass
		{
			Tags { "LightMode" = "ForwardBase" }

CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase

			#include "UnityCG.cginc"
			#include "Lighting.cginc"	//for UnityGI

			fixed4 _Color;
			sampler2D _MainTex;
			sampler2D _Ramp;

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;			// _LightColor0
				float3 worldNormal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
			};

			float4 _MainTex_ST;

			v2f vert(appdata_base v) {
				v2f o;

				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.worldNormal = UnityObjectToWorldNormal(v.normal);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target{
				fixed3 N = normalize(i.worldNormal);
				fixed3 L = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed4 mainTex = tex2D(_MainTex, i.uv);

				fixed4 c;

				fixed ndl = max(0, dot(N, L));
				fixed3 ramp = tex2D(_Ramp, fixed2(ndl, ndl)).rgb;
				c.rgb = mainTex.rgb * _Color.rgb * _LightColor0.rgb * ramp;
#if UNITY_SHOULD_SAMPLE_SH
				c.rgb += mainTex.rgb * ShadeSHPerPixel(N, 0.0, i.worldPos);
#endif
				c.a = mainTex.a * _Color.a;
				UNITY_OPAQUE_ALPHA(c.a);
				return c;
			}
ENDCG
		}
	}
}
