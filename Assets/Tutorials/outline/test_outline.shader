Shader "Unlit/test_outline"
{
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
		_OutlineWidth("Outline Width", Range(0, 5)) = 1
	}

	SubShader {
		Tags{ "Queue" = "Transparent"}

		Pass {	// Render Outline
			ZWrite off	// 불투명한것을 그리는 경우 on, 부분적으로 투명한 것을 그리는 경우 off
			cull off	// 앞과 뒤면을 모두 그려주기 위해 off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

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

			float4 frag(v2f i) : COLOR {
				return _OutlineColor;
			}
			ENDCG
		}


		Pass {	// Normal Render
			ZWrite on
			cull off

			SetTexture[_MainTex]
		}
	}
}
