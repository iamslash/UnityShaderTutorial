# Abstract

그림자를 만들어보자

# Shader

```c
Shader "UnityShaderTutorial/shadow_caster" {
	Properties {
		_MainTex("Texture", 2D) = "white" {}
	}
    SubShader {
        Pass {
            Tags {"LightMode"="ForwardBase"}
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
            v2f vert (appdata_base v) {
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
            fixed4 frag (v2f i) : SV_Target {
				fixed4 col = tex2D(_MainTex, i.uv);
				col *= i.diff;
                return col;
            }
            ENDCG
        }

        // shadow caster rendering pass, implemented manually
        // using macros from UnityCG.cginc
        Pass
        {
            Tags {"LightMode"="ShadowCaster"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster
            #include "UnityCG.cginc"

            struct v2f { 
                V2F_SHADOW_CASTER;
            };

            v2f vert(appdata_base v)
            {
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
```

# Description

위의 코드는 물체에 가려지는 부분을 다른 물체의 표면에 표현하도록 만들어준다.

![](shadowcasting.png)

```c
#define TRANSFER_SHADOW_CASTER_NORMALOFFSET(o) TRANSFER_SHADOW_CASTER_NOPOS(o,o.pos)

#if defined(SHADOWS_CUBE) && !defined(SHADOWS_CUBE_IN_DEPTH_TEX)
    // Rendering into point light (cubemap) shadows
    #define TRANSFER_SHADOW_CASTER_NOPOS(o,opos) o.vec = mul(unity_ObjectToWorld, v.vertex).xyz - _LightPositionRange.xyz; opos = UnityObjectToClipPos(v.vertex);
    #define SHADOW_CASTER_FRAGMENT(i) return UnityEncodeCubeShadowDepth ((length(i.vec) + unity_LightShadowBias.x) * _LightPositionRange.w);

#else
    // Rendering into directional or spot light shadows
    #define V2F_SHADOW_CASTER_NOPOS
    // Let embedding code know that V2F_SHADOW_CASTER_NOPOS is empty; so that it can workaround
    // empty structs that could possibly be produced.
    #define V2F_SHADOW_CASTER_NOPOS_IS_EMPTY
    #define TRANSFER_SHADOW_CASTER_NOPOS(o,opos) \
        opos = UnityClipSpaceShadowCasterPos(v.vertex, v.normal); \
        opos = UnityApplyLinearShadowBias(opos);
    #define SHADOW_CASTER_FRAGMENT(i) return 0;
#endif
```

```c
float4 UnityClipSpaceShadowCasterPos(float4 vertex, float3 normal) {
    float4 wPos = mul(unity_ObjectToWorld, vertex);

    if (unity_LightShadowBias.z != 0.0) {
        float3 wNormal = UnityObjectToWorldNormal(normal);
        float3 wLight = normalize(UnityWorldSpaceLightDir(wPos.xyz));

        // apply normal offset bias (inset position along the normal)
        // bias needs to be scaled by sine between normal and light direction
        // (http://the-witness.net/news/2013/09/shadow-mapping-summary-part-1/)
        //
        // unity_LightShadowBias.z contains user-specified normal offset amount
        // scaled by world space texel size.

        float shadowCos = dot(wNormal, wLight);
        float shadowSine = sqrt(1-shadowCos*shadowCos);
        float normalBias = unity_LightShadowBias.z * shadowSine;

        wPos.xyz -= wNormal * normalBias;
    }

    return mul(UNITY_MATRIX_VP, wPos);
}
```

# Prerequisites

*