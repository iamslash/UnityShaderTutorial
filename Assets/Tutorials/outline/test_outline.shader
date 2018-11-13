Shader "Unlit/test_outline"
{
	Properties {
		_Color ("Main Color", Color) = (0.5, 0.5, 0.5 ,1)
		_MainTex ("Texture", 2D) = "white" {}
		_OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
		_OutlineWidth("Outline Width", Range(0, 5)) = 1
	}

	CGINCLUDE
	#include "UnityCG.cginc"

	struct appdata {
		float4 vertex : POSITION;
	};

	struct v2f {
		float4 pos : SV_POSITION;
	};

	float _OutlineWidth;
	float4 _OutlineColor;

	v2f vert(appdata v) {
		v.vertex *= _OutlineWidth;

		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		return o;
	}

	ENDCG

	SubShader {
		Tags{ "Queue" = "Transparent"}

		Pass {	// Render th Outline
			ZWrite off
			cull off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			float4 frag(v2f i) : COLOR
			{
				return _OutlineColor;
			}
			ENDCG
		}


		Pass {	// Normal Render
			ZWrite on
			cull off

			Material {
				Diffuse[_Color]
				Ambient[_Color]
			}

			Lighting on

			SetTexture[_MainTex] {
				ConstantColor[_Color]
			}

			SetTexture[_MainTex] {
				// previous - 이전 SetTexure로 인해 생겨난 결과값
				// primary - 조명이 계산된 색 또는 정점의 색
				// DOUBLE - 결과로 나온 색상을 2배 더 밝게하는 키워드
				Combine previous * primary DOUBLE
			}
		}
	}
}
