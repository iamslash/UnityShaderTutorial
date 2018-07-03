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

COLOR type 의 프라퍼티 _MyColor 를 하나 만들자. inspector 에서 이름은 "Main Color" 이고 기본값은 `(0,0,1,1)` 이다. COLOR value 는 순서대로 `(r, g, b, a)` 를 의미한다.

# Prerequisites

## Properties

Properties 는 inpsector 를 통해서 값을 변경할 수 있게 해준다. 다음과 같은 문법을 갖는다.

```
Properties { Property [Property ...] }
```

다음은 Property 중 숫자와 슬라이드의 예이다.

```
name ("display name", Range (min, max)) = number
name ("display name", Float) = number
name ("display name", Int) = number
```

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

Properties 의 inspect GUI 를 커스터마이징할 수 있다. 다음과 같은 쉐이더가 있다고 하자.


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

`_Invert` 의 경우 [Toggle] Attribute 가 선언되었다. 다음과 같이 `MyToggleDraw` 를 정의하면 `_Invert` 의 inpector GUI 를 재정의할 수 있다.

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
// A slider with 3.0 response curve
[PowerSlider(3.0)] _Shininess ("Shininess", Range (0.01, 1)) = 0.08
```

다음은 `IntRangeDrawer` 의 예이다.

```c
// An integer slider for specified range (0 to 255)
[IntRange] _Alpha ("Alpha", Range (0, 255)) = 100
```