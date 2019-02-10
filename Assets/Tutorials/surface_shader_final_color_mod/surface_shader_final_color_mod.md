# Abstract

서피스 쉐이더를 이용하여 마지막으로 출력되는 컬러값을 변경해보자

# Shader

```c
Shader "UnityShaderTutorial/surface_shader_final_color_mod" {
	Properties{
		_MainTex("Texture", 2D) = "white" {}
		_ColorTint("Tint", Color) = (1.0, 0.6, 0.6, 1.0)
	}

	SubShader{
		Tags{ "RenderType" = "Opaque" }
		CGPROGRAM
#pragma surface surf Lambert finalcolor:mycolor
		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _ColorTint;
		void mycolor(Input IN, SurfaceOutput o, inout fixed4 color) {
			color *= _ColorTint;
		}

		sampler2D _MainTex;
		void surf(Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
		Fallback "Diffuse"
}
```

# Description

이 쉐이더는 최종적으로 화면에 출력될 때 물체의 색상을 수정하는 최종 컬러 모디파이어(final color modifier) 기능을 사용한다.

surface shader 의 옵션으로 `finalcolor:ColorFunction`를 사용한다. 해당 옵션은 `ColorFunction`로 지정된 함수를 fragment shader 맨 마지막 단계에 추가한다.

```
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  // realtime lighting: call lighting function
  c += LightingLambert (o, gi);
  mycolor (surfIN, o, c);
  UNITY_OPAQUE_ALPHA(c.a);
  return c;
}
```

추가적으로, `finalcolor` 옵션을 사용하면 fragment shader의 마지막 단계에서 수행하는 `UNITY_APPLY_FOG(IN.fogCoord, c)` 함수가 정의되지 않는다.