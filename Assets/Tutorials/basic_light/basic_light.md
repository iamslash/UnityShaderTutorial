# Abstract

라이트를 켜자.

# References

* [The cg Tutorial](http://developer.download.nvidia.com/CgTutorial/cg_tutorial_chapter05.html)
  * 라이팅을 cg로 어떻게 구현하는지 설명한다.

# Shader

```c
Shader "UnityShaderTutorial/basic_light" {
	SubShader{
		Pass{
			Material{
				Diffuse(1,1,1,1)
				Ambient(1,1,1,1)
			}
			Lighting On
		}
	}
}
```

# Description

`Material` 은 `fixed-style function command` 중 하나이고 문법은 다음과 같다.

```c
  Material {
	  Material Block
  }
```

`Material Block` 은 `Diffuse, Ambient, Specular, Shiness, Emission` 과 같은 표현으로 구성될 수 있다. `Diffuse` 는 RGBA 값을 인자로 갖고 물체의 표면색을 결정한다. `Ambient` 는 RGBA 값을 인자로 갖고 환경색을 결정한다. 

`Lighting` 은 라이트를 작동할지 말지 결정한다. 작동할 때는 `On` 을 작동하지 않을 때는 `Off` 를 인자로 갖는다.

물체의 표면을 구성하는 각 점들의 색은 빛을 고려한 수식에 의해 결정된다. 수식은 너무 복잡하기에 지금은 생략한다. 위의 Shader 는 점의 최종색을 결정할 때 언급한 수식에 `Material Block` 의 `Diffuse, Ambient` 를 사용한다.

# Prerequisites

## Material Block

`Material Block` 옵션은 material이 어떻게 빛에 반응하는 것에 대한 설정을 가지고 있다. 각각의 옵션은 생략이 가능하고 그 경우 기본값은 검은색으로 들어간다.(사용하지 않음)

* Diffuse Color : 오브젝트의 기본 색상이다.

* Ambient Color : Lignting Window의 ambient light set에 맞았을 때 표현되는 색상이다.

* Specular Color : 오브젝트의 specular highlight 색상이다.

* Shininess Number : highlight의 밀집도이다. 0은 넓은 범위의 highlight를 표현하게 되고, 1은 좁은 범위를 표현하게 된다.

* Emission Color : 어떠한 라이트도 받지 않을 때의 오브젝트 색상이다.

오브젝트에 라이트가 들어올 때 최종 색상 계산은 다음과 같다.

```
Ambient * Lighting Window's Ambient Intensity setting + (Light Color * Diffuse + Light Color * Specular) + Emission
```

위의 식에서 괄호 부분은 오브젝트에 받는 모든 조명에 대해 반복 계산된다.
일반적으로 Diffuse 색상과 Ambient 색상은 동일한 값을 지정한다.

## fixed-style function commands

빛을 표현하기 위해 사용되는 `fixed-style function command` 는 다음과 같다.

* Color : 오브젝트를 solid color로 설정한다.

```c
 Color color
```

* Material : Material Block에 옵션을 넣어 오브젝트의 material property를 정의하는데 사용한다.

```c
  Material {
	Material Block
  }

```

* Lighting : 라이트 표현을 적용할 지 결정한다. `On` 옵션은 Material Block에 정의된 옵션을 적용한다. `Off` 옵션은 `Color` command의 색상을 적용한다.

```c
  Lighting On | Off
```

* SeparateSpecular : specular lighting을 추가할 지 결정한다. 쉐이더 패스의 끝에 추가하기 때문에 텍스쳐 처리에 영향을 받지 않는다. `Lighting` 옵션이 켜져있어야만 사용가능하다.

```c
  SeparateSpecular On | Off
```

* ColorMaterial : material에 설정된 색상 대신 per-vertex color를 사용한다. 각 옵션은 어떤 색상을 대체할 것인지 설정한다.

```c
  ColorMaterial AmbientAndDiffuse | Emission
```

## Render-state setup commands

Pass 는 `Material, Lighting` 과 같은 다양한 `Render-state setup` 을 포함할 수 있다. `Render-state setup` commands 는 DirectX 를 사용할 때 `Device->Set*` 과 같다.

## Basic Per-Vertex Lighting Model

OpenGL과 Direct3D는 거의 동일한 fixed-function lighting models을 제공한다. 이 설명은 fixed-function lighting model의 Basic model을 사용한다. Basic model은 Phong model을 수정하고 확장한다. Basic model 에서 물체의 표면색은 EMISSIVE, AMBIENT, DIFFUSE, SPECULAR 라이팅의 기여도 합계로 표현된다.
surfaceColor = emissive + ambient + diffuse + specular

(해당 모델에서는 per-light ambient color를 사용하지 않고, attenuation(감쇠)과 spotlight effect는 고려하지 않는다.)

emissive term은 표면에서 방출되거나 방출되는 빛을 나타낸다. emissive term은 방출 된 빛의 색상을 나타내는 RGB 값이다. 완전히 어두운 방에서 방사형 물질을 보는 경우, 이 색으로 보인다. 완전한 방사형 객체는 객체 전체를 하나의 색으로 렌더링한다. 방사형 객체 자체는 광원이 아니며, 다른 객체를 비추거나 투영하지 않는다. emissive term은 모든 다른 라이팅 텀을 계산한 뒤 추가되는 색이다.
emissive = Ke 
-> Ke는 물체의 emissive color.

ambient term은 주변에서 나온 빛이 반사되어 보이는 빛이다. 모든 방향에서 오는 것처럼 보이기 때문에 광원 위치에 의존하지 않는다. ambient term은 물체의 ambient 반사율, material에 들어오는 ambient light의 색상에 따라 달라진다. emissive term과 마찬가지로 일정한 색을 가지지만 global ambient 라이팅의 영향을 받는다.
ambient = Ka x globalAmbient 
-> Ka는 material의 ambient 반사율, globalAmbient는 주변 라이팅의 색상이다.

diffuse term(확산광)은 표면에서 모든 방향으로 똑같이 반사되는 방향성 빛을 설명한다. 일반적으로 diffuse surface 는 미세한 크기로 크고 작은 틈이 있기 때문에 들어오는 라이팅이 모든 방향으로 반사(산란)된다. 반사되는 빛의 양은 표면에 닿는 빛의 입사각에 비례한다. 

[![diffuse light scattering](http://developer.download.nvidia.com/CgTutorial/elementLinks/fig5_6.jpg)](http://developer.download.nvidia.com/CgTutorial/cg_tutorial_chapter05.html)

시점의 위치에 관계없이 한 표면의 특정지점에서 확산 기여도는 동일하다.

[![diffuse term](http://developer.download.nvidia.com/CgTutorial/elementLinks/fig5_7.jpg)](http://developer.download.nvidia.com/CgTutorial/cg_tutorial_chapter05.html)

diffuse = Kd x lightColor x max(N · L, 0)
-> Kd는 material의 diffuse 색상, lightColor는 들어오는 diffuse light의 색상, N은 정규화된 표면 법선, L은 광원을 향한 노멀 벡터, P는 셰이딩 되는 점이다.

[![calculate diffuse](http://developer.download.nvidia.com/CgTutorial/elementLinks/fig5_9.jpg)](http://developer.download.nvidia.com/CgTutorial/cg_tutorial_chapter05.html)

specular term(반사광)은 주로 거울 방향을 중심으로 표면에서 산란된 빛을 나타낸다. 매끄럽고 광택이 나는 금속과 같은 표면에서 두드러지게 나타난다. 

[![specular reflection](http://developer.download.nvidia.com/CgTutorial/elementLinks/fig5_10.jpg)](http://developer.download.nvidia.com/CgTutorial/cg_tutorial_chapter05.html)

다른 세개의 lighting term과 달리 specular는 뷰어의 위치에 따라 달라진다. 뷰어가 반사광을 받는 위치에 있지 않으면 뷰어는 표면의 specular highlight를 볼 수 없다. specular term은 광원과 재질의 specular color 뿐만 아니라 표면의 광택도에 영향을 받는다. 광택도가 높은 소재는 밀집도가 높은 highlight를 생성하지만, 광택도가 낮은 소재는 highlight가 확산된다.

[![shininess](http://developer.download.nvidia.com/CgTutorial/elementLinks/fig5_12.jpg)](http://developer.download.nvidia.com/CgTutorial/cg_tutorial_chapter05.html)

specular = Ks x lightColor x facing x (max(N · H, 0)) shininess
-> Ks는 재질의 specular 색상, lightColor는 들어오는 반사광의 색상, N은 정규화된 표면 법선, V는 viewpoint에 대한 노멀 벡터, L은 광원을 향한 노멀 벡터, H는 V와 L의 중간에 있는 노멀 벡터, P는 셰이딩 되는 점이다. N * L이 0보다 크면 facing이 1이고, 아니면 0이다. (기준각도 90도)

[![calculate specular](http://developer.download.nvidia.com/CgTutorial/elementLinks/fig5_13.jpg)](http://developer.download.nvidia.com/CgTutorial/cg_tutorial_chapter05.html)

ambient, diffuse, specular color를 조합하면 다음과 같은 final lighting이 나온다. emissive term은 일반적으로 특수 효과를 위해 사용되기 때문에 제외되었다.

[![final lighting](http://developer.download.nvidia.com/CgTutorial/elementLinks/fig5_14.jpg)](http://developer.download.nvidia.com/CgTutorial/cg_tutorial_chapter05.html)
