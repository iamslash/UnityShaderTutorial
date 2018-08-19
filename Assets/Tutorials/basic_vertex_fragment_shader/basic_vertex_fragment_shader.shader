Shader "UnityShaderTutorial/basic_vertex_fragment_shader" {
    Properties
    {
        // Color property for material inspector, default to white
        _Color ("Main Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vertexShader
            #pragma fragment fragmentShader

            // vertex shader
            // this time instead of using "appdata" struct, just spell inputs manually,
            // and instead of returning v2f struct, also just return a single output
            // float4 clip position
            float4 vertexShader(float4 vertex : POSITION) : SV_POSITION
            {
				//Transforms a point from object space to the camera’s clip space in homogeneous coordinates.
				//This is the equivalent of mul(UNITY_MATRIX_MVP, float4(pos, 1.0)), and should be used in its place.
		        return UnityObjectToClipPos(vertex);
            }
            
            // color from the material
            fixed4 _Color;

            // pixel shader, no inputs needed
            fixed4 fragmentShader() : SV_Target
            {
                return _Color; // just return it
            }
            ENDCG
        }
    }
}