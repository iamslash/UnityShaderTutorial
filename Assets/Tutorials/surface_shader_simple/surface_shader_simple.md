# Abstract

서피스 셰이더에 대해 알아봅니다.

# Shader

```c
Shader "UnityShaderTutorial/surface_shader_simple" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
```

# Description

서피스 셰이더는 `vertex` 나 `fragment` 쉐이더를 사용하는 것 보다 더 쉽게 작성할 수 있게 해주는 쉐이더입니다.

즉, 위의 두 쉐이더를 정해진 데이터 구조에 값을 채워넣기만 하면 컴파일러가 코드를 알아서 생성합니다.

아래의 그림은 서피스 쉐이더가 어떻게 동작하는지 간략하게 보여주고 있습니다.

![](./Images/img1.PNG)

# 구조

![](./Images/img2.PNG)

유니티에서 서피스 쉐이더를 만들면 기본적으로 들어있는 코드들입니다.
다른 쉐이더와 마찬가지로 CGPROGRAM ... ENDCG 내에 위치합니다.

3부분으로 나누어서 살펴보겠습니다.

## 1. 설정 부분

서피스 쉐이더의 전처리 부분으로 쉐이더의 조명 계산 모델이나 기타 세부적인 분기를 정해주는 부분입니다.

`#pragma surface ...` 로 이 쉐이더가 서피스 쉐이더임을 알립니다.
또한 기존 쉐이더와는 다르게 `Pass`가 아닌 `SubShader` 내에 위치합니다.

다른 `Pass`를 가진 서피스 쉐이더를 여러개 사용하고 싶다면
`CGPROGRAM ~ ENDCG` 를 한번 더 선언하여 내부에 서피스 쉐이더 코드를 다시 작성하면 됩니다.

