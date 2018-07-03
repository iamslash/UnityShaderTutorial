# Abstract

라이트를 켜자.

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

`fixed-style function command` 중 하나인 `Lighting`  를 이용하여 라이트를 활성화 하자. 이때 `Diffuse, Ambient` 는 고정된 값이다.

# Prerequisites

## Render-state setup commands

Pass 는 `Material, Lighting` 과 같은 다양한 `Render-state setup` 을 포함할 수 있다. `Render-state setup` commands 는 DirectX 를 사용할 때 `Device->Set*` 과 같다. 다음은 pixel shader 를 이용하는 directX 예이다.

```cpp
//////////////////////////////////////////////////////////////////////////////////////////////////
// 
// File: ps_multitex.cpp
// 
// Author: Frank Luna (C) All Rights Reserved
//
// System: AMD Athlon 1800+ XP, 512 DDR, Geforce 3, Windows XP, MSVC++ 7.0 
//
// Desc: Deomstrates multi-texturing using a pixel shader.  You will have
//       to switch to the REF device to run this sample if your hardware
//       doesn't support pixel shaders.
//          
//////////////////////////////////////////////////////////////////////////////////////////////////

#include "d3dUtility.h"

//
// Globals
//

IDirect3DDevice9* Device = 0; 

const int Width  = 640;
const int Height = 480;

IDirect3DPixelShader9* MultiTexPS = 0;
ID3DXConstantTable* MultiTexCT    = 0;

IDirect3DVertexBuffer9* QuadVB = 0;

IDirect3DTexture9* BaseTex      = 0;
IDirect3DTexture9* SpotLightTex = 0;
IDirect3DTexture9* StringTex    = 0;

D3DXHANDLE BaseTexHandle      = 0;
D3DXHANDLE SpotLightTexHandle = 0;
D3DXHANDLE StringTexHandle    = 0;

D3DXCONSTANT_DESC BaseTexDesc;
D3DXCONSTANT_DESC SpotLightTexDesc;
D3DXCONSTANT_DESC StringTexDesc;

// 
// Structs
//

struct MultiTexVertex
{
    MultiTexVertex(float x, float y, float z,
        float u0, float v0,
        float u1, float v1,
        float u2, float v2)
    {
         _x =  x;  _y =  y; _z = z;
        _u0 = u0; _v0 = v0; 
        _u1 = u1; _v1 = v1;
        _u2 = u2, _v2 = v2;
    }

    float _x, _y, _z;
    float _u0, _v0;
    float _u1, _v1;
    float _u2, _v2;

    static const DWORD FVF;
};
const DWORD MultiTexVertex::FVF = D3DFVF_XYZ | D3DFVF_TEX3; 

//
// Framework functions
//
bool Setup()
{
    HRESULT hr = 0;

    //
    // Create geometry.
    //

    Device->CreateVertexBuffer(
        6 * sizeof(MultiTexVertex), 
        D3DUSAGE_WRITEONLY,
        MultiTexVertex::FVF,
        D3DPOOL_MANAGED,
        &QuadVB,
        0);

    MultiTexVertex* v = 0;
    QuadVB->Lock(0, 0, (void**)&v, 0);

    v[0] = MultiTexVertex(-10.0f, -10.0f, 5.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f);
    v[1] = MultiTexVertex(-10.0f,  10.0f, 5.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f);
    v[2] = MultiTexVertex( 10.0f,  10.0f, 5.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f);

    v[3] = MultiTexVertex(-10.0f, -10.0f, 5.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f);
    v[4] = MultiTexVertex( 10.0f,  10.0f, 5.0f, 1.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f);
    v[5] = MultiTexVertex( 10.0f, -10.0f, 5.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f);

    QuadVB->Unlock();

    //
    // Compile shader
    //

    ID3DXBuffer* shader      = 0;
    ID3DXBuffer* errorBuffer = 0;

    hr = D3DXCompileShaderFromFile(
        "ps_multitex.txt",
        0,
        0,
        "Main", // entry point function name
        "ps_1_1",
        D3DXSHADER_DEBUG, 
        &shader,
        &errorBuffer,
        &MultiTexCT);

    // output any error messages
    if( errorBuffer )
    {
        ::MessageBox(0, (char*)errorBuffer->GetBufferPointer(), 0, 0);
        d3d::Release<ID3DXBuffer*>(errorBuffer);
    }

    if(FAILED(hr))
    {
        ::MessageBox(0, "D3DXCompileShaderFromFile() - FAILED", 0, 0);
        return false;
    }

    //
    // Create Pixel Shader
    //
    hr = Device->CreatePixelShader(
        (DWORD*)shader->GetBufferPointer(),
        &MultiTexPS);

    if(FAILED(hr))
    {
        ::MessageBox(0, "CreateVertexShader - FAILED", 0, 0);
        return false;
    }

    d3d::Release<ID3DXBuffer*>(shader);

    //
    // Load textures.
    //

    D3DXCreateTextureFromFile(Device, "crate.bmp", &BaseTex);
    D3DXCreateTextureFromFile(Device, "spotlight.bmp", &SpotLightTex);
    D3DXCreateTextureFromFile(Device, "text.bmp", &StringTex);

    //
    // Set Projection Matrix
    //

    D3DXMATRIX P;
    D3DXMatrixPerspectiveFovLH(
            &P, D3DX_PI * 0.25f, 
            (float)Width / (float)Height, 1.0f, 1000.0f);

    Device->SetTransform(D3DTS_PROJECTION, &P);

    //
    // Disable lighting.
    //

    Device->SetRenderState(D3DRS_LIGHTING, false);

    // 
    // Get Handles
    //

    BaseTexHandle      = MultiTexCT->GetConstantByName(0, "BaseTex");
    SpotLightTexHandle = MultiTexCT->GetConstantByName(0, "SpotLightTex");
    StringTexHandle    = MultiTexCT->GetConstantByName(0, "StringTex");

    //
    // Set constant descriptions:
    //

    UINT count;
    
    MultiTexCT->GetConstantDesc(BaseTexHandle,      &BaseTexDesc, &count);
    MultiTexCT->GetConstantDesc(SpotLightTexHandle, &SpotLightTexDesc, &count);
    MultiTexCT->GetConstantDesc(StringTexHandle,    &StringTexDesc, &count);

    MultiTexCT->SetDefaults(Device);

    return true;
}

void Cleanup()
{
    d3d::Release<IDirect3DVertexBuffer9*>(QuadVB);

    d3d::Release<IDirect3DTexture9*>(BaseTex);
    d3d::Release<IDirect3DTexture9*>(SpotLightTex);
    d3d::Release<IDirect3DTexture9*>(StringTex);

    d3d::Release<IDirect3DPixelShader9*>(MultiTexPS);
    d3d::Release<ID3DXConstantTable*>(MultiTexCT);
}

bool Display(float timeDelta)
{
    if( Device )
    {
        // 
        // Update the scene: Allow user to rotate around scene.
        //
        
        static float angle  = (3.0f * D3DX_PI) / 2.0f;
        static float radius = 20.0f;
        
        if( ::GetAsyncKeyState(VK_LEFT) & 0x8000f )
            angle -= 0.5f * timeDelta;

        if( ::GetAsyncKeyState(VK_RIGHT) & 0x8000f )
            angle += 0.5f * timeDelta;

        if( ::GetAsyncKeyState(VK_UP) & 0x8000f )
            radius -= 2.0f * timeDelta;

        if( ::GetAsyncKeyState(VK_DOWN) & 0x8000f )
            radius += 2.0f * timeDelta;

        D3DXVECTOR3 position( cosf(angle) * radius, 0.0f, sinf(angle) * radius );
        D3DXVECTOR3 target(0.0f, 0.0f, 0.0f);
        D3DXVECTOR3 up(0.0f, 1.0f, 0.0f);
        D3DXMATRIX V;
        D3DXMatrixLookAtLH(&V, &position, &target, &up);

        Device->SetTransform(D3DTS_VIEW, &V);
        
        //
        // Render
        //

        Device->Clear(0, 0, D3DCLEAR_TARGET | D3DCLEAR_ZBUFFER, 0xffffffff, 1.0f, 0);
        Device->BeginScene();

        Device->SetPixelShader(MultiTexPS);
        Device->SetFVF(MultiTexVertex::FVF);
        Device->SetStreamSource(0, QuadVB, 0, sizeof(MultiTexVertex));

        // base tex
        Device->SetTexture(     BaseTexDesc.RegisterIndex, BaseTex);
        Device->SetSamplerState(BaseTexDesc.RegisterIndex, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
        Device->SetSamplerState(BaseTexDesc.RegisterIndex, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
        Device->SetSamplerState(BaseTexDesc.RegisterIndex, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);

        // spotlight tex
        Device->SetTexture(     SpotLightTexDesc.RegisterIndex, SpotLightTex);
        Device->SetSamplerState(SpotLightTexDesc.RegisterIndex, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
        Device->SetSamplerState(SpotLightTexDesc.RegisterIndex, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
        Device->SetSamplerState(SpotLightTexDesc.RegisterIndex, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);

        // string tex
        Device->SetTexture(     StringTexDesc.RegisterIndex, StringTex);
        Device->SetSamplerState(StringTexDesc.RegisterIndex, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
        Device->SetSamplerState(StringTexDesc.RegisterIndex, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
        Device->SetSamplerState(StringTexDesc.RegisterIndex, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR);

        Device->DrawPrimitive(D3DPT_TRIANGLELIST, 0, 2);
        
        Device->EndScene();
        Device->Present(0, 0, 0, 0);
    }
    return true;
}

//
// WndProc
//
LRESULT CALLBACK d3d::WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
    switch( msg )
    {
    case WM_DESTROY:
        ::PostQuitMessage(0);
        break;
        
    case WM_KEYDOWN:
        if( wParam == VK_ESCAPE )
            ::DestroyWindow(hwnd);

        break;
    }
    return ::DefWindowProc(hwnd, msg, wParam, lParam);
}


//
// WinMain
//
int WINAPI WinMain(HINSTANCE hinstance,
                   HINSTANCE prevInstance, 
                   PSTR cmdLine,
                   int showCmd)
{
    if(!d3d::InitD3D(hinstance,
        Width, Height, true, D3DDEVTYPE_HAL, &Device))
    {
        ::MessageBox(0, "InitD3D() - FAILED", 0, 0);
        return 0;
    }
        
    if(!Setup())
    {
        ::MessageBox(0, "Setup() - FAILED", 0, 0);
        return 0;
    }

    d3d::EnterMsgLoop( Display );

    Cleanup();

    Device->Release();

    return 0;
}
```