# Abstract

반투명한 물체의 표면을 뚫고 들어가 산란하는 빛을 표현해보자

# Shader

```c
Shader "UnityShaderTutorial/subsurface_scattering" {
    Properties {
        _MainTex("Texture", 2D) = "white" {}
    }

    SubShader {
        Pass {
            Tags {"LightMode"="ForwardBase"}
            CGPROGRAM
            ENDCG
        }
    }
}
```

# Description



# Prerequisites



# References

* http://developer.download.nvidia.com/books/HTML/gpugems/gpugems_ch16.html
* https://docs.arnoldrenderer.com/display/A5AFMUG/Subsurface