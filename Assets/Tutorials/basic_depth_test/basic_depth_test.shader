Shader "UnityShaderTutorial/basic_depth_test" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

		// extra pass that renders to depth buffer only
		Pass {
			//ZWrite On
			ZTEST Less
			Color [_Color]
		}
	}
}