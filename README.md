# Introduction

unity shader 를 단계별로 학습할 수 있도록 한다.

# Materials

* [unity shader tutorial](https://docs.unity3d.com/Manual/Shaders.html)
* [unity shader reference](https://docs.unity3d.com/Manual/SL-Reference.html)
* [Unity 5.x Shaders and Effects Cookbook](https://books.google.co.kr/books?id=-llLDAAAQBAJ&printsec=frontcover&dq=unity3d+5.x+shader+cook+book&hl=ko&sa=X&redir_esc=y#v=onepage&q=unity3d%205.x%20shader%20cook%20book&f=false)
* [unity cg programming](https://en.wikibooks.org/wiki/Cg_Programming/Unity)
* [shaders @ unitywiki](http://wiki.unity3d.com/index.php/Shaders)
* [Resources for Writing Shaders in Unity](https://github.com/VoxelBoy/Resources-for-Writing-Shaders-in-Unity)
* [Adbanced shader for three.js](https://github.com/lo-th/Shader.lab)

# Tutorials

| name | subject | shader |
|:----:|:-----------:|:----:|
| [basic_red](/Assets/Tutorials/basic_red/basic_red.md) | 물체를 빨간색으로 칠해보자 | [basic_red.shader](/Assets/Tutorials/basic_red/basic_red.shader) |
| [basic_light](/Assets/Tutorials/basic_light/basic_light.md) | 라이트를 켜보자 | [basic_light.shader](/Assets/Tutorials/basic_light/basic_light.shader) |
| basic_properties | 프라퍼티를 사용해보자 | |
| basic_texture | 텍스처를 사용해보자 |  |
| basic_blending | 텍스처, 컬러, 라이트를 섞어보자 | basic_blending  |
| basic_blending_textures | 텍스처 두장을 섞어보자 | 5.basic_blending_textures |
| basic_translucent | 반투명한 물체를 만들어보자 |
| basic_cull | 컬링을 적용해 보자 | |
| basic_depth_test | 깊이 테스트를 적용해 보자 | |
| basic_blend | blend command 를 사용해서 블렌딩 하자 | |
| basic_alpha_test | 알파 테스트를 해보자 | |
| basic_vertex_fragment_shader | 버텍스, 프래그먼트 쉐이더를 이용하여 한가지 색으로 칠하자 | |
| basic_stencil_test | 스텐실 테스트를 적용해 보자 | |
| **normal_map** | 노멀맵을 적용해보자 | |
| skymap_reflect | 스카이맵을 물체의 표면에서 반사시켜보자 | |
| skymap_reflect_normal | 스카이맵을 노멀맵과 함께 물체의 표면에서 반사시켜보자 | |
| skymap_reflect_normal_occlusion | 스카이맵을 노멀맵, 오클루젼맵과 함께 물체의 표면에서 반사시켜보자 | |
| checkerboard | 물체의 표면을 체커보드 패턴으로 표현해보자 | |
| triplanar | tri-planar 텍스처 매핑을 해보자 | |
| diffuse | diffuse lighting 을 적용해보자 | |
| diffuse_ambient_lightprobe | diffuse lighting, ambient, light probe 를 적용해보자 | |
| shadow_caster | 그림자를 만들어보자 | |
| shadow_receiver | 그림자를 드리워보자 | |
| fog | 안개를 그려보자 | |

# ToDo

* water
* toon 
* rim light
* bloom
* distortion
* IBL (Image Based Lighting)
* BRDF
* PBR