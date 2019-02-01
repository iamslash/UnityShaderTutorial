Shader "UnityShaderTutorial/shadow_caster" {
	Properties{
		_MainTex("Texture", 2D) = "white" {}
	}
		SubShader{
			Pass {
				Tags {"LightMode" = "ForwardBase"}
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
				#include "UnityLightingCommon.cginc"
				struct v2f {
					float2 uv : TEXCOORD0;
					fixed4 diff : COLOR0;
					float4 vertex : SV_POSITION;
				};
				v2f vert(appdata_base v) {
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.texcoord;
					half3 worldNormal = UnityObjectToWorldNormal(v.normal);
					half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
					o.diff = nl * _LightColor0;
					// only evaluate ambient
					o.diff.rgb += ShadeSH9(half4(worldNormal, 1));

					return o;
				}

				sampler2D _MainTex;
				fixed4 frag(v2f i) : SV_Target {
					fixed4 col = tex2D(_MainTex, i.uv);
					col *= i.diff;
					return col;
				}
				ENDCG
			}

		// shadow caster rendering pass, implemented manually
		// using macros from UnityCG.cginc
		Pass {
			Tags {"LightMode" = "ShadowCaster"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"

			struct v2f {
				V2F_SHADOW_CASTER;
			};

			v2f vert(appdata_base v) {
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}
	}
}