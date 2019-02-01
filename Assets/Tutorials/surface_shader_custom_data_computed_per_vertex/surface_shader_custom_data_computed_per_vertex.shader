Shader "UnityShaderTutorial/surface_shader_custom_data_computed_per_vertex" {
	Properties {
      _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader {
      Tags { "RenderType" = "Opaque" }

      CGPROGRAM
      #pragma surface surf Lambert vertex:vert

      struct Input {
          float2 uv_MainTex;
          float3 customColor;
      };

      void vert (inout appdata_full v, out Input o) {
          UNITY_INITIALIZE_OUTPUT(Input,o);
          o.customColor = float3(0,1,0);
          //o.customColor = abs(v.normal);
      }

      sampler2D _MainTex;

      void surf (Input IN, inout SurfaceOutput o) {
          o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
          o.Albedo *= IN.customColor;
      }
      ENDCG
    } 
    Fallback "Diffuse"
}