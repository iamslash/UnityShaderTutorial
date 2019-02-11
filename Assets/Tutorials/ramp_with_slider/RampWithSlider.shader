Shader "Custom/RampWithSlider" {
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}

	[Header(RAMP SETTING)]
		_RampThreshold("Threshold", Range(0,1)) = 0.5
		_RampSmooth("Smoothing", Range(0.001,1)) = 0.1
	}
		SubShader
		{
			Pass
			{
				Tags { "LightMode" = "ForwardBase" }

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"
				#include "AutoLight.cginc"	//for atten
				#include "Lighting.cginc"	//for UnityGlobalIllumination

				fixed4 _Color;
				sampler2D _MainTex;
				half _RampThreshold;
				half _RampSmooth;

				struct v2f {
					float4 pos : SV_POSITION;
					float2 uv : TEXCOORD0;			// _MainTex
					float3 worldNormal : TEXCOORD1;
					float3 worldPos : TEXCOORD2;
				};

				struct lightInput {
					fixed3 Albedo;
					fixed3 Normal;
					fixed Alpha;
				};

				inline half4 LightingCustom(inout lightInput i, UnityGI gi) {
					half3 light_dir = gi.light.dir;

					i.Normal = normalize(i.Normal);
					fixed ndl = max(0, dot(i.Normal, light_dir));

					fixed3 ramp = smoothstep(_RampThreshold - _RampSmooth * 0.5, _RampThreshold + _RampSmooth * 0.5, ndl);

					fixed4 c;
					c.rgb = i.Albedo * _LightColor0.rgb * ramp;
					c.a = i.Alpha;

					return c;
				}

				float4 _MainTex_ST;

				v2f vert(appdata_base v) {
					v2f o;

					o.pos = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

					o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
					o.worldNormal = UnityObjectToWorldNormal(v.normal);

					return o;
				}

				fixed4 frag(v2f i) : SV_Target {
					half2 uv_MainTex;
					uv_MainTex.x = 1.0;
					uv_MainTex = i.uv;

					float3 world_pos = i.worldPos;

					#ifndef USING_DIRECTIONAL_LIGHT
					fixed3 light_dir = normalize(UnityWorldSpaceLightDir(world_pos));
					#else
					fixed3 light_dir = _WorldSpaceLightPos0.xyz;
					#endif

					lightInput o;

					o.Normal = i.worldNormal;

					fixed4 mainTex = tex2D(_MainTex, uv_MainTex);
					o.Albedo = mainTex.rgb * _Color.rgb;
					o.Alpha = mainTex.a * _Color.a;

					fixed4 c = 0;

					// Setup lighting environment
					UnityGI gi;
					UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
					gi.indirect.diffuse = 0;
					gi.indirect.specular = 0;
					gi.light.color = _LightColor0.rgb;
					gi.light.dir = light_dir;

					// realtime lighting: call lighting function
					c += LightingCustom(o, gi);
					UNITY_OPAQUE_ALPHA(c.a);
					return c;
				}

				ENDCG
			}
		}
}
