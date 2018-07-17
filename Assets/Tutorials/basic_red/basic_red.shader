// * Shader
// 1. 경로 설정
Shader "UnityShaderTutorial/basic_red" {
	// * SubShader
	// 1. Object를 표현하기 위해 Shader의 첫번째 SubShader를 찾아 그래픽카드에서 실행
	// 2. 사용하고자 하는 SubShader가 없다면 Fallback 호출
	SubShader{
		// * Pass
		// 1. 적어도 하나의 Pass를 가지고 있어야 한다.
		// 2. 특정 Pass를 지정하지 않으면 순서대로 실행한다.
		Pass{
			// PassName 설정
			// 1. 외부에서 해당 Pass를 사용하려 접근할때도 사용 (== Usepass)
			// 1-1. 사용방법 ex) usepass "UnityShaderTutorial/basic_red/CHANGE_RED"
			name "CHANGE_RED"

			Color(1,0,0,1)
		}
	}

	Fallback "Diffuse"
}