# Abstract

스카이맵을 노멀맵과 함께 물체의 표면에서 반사시켜보자.

# Shader

```c
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
Shader "UnityShaderTutorial/skymap_reflect_normal" {
	Properties {
        // normal map texture on the material,
        // default to dummy "flat surface" normalmap
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

            struct v2f {
                float3 worldPos : TEXCOORD0;
                // these three vectors will hold a 3x3 rotation matrix
                // that transforms from tangent to world space
                half3 tspace0 : TEXCOORD1; // tangent.x, bitangent.x, normal.x
                half3 tspace1 : TEXCOORD2; // tangent.y, bitangent.y, normal.y
                half3 tspace2 : TEXCOORD3; // tangent.z, bitangent.z, normal.z
                // texture coordinate for the normal map
                float2 uv : TEXCOORD4;
                float4 pos : SV_POSITION;
            };

            // vertex shader now also needs a per-vertex tangent vector.
            // in Unity tangents are 4D vectors, with the .w component used to
            // indicate direction of the bitangent vector.
            // we also need the texture coordinate.
            v2f vert (float4 vertex : POSITION, float3 normal : NORMAL, float4 tangent : TANGENT, float2 uv : TEXCOORD0)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.worldPos = mul(_Object2World, vertex).xyz;
                half3 wNormal = UnityObjectToWorldNormal(normal);
                half3 wTangent = UnityObjectToWorldDir(tangent.xyz);
                // compute bitangent from cross product of normal and tangent
                half tangentSign = tangent.w * unity_WorldTransformParams.w;
                half3 wBitangent = cross(wNormal, wTangent) * tangentSign;
                // output the tangent space matrix
                o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
                o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
                o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);
                o.uv = uv;
                return o;
            }

            // normal map texture from shader properties
            sampler2D _BumpMap;
        
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the normal map, and decode from the Unity encoding
                half3 tnormal = UnpackNormal(tex2D(_BumpMap, i.uv));
                // transform normal from tangent to world space
                half3 worldNormal;
                worldNormal.x = dot(i.tspace0, tnormal);
                worldNormal.y = dot(i.tspace1, tnormal);
                worldNormal.z = dot(i.tspace2, tnormal);

                // rest the same as in previous shader
                half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                half3 worldRefl = reflect(-worldViewDir, worldNormal);
                half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldRefl);
                half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
                fixed4 c = 0;
                c.rgb = skyColor;
                return c;
            }
            ENDCG
        }
    }
}
```

# Description

`o.pos = UnityObjectToClipPos(vertex);`

```
Object Space에서 카메라의 Clip Space로 정점(vertex)을 변환한다.

(== mul(UNITY_MATRIX_MVP, float4(pos, 1.0)))
```

`o.worldPos = mul(_Object2World, vertex).xyz;`

```
월드 좌표계상의 정점의 좌표를 계산한다.

추가 설명)

_object2world - 현재 모델의 메트릭스
```

`half3 wNormal = UnityObjectToWorldNormal(normal);`

```
오브젝트의 노멀 벡터를 월드 좌표계상의 노멀 벡터로 변환한다.
```

`half3 wTangent = UnityObjectToWorldDir(tangent.xyz);`

```
노멀 벡터의 접선인 tanget를 월드 좌표계상 벡터로 변환한다. 
```

`half3 wBitangent = cross(wNormal, wTangent) * tangentSign;`

```
노멀 벡터와 탄젠트 벡터의 외적에 tangentSign을 곱하여 월드 좌표계상의 벡터로 변환한다.

추가 설명)

cross(x, y) - 두 벡터(x, y)의 외적을 계산.
```

`o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);`

`o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);`

`o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);`

```
TBN 행렬을 만들기 위한 값을 구성한다.
```

`half3 tnormal = UnpackNormal(tex2D(_BumpMap, i.uv));`

```
노말맵 텍스처의 컬러값을 변환하여 노멀 벡터 값을 만든다.
```

`half3 worldNormal;`

`worldNormal.x = dot(i.tspace0, tnormal);`
                
`worldNormal.y = dot(i.tspace1, tnormal);`

`worldNormal.z = dot(i.tspace2, tnormal);`

```
매핑된 노말벡터와 TBN을 이용하여 월드 좌표계상의 노말 벡터를 구한다.
```

`half3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));`

```
카메라 위치에서 오브젝트를 향하는 방향 벡터를 구한다.
```

`half3 worldRefl = reflect(-worldViewDir, worldNormal);`

```
입사 광선과 표면 법선을 사용하여 반사 벡터를 구한다.
```

`half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldRefl);`

```
반사 벡터 정보와 반사 큐브맵 정보를 이용하여 텍셀의 정보를 구한다.

추가 설명)

unity_SpecCube0 - 리플렉션 프로브로 들어오는 큐브맵.
```

`half3 skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);`

```
텍셀의 HDR 정보를 색상의 손상없이 나타내기 위해 LDR로 변환하여 사용한다.
```

# Prerequisites

* `NormalMap`에 관한 자세한 내용은 [normal_map](/Assets/Tutorials/normal_map/normal_map.md)를 참고하도록 한다.
* `Skymap Reflect`에 관한 자세한 내용은 [skymap_reflect](/Assets/Tutorials/skymap_reflect/skymap_reflect.md)를 참고하도록 한다.