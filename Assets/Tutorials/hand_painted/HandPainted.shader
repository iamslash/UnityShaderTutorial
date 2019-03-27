Shader "Custom/HandPainted" {
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}

	[Header(RAMP SETTING)]
		_RampThreshold("Threshold", Range(0,1)) = 0.5
		_RampSmooth("Smoothing", Range(0.001,1)) = 0.1
		_ThresholdTex("Threshold Texture (Alpha)",2D) = "gray"{}
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
			sampler2D _ThresholdTex;
			half _RampThreshold;
			half _RampSmooth;

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;			// _MainTex
				float2 uv2 : TEXCOORD1;			// _ThresholdTex
				float3 worldNormal : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
			};

			float4 _MainTex_ST;
			float4 _ThresholdTex_ST;

			v2f vert(appdata_base v) {
				v2f o;

				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv2 = TRANSFORM_TEX(v.texcoord, _ThresholdTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.worldNormal = UnityObjectToWorldNormal(v.normal);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target {
				float3 N = normalize(i.worldNormal);
				float3 L = normalize(UnityWorldSpaceLightDir(i.worldPos));
				float4 mainTex = tex2D(_MainTex, i.uv);
			
				fixed TexThreshold = tex2D(_ThresholdTex, i.uv2).a - 0.5;
				float4 c;

				fixed ndl = max(0, dot(N, L));
				ndl += TexThreshold;
				fixed3 ramp = smoothstep(_RampThreshold - _RampSmooth * 0.5, _RampThreshold + _RampSmooth * 0.5, ndl);

				c.rgb = mainTex.rgb * _Color.rgb * _LightColor0.rgb * ramp;
#if UNIY_SHOULD_SAMPLE_SH
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
