# Abstract

서피스 쉐이더를 이용하여 게임 오브젝트의 가장자리를 강조해보자

# Shader

```c
Shader "UnityShaderTutorial/surface_shader_rim_lighting" {
      Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _BumpMap ("Bumpmap", 2D) = "bump" {}
        _RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
        _RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
      }
      SubShader {
        Tags { "RenderType" = "Opaque" }
        CGPROGRAM
        #pragma surface surf Lambert
        struct Input {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 viewDir;
        };
        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _RimColor;
        float _RimPower;
        void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
            o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
            half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
            o.Emission = _RimColor.rgb * pow (rim, _RimPower);
        }
        ENDCG
      } 
      Fallback "Diffuse"
}
```

# Description

이 쉐이더는 물체의 가장자리를 `_RimColor` 색상으로 `_RimPower`만큼 밝게 만들어준다.

코드는 0 ~ 1의 값을 갖는 rim 변수를 계산하여 emission light에 `_RimColor`의 강도를 조절한다.

Input.viewDir 는 빌트인 표면 쉐이더 변수로 카메라가 보는 방향 벡터이다. 

rim 값은 1에서 normalize한 view vector와 표면의 normal vector를 dot product하여 나온 cosine 값을 빼주는 것으로 얻을 수 있다. 두 벡터가 수직에 가까울 수록 값이 커지기 때문에 가장자리의 값이 크다는 것을 알 수 있다.

마지막으로 `_RimColor` 색을 가지는 emission light를 만드는데, rim에 `_RimPower`를 지수로 곱한다. `_RimPower`의 값이 크면 클수록 light는 약해진다.