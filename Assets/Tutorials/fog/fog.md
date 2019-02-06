# Abstract

안개를 그려보자

# Shader

```c
Shader "UnityShaderTutorial/fog" {
    SubShader {
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct vertexInput {
                float4 vertex : POSITION;
                float4 texcoord0 : TEXCOORD0;
            };

            struct fragmentInput{
                float4 position : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                
                UNITY_FOG_COORDS(1)
            };

            fragmentInput vert(vertexInput i){
                fragmentInput o;
                o.position = UnityObjectToClipPos(i.vertex);
                o.texcoord0 = i.texcoord0;

                UNITY_TRANSFER_FOG(o,o.position);
                return o;
            }

            fixed4 frag(fragmentInput i) : SV_Target {
                fixed4 color = fixed4(i.texcoord0.xy,0,0);
                
                //Apply fog (additive pass are automatically handled)
                UNITY_APPLY_FOG(i.fogCoord, color); 
                
                #ifdef UNITY_PASS_FORWARDADD
                  UNITY_APPLY_FOG_COLOR(i.fogCoord, color, float4(0,0,0,0));
                #else
                  fixed4 myCustomColor = fixed4(0,0,1,0);
                  UNITY_APPLY_FOG_COLOR(i.fogCoord, color, myCustomColor);
                #endif
                
                return color;
            }
            ENDCG
        }
    }
}
```

# Description

* 직접 작성한 버텍스/프래그먼트 셰이더에서는 안개가 자동 적용되지 않음
* #pragma multi_compile_fog 와 포그 관련 매크로 추가
* UNITY_FOG_COORDS(texcoord_index) : 안개 좌표를 저장할 구조체 멤버를 생성
    * texcoord_index : 사용할 texcoord의 인덱스
* UNITY_TRANSFER_FOG(output_struct, clip_space_pos) : clip space position에서의 안개 데이터를 저장
* UNITY_APPLY_FOG(fog_data, col) : 색상을 적용
    * forward_additive pass 에서는 자동으로 검은 안개 적용
* UNITY_APPLY_FOG_COLOR : 색상을 적용
![](/Assets/Tutorials/fog/fog.png)

