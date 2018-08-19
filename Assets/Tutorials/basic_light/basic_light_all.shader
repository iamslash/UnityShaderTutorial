Shader "UnityShaderTutorial/basic_light_all" {
	Properties{
		_Color("Main Color", Color) = (1,1,1,1)
		_SpecColor("Spec Color", Color) = (1,1,1,1)
		_Emission("Emmisive Color", Color) = (0,0,0,0)
		_Shininess("Shininess", Range(0.01, 1)) = 0.2
	}

	SubShader{
		Pass{
			// Set up basic vertex lighting
			Material{
				Diffuse[_Color]
				Ambient[_Color]
				Shininess[_Shininess]
				Specular[_SpecColor]
				Emission[_Emission]
			}
			Lighting On
			SeparateSpecular On
		}
	}
}