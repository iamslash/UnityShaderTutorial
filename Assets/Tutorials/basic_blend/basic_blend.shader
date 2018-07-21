Shader "UnityShaderTutorial/basic_blend" {
    Properties {
        _MainTex ("Texture to blend", 2D) = ""
    }
    SubShader {
        Tags { "Queue" = "Transparent" }
        Pass {
        	Material {
                Diffuse (1,1,1,1)
                Ambient (1,1,1,1)
            }
            Lighting On

            SetTexture [_MainTex] {
                constantColor (1, 1, 1, 1)
                combine constant lerp(texture) previous
            }
        }
    }
}