Shader "UnityShaderTutorial/basic_blend" {
    Properties {
        _Color("Main Color", Color) = (1, 1, 1, 1)
		_MainTex("Main Texture", 2D) = "white" {}
    }

    SubShader {
        Tags { "Queue" = "Transparent" }
        Pass {
        	Blend srcAlpha OneMinusSrcAlpha

			SetTexture[_MainTex] {
				ConstantColor[_Color]
				Combine texture lerp(texture) previous, constant
			}
        }
    }
}