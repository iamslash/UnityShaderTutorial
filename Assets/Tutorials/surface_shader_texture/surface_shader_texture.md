# Abstract

서피스 쉐이더를 이용하여 텍스처를 적용해 보자.

# Shader

```c
Shader "UnityShaderTutorial/surface_shader_texture" {
	Properties {
      _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader {
      Tags { "RenderType" = "Opaque" }

      CGPROGRAM
      #pragma surface surf Lambert

      struct Input {
          float2 uv_MainTex;
      };

      sampler2D _MainTex;

      void surf (Input IN, inout SurfaceOutput o) {
          o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
      }
      ENDCG
    } 
    Fallback "Diffuse"
}
```

# Description

surface로 사용 할 함수(surf)와 조명 모델(Lambert)을 선언한다.

surf 함수에서는 프로퍼티로 넘겨받은 텍스처와 오브젝트의 UV 값을 이용하여 Albedo의 색상을 채운다.

![](./Images/1.png)

# Prerequisites

## surface 선언 방법

`#pragma surface surfaceFunction lightModel [optionalparams]`

### surfaceFunction

```
surface로 사용 할 함수의 이름.

ex) void surf(Input IN, inout SurfaceOutput o){};
```

### lightModel

```
사용할 조명 모델.

* 종류

물리 기반의 Standard 및 StandardSpecular.
물리 기반이 아닌 단순한 Lambert (Diffuse) 및 BlinnPhong (Specular).
```

```
Lambert

가장 기본적인 diffuse 라이팅 모델.

모든 방향에서 같은 복사량(흡수, 투과, 반사)을 취하게 된다는 가정을 깔고 있으며, 
플라스틱이나 모래와 같이 반들반들한 표면을 가진 재질에 적합.

[Lighting.cginc]

inline fixed4 UnityLambertLight (SurfaceOutput s, UnityLight light) {
    fixed diff = max (0, dot (s.Normal, light.dir));

    fixed4 c;
    c.rgb = s.Albedo * light.color * diff;
    c.a = s.Alpha;
    return c;
}

inline fixed4 LightingLambert (SurfaceOutput s, UnityGI gi) {
    fixed4 c;
    c = UnityLambertLight (s, gi.light);

    #ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
        c.rgb += s.Albedo * gi.indirect.diffuse;
    #endif

    return c;
}
```

```
BlinnPhong

[Lighting.cginc]

inline fixed4 UnityBlinnPhongLight (SurfaceOutput s, half3 viewDir, UnityLight light) {
    half3 h = normalize (light.dir + viewDir);

    fixed diff = max (0, dot (s.Normal, light.dir));

    float nh = max (0, dot (s.Normal, h));
    float spec = pow (nh, s.Specular*128.0) * s.Gloss;

    fixed4 c;
    c.rgb = s.Albedo * light.color * diff + light.color * _SpecColor.rgb * spec;
    c.a = s.Alpha;

    return c;
}

inline fixed4 LightingBlinnPhong (SurfaceOutput s, half3 viewDir, UnityGI gi) {
    fixed4 c;
    c = UnityBlinnPhongLight (s, viewDir, gi.light);

    #ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
        c.rgb += s.Albedo * gi.indirect.diffuse;
    #endif

    return c;
}
```

### optionalparams

alpha:blend - 알파 블렌딩을 사용한다.

alpha:fade - 페이드를 사용한다.

더 많은 정보는 [여기](https://docs.unity3d.com/Manual/SL-SurfaceShaders.html)서 확인하도록 한다.

