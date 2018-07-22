Shader "UnityShaderTutorial/basic_cull_front" {
	Properties { 
	        _MainTex ("Base Texture", 2D) = "white" {} 
    } 
    SubShader {
        Pass {
            Lighting On
            Cull Front
            SetTexture [_MainTex]
        }
    }
}