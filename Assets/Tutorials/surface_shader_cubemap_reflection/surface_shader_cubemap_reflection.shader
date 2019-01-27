Shader "UnityShaderTutorial/surface_shader_cubemap_reflection" {
	Properties {
      _Cube ("Cubemap", CUBE) = "" {}
    }

    SubShader {
      Tags { "RenderType" = "Opaque" }

      CGPROGRAM
      #pragma surface surf Lambert

      struct Input {
          float3 worldRefl;
      };

      //sampler2D _MainTex;
      samplerCUBE _Cube;

      void surf (Input IN, inout SurfaceOutput o) {
          o.Albedo = texCUBE (_Cube, IN.worldRefl).rgb;
      }
      ENDCG
    } 
    Fallback "Diffuse"
}