# Abstract

diffuse lighting을 적용해보자.

# Shader

```c
Shader "UnityShaderTutorial/diffuse" {
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
            Tags {"LightMode"="ForwardBase"}
        
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc" // for UnityObjectToWorldNormal
            #include "UnityLightingCommon.cginc" // for _LightColor0

            struct v2f
            {
                float2 uv : TEXCOORD0;
                fixed4 diff : COLOR0; // diffuse lighting color
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;

                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
               
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                
                o.diff = nl * _LightColor0;
                return o;
            }
            
            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                // sample texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // multiply by lighting
                col *= i.diff;
                return col;
            }
            ENDCG
        }
    }
}
```

# Description


Diffuse Light

표면에서 모든 방향으로 똑같이 반사되는 방향성 빛

![](http://developer.download.nvidia.com/CgTutorial/elementLinks/fig5_7.jpg)

Diffuse term

![](/Assets/Tutorials/basic_light/diffuse_eq.png)

* K_{d} : material의 diffuse 색상
* LightColor : 들어오는 diffuse light의 색상
* N : 표면의 노멀벡터
* L : 광원을 향한 노멀 벡터

[![calculate diffuse](http://developer.download.nvidia.com/CgTutorial/elementLinks/fig5_9.jpg)](http://developer.download.nvidia.com/CgTutorial/cg_tutorial_chapter05.html)

* LightMode 태그 : 라이팅 파이프 라인 안에서 패스의 역할을 정의
* ForwardBase : Forward Rendering 패스를 사용
    * ambient, lighting map, directional light 및 중요하지 않은(정점/SH) 라이트를 한번에 렌더링
* appdata_base 구조체 : 정점은 위치, 법선 및 한 개의 텍스처 좌표로 구성


```
half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz))
```
* worldNormal : world space로 변환된 표면의 노멀벡터
* _WorldSpaceLight0 : 라이트 정보
    * Directional Light 이면 _WorldSpaceLightPos0.xyz 는 world space 상에서의 방향
    * 다른 종류의 빛이면 _WorldSpaceLightPos0.xyz 는 world space 상에서의 위치


```
o.diff = nl * _LightColor0
```
* _LightColor0 : 광원의 색

```
col *= i.diff;
```
tex2D함수를 사용해 얻어온 RGB값(material의 diffuse 색상)에 vertax shader에서 구한 K_{d} * max(dot(L,V),0) 값을 곱한다.