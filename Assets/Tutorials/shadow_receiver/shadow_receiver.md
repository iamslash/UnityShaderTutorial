# Abstract

그림자를 표면에 나타나게 만들어보자

# Shader

```c
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
Shader "UnityShaderTutorial/shadow_receiver" {
    Properties {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader {
        Pass {
            Tags {"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            // compile shader into multiple variants, with and without shadows
            // (we don't care about any lightmaps yet, so skip these variants)
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
            // shadow helper functions and macros
            #include "AutoLight.cginc"

            struct v2f {
                float2 uv : TEXCOORD0;
                SHADOW_COORDS(1) // put shadows data into TEXCOORD1
                fixed3 diff : COLOR0;
                fixed3 ambient : COLOR1;
                float4 pos : SV_POSITION;
            };
            v2f vert (appdata_base v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0.rgb;
                o.ambient = ShadeSH9(half4(worldNormal,1));
                // compute shadows data
                TRANSFER_SHADOW(o)
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv);
                // compute shadow attenuation (1.0 = fully lit, 0.0 = fully shadowed)
                fixed shadow = SHADOW_ATTENUATION(i);
                // darken light's illumination with shadow, keep ambient intact
                fixed3 lighting = i.diff * shadow + i.ambient;
                col.rgb *= lighting;
                return col;
            }
            ENDCG
        }

        // shadow casting support
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
    }
}
```

# Description

위의 코드는 현재 물체가 광원에 의해 만들어지는 그림자를 표면에 표현하도록 만들어준다.

해당 코드가 정상적으로 동작하기 위해서는 `shadow caster pass`가 필수적으로 포함되어 있어야 한다. 해당 단계에서 생성되는 `shadow map`에 현재 물체가 포함되어야 하기 때문이다. 아래의 코드가 [shadow_caster](/Assets/Tutorials/shadow_caster/shadow_caster.md) 에서 구현한 pass를 실행시켜주는 구문이다.

```
UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
```

코드를 분석해보자. 위의 코드는 shadow caster에서 본 코드에 `AutoLight.cginc` 에 선언되어 있는 매크로 함수를 통해 표면의 색상을 변경시켜주는 일을 한다.

매크로 함수는 `SHADOW_COORDS(1), TRANSFER_SHADOW(o), SHADOW_ATTENUATION(i)` 총 3개가 사용된다.

`SHADOW_COORDS(1)`는 구조체 내부에 선언되며 해당 vertex에 필요한 버퍼의 정보를 가져오기 위해 `shadow map`의 uv좌표를 저장하는 역할을 한다.

`TRANSFER_SHADOW(o)`는 `SHADOW_COORDS(1)`로 선언된 변수에 uv좌표를 저장하는 역할을 한다. 이 함수는 
해당 vertex의 월드 좌표를 이용해서 `shadow map`의 uv좌표를 가져온다. `UNITY_NO_SCREENSPACE_SHADOWS`가 선언되어 있지 않으면 uv좌표는 `ComputeScreenPos()` 함수의 리턴값이 된다.

```c
// #if defined(UNITY_NO_SCREENSPACE_SHADOWS)
#define TRANSFER_SHADOW(a) a._ShadowCoord = mul( unity_WorldToShadow[0], mul( unity_ObjectToWorld, v.vertex ) );
// #else
#define TRANSFER_SHADOW(a) a._ShadowCoord = ComputeScreenPos(a.pos);
```

`SHADOW_ATTENUATION(i)`는 이전 pass에서 만들어놓은 `shadow map`에서 값을 가져와 카메라 시점의 깊이 값과 비교하여 그림자의 값을 결정하는 작업을 한다. 이 함수의 리턴값을 디퓨즈 값과 곱하여 검게 표현할지 원래의 색을 표현할지 결정한다. `soft shadow` 옵션을 사용하지 않으면 리턴값은 0 또는 1이 된다.

```c
#define SHADOW_ATTENUATION(a) unitySampleShadow(a._ShadowCoord)

#if defined(UNITY_NO_SCREENSPACE_SHADOWS)
    UNITY_DECLARE_SHADOWMAP(_ShadowMapTexture);
    #define TRANSFER_SHADOW(a) a._ShadowCoord = mul( unity_WorldToShadow[0], mul( unity_ObjectToWorld, v.vertex ) );
    inline fixed unitySampleShadow (unityShadowCoord4 shadowCoord) {
        #if defined(SHADOWS_NATIVE)
            fixed shadow = UNITY_SAMPLE_SHADOW(_ShadowMapTexture, shadowCoord.xyz);
            shadow = _LightShadowData.r + shadow * (1-_LightShadowData.r);
            return shadow;
        #else
            unityShadowCoord dist = SAMPLE_DEPTH_TEXTURE(_ShadowMapTexture, shadowCoord.xy);
            // tegra is confused if we use _LightShadowData.x directly
            // with "ambiguous overloaded function reference max(mediump float, float)"
            unityShadowCoord lightShadowDataX = _LightShadowData.x;
            unityShadowCoord threshold = shadowCoord.z;
            return max(dist > threshold, lightShadowDataX);
        #endif
    }

#else // UNITY_NO_SCREENSPACE_SHADOWS
    UNITY_DECLARE_SCREENSPACE_SHADOWMAP(_ShadowMapTexture);
    #define TRANSFER_SHADOW(a) a._ShadowCoord = ComputeScreenPos(a.pos);
    inline fixed unitySampleShadow (unityShadowCoord4 shadowCoord) {
        fixed shadow = UNITY_SAMPLE_SCREEN_SHADOW(_ShadowMapTexture, shadowCoord);
        return shadow;
    }

#endif
```

# Prerequisites

* [shadow_caster](/Assets/Tutorials/shadow_caster/shadow_caster.md)