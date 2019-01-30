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

Basic Lighting Model
```
object's surface color = emissive + ambient + diffuse + specular
```

Diffuse Light

표면에서 모든 방향으로 똑같이 반사되는 방향성 빛

![](http://developer.download.nvidia.com/CgTutorial/elementLinks/fig5_7.jpg)

Diffuse term

![](/Assets/Tutorials/basic_light/diffuse_eq.png)

* K_{d} : material의 diffuse 색상
* LightColor : 들어오는 diffuse light의 색상
* N : 표면의 노멀벡터
* L : 광원을 향한 단위 벡터

[![calculate diffuse](http://developer.download.nvidia.com/CgTutorial/elementLinks/fig5_9.jpg)](http://developer.download.nvidia.com/CgTutorial/cg_tutorial_chapter05.html)

![](/Assets/Tutorials/diffuse/no_minus.png)
* dot(N,L) < 0 은 표면의 뒤에서 빛이 비추고 있는것이고, Diffuse term 값을 음수 값으로 만들기 때문에 max함수를 사용해 제한을 둠

* Lambertian surface : 각에 따른 반사광의 세기가 보는 각도에 관계 없이 일정한 표면
   * 물체 표면의 휘도(빛이 반사되는 반사면의 밝기)가 등방성(물체의 성질이 어느 방향에서나 같은 성질을 나타냄)을 가질때 그 표면이 Lambertian reflectance을 갖는다
* Lambertian reflectance : 표면의 법선 방향과 이루는 θ에 따라 cos⁡θ에 비례하는 광도(광원에서 어느 방향으로의 빛의 세기) 분포를 보여준다
   * 이상적인 diffuse reflecting surface는 Lambertian reflectance을 따른다
   * 어떤 방향에서도 같은 휘도를 가지기 위해서 방향에 따라 필요한 광도를 유도해서 나온 분포
* Lambert's Cosine Law : Lambertian surface의 법선 방향으로 방사된 빛의 광도를 I0, 각 θ방향으로 방사된 빛의 강도(또는 광도)를 Iθ라고 하면 Iθ＝I0 cosθ의 관계가 성립된다는 법칙

![cosine_law](/Assets/Tutorials/diffuse/cosine_law.png)

* 컴퓨터 그래픽스에서는 diffuse reflection에 대한 모델로 Lambertian reflection 사용함


* LightMode 태그 : 라이팅 파이프 라인 안에서 패스의 역할을 정의
* ForwardBase : Forward Rendering 패스를 사용
   * ambient, lighting map, directional light 및 중요하지 않은(정점/SH) 라이트를 한번에 렌더링
* appdata_base 구조체 : 정점은 위치, 법선 및 한 개의 텍스처 좌표로 구성


```
half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz))
```
* worldNormal : world space로 변환된 표면의 노멀벡터
* _WorldSpaceLightPos0 : 라이트 정보
   * Directional Light 이면 _WorldSpaceLightPos0.xyz 는 world space 상에서의 방향
   * 다른 종류의 빛이면 _WorldSpaceLightPos0.xyz 는 world space 상에서의 위치


```
o.diff = nl * _LightColor0
```
* _LightColor0 : 광원의 색

```
col *= i.diff;
```
tex2D함수를 사용해 얻어온 RGB값(material의 diffuse 색상)에 vertex shader에서 구한 K_{d} * max(dot(L,V),0) 값을 곱한다.


