Shader "UnityShaderTutorial/shader_variants" {
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vertexShader
            #pragma fragment fragmentShader
			//#pragma shader_feature RED GREEN BLUE
			#pragma shader_feature A B
			#pragma shader_feature C D 
			#pragma shader_feature E F
			#pragma shader_feature G H
			#pragma shader_feature I J
			#pragma shader_feature K L
			#pragma shader_feature M N
			#pragma shader_feature O P
            #pragma shader_feature Q R
			#pragma shader_feature S T

            float4 vertexShader (float4 vertex : POSITION) : SV_POSITION
            {
                return UnityObjectToClipPos(vertex);
            }

            fixed4 fragmentShader () : SV_Target
            {
                fixed4 col = fixed4 (0, 0, 0, 1);
                # ifdef RED
                    col = fixed4 (1, 0, 0, 1);
                # elif GREEN
                    col = fixed4 (0, 1, 0, 1);
                # elif BLUE
                    col = fixed4 (0, 0, 1, 1);
                # endif
                return col;
            }
            ENDCG
        }
    }
}