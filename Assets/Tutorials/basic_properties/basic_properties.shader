Shader "UnityShaderTutorial/basic_properties" {
    Properties { 
        _MainColor ("Main Color", Color) = (0, 0, 1, 1)

		[KeywordEnum(Red, Blue, Green)] _Color("Color Mode", Float) = 0

		[Header(group of things)]
		// "_INVERT_ON"셰이더 키워드를 설정합니다.
		[Toggle] _Invert("Invert color?", Float) = 0

		// "ENABLE_FANCY"쉐이더 키워드를 설정합니다.
		[MyToggle] _Fancy("Fancy?", Float) = 0

		_Range("Range", Range(0.01, 10)) = 0
		[IntRange] _Alpha("Alpha", Range(0, 255)) = 100
		[PowerSlider(3.0)] _Shininess("Shininess", Range(0.01, 10)) = 0.08
	}

	SubShader{
		Pass {
			Material {
				Diffuse[_MainColor]
				Ambient[_MainColor]
			}
			Lighting On
		}
	}
} 