# Abstract

스카이맵을 노멀맵, 오클루젼맵과 함께 물체의 표면에서 반사시켜보자

# Shader

```c
Shader "Unlit/skymap_reflect_normal_occlusion"
{
    Properties {
        // three textures we'll use in the material
        _OcclusionMap("Occlusion", 2D) = "white" {}
        _BumpMap("Normal Map", 2D) = "bump" {}
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            // exactly the same as in previous shader
            struct v2f {
                float3 worldPos : TEXCOORD0;
                half3 tspace0 : TEXCOORD1;
                half3 tspace1 : TEXCOORD2;
                half3 tspace2 : TEXCOORD3;
                float2 uv : TEXCOORD4;
                float4 pos : SV_POSITION;
            };
            v2f vert (float4 vertex : POSITION, float3 normal : NORMAL, float4 tangent : TANGENT, float2 uv : TEXCOORD0)
            {
                v2f o;
                o.pos = mul(UNITY_MATRIX_MVP, vertex);
                o.worldPos = mul(_Object2World, vertex).xyz;
                half3 wNormal = UnityObjectToWorldNormal(normal);
                half3 wTangent = UnityObjectToWorldDir(tangent.xyz);
                half tangentSign = tangent.w * unity_WorldTransformParams.w;
                half3 wBitangent = cross(wNormal, wTangent) * tangentSign;
                o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
                o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
                o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);
                o.uv = uv;
                return o;
            }

            // textures from shader properties
            sampler2D _OcclusionMap;
            sampler2D _BumpMap;
        
            fixed4 frag (v2f i) : SV_Target
            {
                // same as from previous shader...
                half3 tnormal = UnpackNormal(tex2D(_BumpMap, i.uv));
                half3 worldNormal;
                worldNormal.x = dot(i.tspace0, tnormal);
                worldNormal.y = dot(i.tspace1, tnormal);
                worldNormal.z = dot(i.tspace2, tnormal);
                half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                half3 worldRefl = reflect(-worldViewDir, worldNormal);
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldRefl);
                half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);                
                fixed4 c = 0;
                c.rgb = skyColor;

                // modulate sky color with the occlusion map
                fixed occlusion = tex2D(_OcclusionMap, i.uv).r;
                c.rgb *= occlusion;

                return c;
            }
            ENDCG
        }
    }
}
```

# Description

[skymap_reflect_normal](/Assets/Tutorials/skymap_reflect_normal/skymap_reflect_normal.md)에 `Occlusion Map`이 추가된 모델이다.

[Occlusion Map](https://docs.unity3d.com/kr/530/Manual/StandardShaderMaterialParameterOcclusionMap.html)은 모델의 해당 영역이 간접 조명을 받아야 하는지 에 대한 정보를 담고 있는 텍스쳐 파일이다. 

`Occlusion Map`은 그레이 스케일 이미지로, 흰색은 간접 조명을 표시할 영역, 검은색은 간접 조명을 표시하지 않을 영역을 나타낸다.

위의 코드에서는 컬러값에 occlusion값을 곱해주는 작업을 한다. Unity Standard Shader에서는 `UnityGI_Base` 함수 내부에서 간접광 디퓨즈에 occlusion을 곱해주는 작업을 한다.

```
o_gi.indirect.diffuse *= occlusion;
```

# Prerequisites

* [normal_map](/Assets/Tutorials/normal_map/normal_map.md)
* [skymap_reflect](/Assets/Tutorials/skymap_reflect/skymap_reflect.md)
* [skymap_reflect_normal](/Assets/Tutorials/skymap_reflect_normal/skymap_reflect_normal.md)