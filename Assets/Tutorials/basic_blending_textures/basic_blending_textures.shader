Shader "UnityShaderTutorial/basic_blending_textures" {
    Properties { 
         _MainTex("Main Texture", 2D) = "white" {} 
         _SubTex("Sub Texture", 2D) = "white" {} 
    }

    SubShader { 
           Pass { 
               SetTexture [_MainTex] {
				 Combine texture
			   }
               SetTexture [_SubTex] { 
                 Combine texture lerp(texture) previous 
               } 
           } 
    } 
}