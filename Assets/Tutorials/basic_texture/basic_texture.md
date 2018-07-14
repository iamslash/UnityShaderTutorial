# Abstract

물체에 텍스쳐를 입히자

# Shader

```c
Shader "UnityShaderTutorial/basic_texture" {
    Properties {
        _MainTex ("Base Texture", 2D) = "white" {}
    }
	SubShader{
		Pass{
			SetTexture [_MainTex]
		}
	}
}c
```

# Description

`fixed-style function command` 중 하나인 `SetTexture`  를 이용하여 물체에 Properties 의 `_MainTex` 에 있는 텍스쳐를 입힌다.

# Prerequisites

## What is SetTexture?

`SetTexture` 의 자세한 내용은 [메뉴얼](https://docs.unity3d.com/Manual/SL-SetTexture.html)을 참조하고, 여기선 간략한 키워드만 확인 하자

문법은 아래와 같다

```c
SetTexture [TextureName] {Texture Block}
```

`TextureName` 에는 적용 하고자 하는 텍스쳐의 `Properties`의 이름을 기입해야 한다.

`Texture Block` 에는 `combine` 커맨드가 사용된다.

`combine` 커맨드는 여러가지 텍스쳐 혹은 컬러를 섞는데 사용 된다.

### combine 의 활용

```c
combine src1 * src2 : src1과 src2를 곱한다. 결과값은 더 어두워지는 효과를 얻는다.
combine src1 + src2 : src1에 src2를 더한다. 결과값은 더 밝아지는 효과를 얻는다.
combine src1 - src2 : src1에서 src2를 뺀다.
combine src1 lerp (src2) src3 : src2의 알파값을 이용해서 src1과 src3의 보간한다.
```
`src` 에는 `previous` `constant` `texture` 중에 하나가 될 수 있다.
`previous` : 이전 `SetTexture` 의 결과값
`constant` : `constantColor` 로 선언한 컬러 값
`texdture` : 현재 `SetTexture` 에 선언된 `TextureName` 에 해당

## How To Working In Vert, Frag Shader

위 `fixed-style` 의 Shader의 컴파일된 코드 중에서 핵심내용에 해당 하는것들을 살펴보자.

```c
// vertex shader input data
struct appdata {
  float3 pos : POSITION;
  float3 uv0 : TEXCOORD0;
};

// vertex-to-fragment interpolators
struct v2f {
  fixed4 color : COLOR0;
  float2 uv0 : TEXCOORD0;
  float4 pos : SV_POSITION;
};

v2f vert (appdata IN) {
  v2f o;  
  ... 생략
  // 텍스쳐의 좌표 계산
  o.uv0 = IN.uv0.xy * _MainTex_ST.xy + _MainTex_ST.zw;  
  ... 생략
  return o;
}

fixed4 frag (v2f IN) : SV_Target {
	... 생략 
  // SetTexture #0
  tex = tex2D (_MainTex, IN.uv0.xy);
  col.rgb = tex;
  col.a = tex.a;  
  return col;
}

```
`float3 uv0 : TEXCOORD0;` : 텍스쳐는 UV 좌표로 이루어져 있다.
`o.uv0 = IN.uv0.xy * _MainTex_ST.xy + _MainTex_ST.zw;` : 
* `_MainTex_ST` : `_MainTex` 의 추가 정보에 해당한다. 
* `_MainTex_ST.xy` : tiling vector, 텍스쳐의 scale에 활용 된다. (1,1)이 기본값.
* `_MainTex_ST.zw` : offset vector, 텍스쳐의 오프셋에 활용 된다, (0,0)이 기본값.

`tex = tex2D (_MainTex, IN.uv0.xy);` 
* `tex2D` : 텍스쳐와 UV값을 이용해서 색상값을 반환하는 함수

더욱 자세한 내용을 알고 싶다면 [참고](https://catlikecoding.com/unity/tutorials/rendering/part-2/)