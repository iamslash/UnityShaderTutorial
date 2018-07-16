Shader "Unlit/basic_properties2"
{
	Properties
	{
		[Toggle] _Invert("Invert?", Float) = 0
		[KeywordEnum(Red, Blue, Green)] _Color("Color Mode", Float) = 0
	}

	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma multi_compile _Color_Red _Color_Blue _Color_Green
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag(v2f IN) : SV_Target
			{
				fixed4 color = float4(0, 0, 0, 1);
				#ifdef _Color_Red
					color.r = 1;
				#elif _Color_Blue
					color.b = 1;
				#elif _Color_Green
					color.g = 1;
				#endif

				#if _INVERT_ON
					color = 1 - color;
				#endif

				return color;
			}
			ENDCG
		}
	}
}
