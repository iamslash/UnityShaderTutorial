Shader "UnityShaderTutorial/basic_translucent" {
    Properties { 
        _Color ("Main Color", COLOR) = (1,1,1,0.5)
        _MainTex("Texture", 2D) = "white" {} 
    } 
    SubShader {
		Tags{ "Queue" = "Transparent" }
        Pass {
            Blend SrcAlpha OneMinusSrcAlpha 
                                                                       
            SetTexture [_MainTex] {
                    constantColor[_Color] 
                    Combine texture, constant
            }
        } 
    } 
} 