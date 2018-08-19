Shader "UnityShaderTutorial/basic_cull" {
	Properties { 
	        _MainTex ("Base Texture", 2D) = "white" {} 
    } 
    SubShader {
        Pass {
            Lighting On
            Cull Back
            SetTexture [_MainTex]
        }
    }
}