Shader "UnityShaderTutorial/basic_texture" {
    Properties { 
        _MainTex ("Base Texture", 2D) = "white" {} 
    } 
    SubShader { 
        Pass { 
            SetTexture [_MainTex]
        }
    } 
} 