[예제 쉐이더](https://github.com/iamslash/UnityShaderTutorial/blob/master/Assets/Tutorials/surface_shader_simple/MultiPassSurfaceShader.shader)

### 서피스 쉐이더 컴파일 지시문

```
#pragma surface surfaceFunction lightModel [optionalparams]
ex) #pragma surface surf Lambert
```

#### SurfaceFunction

서피스 쉐이더 코드가 있는 함수이름 입니다. 해당 함수는 `void surf(Input IN, inout SurfaceOutput o)`의 형식이여야 합니다.

#### LightModel

유니티에서 지원하는 조명 모델로는
* Standard
* StandardSpecular
* Lambert or BlinnPhong

이렇게 4가지가 있습니다. `Standard, StandardSpecular`는 물리기반 조명 모델입니다.

위의 예제 구문을 해석하자면 "해당 쉐이더를 위한 서피스 함수 이름은 `surf` 이고, 조명 모델로 `Lambert` 조명 모델을 사용할 것 이다." 입니다.

#### OptionalParams

A. 투명도와 알파 테스트 : 알파(alpha) 및 알파테스트(alphatest) 지시어로 제어됨, 반투명을 사용하면 생성 된 표면 쉐이더 코드에 블렌딩 명령이 포함됨. 알파 컷 아웃을 사용하면 주어진 변수를 기반으로 생성 된 픽셀 쉐이더에서 조각을 삭제한다.

* alpha or alpha:auto - 간단한 조명 기능에 대해서는 페이드 투명(alpha:fade)을 선택하고 물리적 기반 라이팅 기능에 대해서는 미리 곱셈 된 투명 (alpha:premul)을 선택.
* alpha:blend - 알파 블렌드 허용
* alpha:fade - 기존의 알파 투명도 허용
* alpha:premul - 미리 곱해진 알파 투명도 허용
* alphatest:VariableName - 알파 컷 아웃 투명을 사용. 컷오프 값은 VariableName이있는 float 변수로 사용.
```
_Cutoff("Alpha blend", Range(0,1)) = 0.5
#pragma ... alphatest:_Cutoff,
```
* keepalpha - 기본적으로 불투명 서피스 쉐이더는 출력 구조체의 알파 또는 조명 함수에 의해 반환되는 것에 상관없이 1.0 (흰색)을 알파 채널에 사용한다. 이 옵션을 사용하면 불투명 한 표면 쉐이더에서도 조명 함수의 알파 값을 유지할 수 있다.
* decal:add - 추가 데칼 쉐이더 (예 : 지형 AddPass). additive blending을 사용
* decal:blend - 반투명 데칼 쉐이더. 이것은 메쉬 표면에 놓여있고 알파 블렌딩을 사용하는 개체를 의미

B. 사용자 정의 수정 함수 : 입력된 정점 데이터를 변경, 계산하거나 최종 계산 된 정점의 색상을 변경하는 데 사용

* vertex:VertexFunction - 생성된 버텍스가 시작될때 호출되며 버텍스별 데이터를 수정하거나 계산하는데 쓰임
* finalcolor:ColorFunction - 사용자에 의해 정의된 최종 정점 색상 수정
* finalgbuffer:ColorFunction - gbuffer 내용을 변경하기위한 사용자 정의 지연 경로.
* finalprepass:ColorFunction - 사용자 정의 기본패스

C. 그림자와 테셀레이션 관련 항목

* addshadow - 그림자 캐스터 패스를 생성.
* fullforwardshadows - 포워드 렌더링 패스에서 모든 광원 유형을 지원. 기본적으로 쉐이더는 (Quality setting의 count 수에 저장된 숫자만큼) 포워드 렌디링에서 하나의 디렉셔널 라이트의 그림자만 지원. 포인트 혹은 스팟 라이트 사용시에 사용
* tessellate:TessFunction - DX11 기반의 테셀레이션을 사용할때 사용.

D. 코드 생성 옵션 : 기본적으로 생성된 surface shader 코드는 가능한 모든 조명/셰도우/라이트맵 환경에서 처리하기 위해 variants를 생성하게 됨. 그중 일부를 제한하기 위한 용도를 위해 사용하는 컴파일러 명령어.

* exclude_path:deferred, exclude_path:forward, exclude_path:prepass - 주어진 렌더링 경로(디퍼드, 포워드, 레거시 디퍼드등)로는 패스를 생성하지 않음.
* noshadow - 이셰이더에서 그림자를 받지 않음
* noambient - 어떤 ambient light도, light probes도 적용받지 않음
* novertexlights - 포워드 렌더링에서 어떤 light probes도, vertex-lit도 적용받지 않음
* nolightmap - 라이트맵핑을 적용하지 않음
* nodynlightmap - 런타임에서 동적 GI를 적용하지 않음
* nodirlightmap - directional lightmap을 적용하지 않음
* nofog - 내장 fog(안개)를 적용하지 않음
* nometa -  "메타"패스를 생성하지 않음. (라이트맵핑 및 동적 GI를 사용해 표면정보를 추출)
* noforwardadd - 포워드 렌더링 추가패스를 사용하지 않음. 이것에 의해 셰이더는 1개의 디렉셔널 라이트를 지원. 다른 모든 라이트는 버텍스/SH(Spherical Harmonics - 구면조화함수) 마다 계산됨. 이는 셰이더를 더 작게 만든다.
* nolppv - Light Probe proxy volume을 사용하지 않음
* noshadowmask - Shadow mask를 사용하지 않음

기타 자세한 내용은 유니티의 [서피스 쉐이더 매뉴얼](https://docs.unity3d.com/kr/current/Manual/SL-SurfaceShaders.html)을 참조합니다.

## 2. 입력 부분

모델의 데이터를 가져오는 부분입니다. 필요한 데이터들을 `Input` 구조체 안에 선언하면 서피스 함수 내에서 사용이 가능합니다.

`Input` 에는 일반적으로 쉐이더가 필요로하는 텍스처 uv 좌표가 있습니다. 텍스처 좌표의 변수 이름은 이름 앞에 `uv`가 붙는 형식으로 작성해야 합니다.

```
sampler2D _Texture;
struct Input {
	float2 uv_Texture;
}
```

그 밖에도 모델의 월드좌표, 월드법선 등 변수를 추가하기만 하면 유니티가 계산한 값들로 채울 수 있습니다. 지원하는 변수 목록은 유니티의 [서피스 쉐이더 매뉴얼](https://docs.unity3d.com/kr/current/Manual/SL-SurfaceShaders.html)을 참조합니다.

## 3. 함수 부분

실직적으로 코드를 작성하여 모델의 최종 모습을 결정합니다. 그러기 위해선 `SurfaceOutput` 이라는 서피스 쉐이더의 출력구조에 값을 채워줘야 합니다.

### 서피스 쉐이더 표준 출력 구조

```
struct SurfaceOutput
{
    fixed3 Albedo;  // diffuse color
    fixed3 Normal;  // tangent space normal, if written
    fixed3 Emission;
    half Specular;  // specular power in 0..1 range
    fixed Gloss;    // specular intensity
    fixed Alpha;    // alpha for transparencies
};
```

위의 출력 구조는 물리 기반 조명 모델이 아닐경우에 사용하는 출력 구조입니다.
조명 모델을 `Standard, StandardSpecular` 로 사용할 경우 다른 출력 구조를 사용해서 값을 채워줘야 합니다. 해당 출력 구조는 유니티의 [서피스 쉐이더 매뉴얼](https://docs.unity3d.com/kr/current/Manual/SL-SurfaceShaders.html)을 참조합니다.

출력 구조는 따로 재정의가 가능합니다.

[예제 쉐이더](https://github.com/iamslash/UnityShaderTutorial/blob/master/Assets/Tutorials/surface_shader_simple/MultiPassSurfaceShader.shader)