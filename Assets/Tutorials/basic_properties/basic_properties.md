# Abstract

프라퍼티를 사용해보자.

# Shader

```c
Shader "UnityShaderTutorial/basic_properties" {
    Properties { 
        _MyColor ("Main Color", COLOR) = (0,0,1,1) 
    } 
    SubShader { 
        Pass { 
            Material { 
                Diffuse [_MyColor] 
                Ambient [_MyColor] 
            } 
            Lighting On 
        } 
    } 
} 
```

# Description

사용자가 인스펙터에서 설정한 값이 쉐이더에서 사용되게 하려면 어떻게 해야할까? 바로 프라퍼티를 사용하면 된다.
프라퍼티는 `Shader` 안에서 쓰여질 수 있고 문법은 다음과 같다.

```
Properties {
  Property 
  [Property ...] 
}
```

`Properties` 에 포함되는 각 `Property` 는 다음과 같이 구셩된다.

``````
name ("display name", Range (min, max)) = number
name ("display name", Float) = number
name ("display name", Int) = number
```

`name` 은 프라퍼티의 이름이고 shader 에서 사용할 때는 `name` 으로 사용한다. 
위의 쉐이더의 경우 `_MyColor` 이름의 프라터피 값은 `Diffuse, Ambient` 의 인자로 사용된다.
`number` 는 기본값을 의미하고 `Range, Float, Int` 는 프라퍼티의 타입을 의미한다.
프라퍼티의 타입은 이밖에도 `Color, Vector, 2D, Cube, 3D` 등이 있고 각 타입은 인스펙터에서 모양이 다르다.

# Prerequisites

## Properties

다음은 Property 중 컬러와 벡터의 예이다.

```
name ("display name", Color) = (number,number,number,number)
name ("display name", Vector) = (number,number,number,number)
```

다음은 Property 중 텍스처의 예이다.

```
name ("display name", 2D) = "defaulttexture" {}
name ("display name", Cube) = "defaulttexture" {}
name ("display name", 3D) = "defaulttexture" {}
```

## Properties Custom Drawing

Properties 의 특정 Attribute에 대한 inspector GUI 를 커스터마이징할 수 있다. 다음과 같은 쉐이더가 있다고 하자.

```c
Shader "Custom/Example"
{
    Properties
    {
        _MainTex("Base (RGB)", 2D) = "white" {}

        // Display a popup with None,Add,Multiply choices,
        // and setup corresponding shader keywords.
        [KeywordEnum(None, Add, Multiply)] _Overlay("Overlay mode", Float) = 0

        _OverlayTex("Overlay", 2D) = "black" {}

        // Display as a toggle.
        [MyToggle] _Invert("Invert color?", Float) = 0
    }

    // rest of shader code...
}
```

`_Invert` 의 경우 [MyToggle] Attribute 가 선언되었다. 다음과 같이 `MyToggleDraw` 를 정의하면 `_Invert` 의 inpector GUI 를 재정의할 수 있다.

```cs
using UnityEngine;
using UnityEditor;
using System;

// The property drawer class should be placed in an editor script, inside a folder called Editor.
// Use with "[MyToggle]" before a float shader property.

public class MyToggleDrawer : MaterialPropertyDrawer
{
    // Draw the property inside the given rect
    public override void OnGUI (Rect position, MaterialProperty prop, String label, MaterialEditor editor)
    {
        // Setup
        bool value = (prop.floatValue != 0.0f);

        EditorGUI.BeginChangeCheck();
        EditorGUI.showMixedValue = prop.hasMixedValue;

        // Show the toggle control
        value = EditorGUI.Toggle(position, label, value);

        EditorGUI.showMixedValue = false;
        if (EditorGUI.EndChangeCheck())
        {
            // Set the new value if it has changed
            prop.floatValue = value ? 1.0f : 0.0f;
        }
    }
}
```

unity 에 `ToggleDrawer, EnumDrawer, KeywordEnumDrawer, PowerSliderDrawer, IntRangeDrawer` 같은 builtin drawer 들이 존재한다.

다음은 `ToggleDrawer` 의 예이다.

```c
// Will set "_INVERT_ON" shader keyword when set
[Toggle] _Invert ("Invert?", Float) = 0

// Will set "ENABLE_FANCY" shader keyword when set.
[Toggle(ENABLE_FANCY)] _Fancy ("Fancy?", Float) = 0
```

다음은 `EnumDrawer` 의 예이다.

```c
// Blend mode values
[Enum(UnityEngine.Rendering.BlendMode)] _Blend ("Blend mode", Float) = 1

// A subset of blend mode values, just "One" (value 1) and "SrcAlpha" (value 5).
[Enum(One,1,SrcAlpha,5)] _Blend2 ("Blend mode subset", Float) = 1
```

다음은 `KeywordEnumDrawer` 의 예이다. `KeywordEnumDraw` 는 9개 까지의 키워드가 가능하다. 설정된 키워드는 `"#pragma multi_compile` 에서 variant 를 켜고 끌 수 있다. `multi_compile` 의 옵션 이름은 `"property name" + underscore + "enum name"` 의 형식으로 해야 한다.

```c
// Display a popup with None, Add, Multiply choices.
// Each option will set _OVERLAY_NONE, _OVERLAY_ADD, _OVERLAY_MULTIPLY shader keywords.
[KeywordEnum(None, Add, Multiply)] _Overlay ("Overlay mode", Float) = 0

// ...later on in CGPROGRAM code:
#pragma multi_compile _OVERLAY_NONE _OVERLAY_ADD _OVERLAY_MULTIPLY
// ...
```

다음은 `PowerSliderDrawer` 의 예이다.

```c
// 비선형 슬라이더, 천천히 가다가 빨라진다.
[PowerSlider(3.0)] _Shininess ("Shininess", Range (0.01, 1)) = 0.08
```

다음은 `IntRangeDrawer` 의 예이다.

```c
// 정수형 슬라이더
[IntRange] _Alpha ("Alpha", Range (0, 255)) = 100
```
