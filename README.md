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

| name | description |
|:-----|:------------|
| [unity3d_rendering_pipeline](/unity3d_rendering_pipeline.md) | Unity3d 의 Rendering Pipeline 을 이해하자 |
| [basic_red](/Assets/Tutorials/basic_red/basic_red.md) | 물체를 빨간색으로 칠해보자 |
| [vector_algebra](/Assets/Tutorials/vector_algebra/vector_algebra.md) | 벡터대수 |
| [matrix_algebra](/Assets/Tutorials/matrix_algebra/matrix_algebra.md) | 행렬대수 |
| [transformations](/Assets/Tutorials/transformations/transformations.md) | 변환 |
| [**basic_light**](/Assets/Tutorials/basic_light/basic_light.md) | 라이트를 켜보자 |
| [basic_properties](/Assets/Tutorials/basic_properties/basic_properties.md) | 프라퍼티를 사용해보자 |
| [basic_texture](/Assets/Tutorials/basic_texture/basic_texture.md) | 텍스처를 사용해보자 |
| [basic_blending](/Assets/Tutorials/basic_blending/basic_blending.md) | 텍스처, 컬러, 라이트를 섞어보자 |
| [basic_blending_textures](/Assets/Tutorials/basic_blending_textures/basic_blending_textures.md) | 텍스처 두장을 섞어보자 |
| [basic_translucent](/Assets/Tutorials/basic_translucent/basic_translucent.md) | 반투명한 물체를 만들어보자 |
| [basic_cull](/Assets/Tutorials/basic_cull/basic_cull.md) | 컬링을 적용해 보자 |
| [**basic_depth_test**](/Assets/Tutorials/basic_depth_test/basic_depth_test.md) | 깊이 테스트를 적용해 보자 |
| [basic_blend](/Assets/Tutorials/basic_blend/basic_blend.md) | blend command 를 사용해서 블렌딩 하자 |
| [basic_alpha_test](/Assets/Tutorials/basic_alpha_test/basic_alpha_test.md) | 알파 테스트를 해보자 |
| [**basic_vertex_fragment_shader**](/Assets/Tutorials/basic_vertex_fragment_shader/basic_vertex_fragment_shader.md) | 버텍스, 프래그먼트 쉐이더를 이용하여 한가지 색으로 칠하고 좌표변환을 이해하자 |
| [multiple_shader_program_variants](/Assets/Tutorials/multiple_shader_program_variants/multiple_shader_program_variants.md) | `#pragma multi_compile` 와 `#pragma shader_feature` 의 사용법을 이해하자 |
| [basic_stencil_test](/Assets/Tutorials/basic_stencil_test/basic_stencil_test.md) | 스텐실 테스트를 적용해 보자 |
| [texture](/Assets/Tutorials/texture/texture.md) | 텍스처를 적용해 보자 |
| [**normal_map**](/Assets/Tutorials/normal_map/normal_map.md) | 노멀맵을 적용해보자 |
| [skymap_reflect](/Assets/Tutorials/skymap_reflect/skymap_reflect.md) | 스카이맵을 물체의 표면에서 반사시켜보자 |
| [skymap_reflect_normal](/Assets/Tutorials/skymap_reflect_normal/skymap_reflect_normal.md) | 스카이맵을 노멀맵과 함께 물체의 표면에서 반사시켜보자 |
| [skymap_reflect_normal_occlusion](/Assets/Tutorials/skymap_reflect_normal_occlusion/skymap_reflect_normal_occlusion.md) | 스카이맵을 노멀맵, 오클루젼맵과 함께 물체의 표면에서 반사시켜보자 |
| [checkerboard](/Assets/Tutorials/checkerboard/checkerboard.md) | 물체의 표면을 체커보드 패턴으로 표현해보자 |
| [triplanar](/Assets/Tutorials/triplanar/triplanar.md) | tri-planar 텍스처 매핑을 해보자 |
| [diffuse](/Assets/Tutorials/diffuse/diffuse.md) | diffuse lighting 을 적용해보자 |
| [diffuse_ambient_lightprobe](/Assets/Tutorials/diffuse_ambient_lightprobe/diffuse_ambient_lightprobe.md) | diffuse lighting, ambient, light probe 를 적용해보자 |
| [shadow_caster](/Assets/Tutorials/shadow_caster/shadow_caster.md) | 그림자를 만들어보자 |
| shadow_receiver | 그림자를 드리워보자 |
| [fog](/Assets/Tutorials/fog/fog.md) | 안개를 그려보자 |
| [surface_shader_simple](/Assets/Tutorials/surface_shader_simple/surface_shader_simple.md) | 서피스 쉐이더를 이용하여 한가지 색으로 칠하자 |
| [surface_shader_texture](/Assets/Tutorials/surface_shader_texture/surface_shader_texture.md) | 서피스 쉐이더를 이용하여 텍스처를 적용해 보자 |
| [surface_shader_normal_mapping](/Assets/Tutorials/surface_shader_normal_mapping/surface_shader_normal_mapping.md) | 서피스 쉐이더를 이용하여 노말맵을 적용해보자 |
| surface_shader_rim_lighting | |
| [surface_shader_detail_texture](/Assets/Tutorials/surface_shader_detail_texture/surface_shader_detail_texture.md) | 서피스 쉐이더를 이용하여 디테일 텍스처를 적용해 보자 |
| surface_shader_detail_texture_in_screen_space | |
| [surface_shader_cubemap_reflection](/Assets/Tutorials/surface_shader_cubemap_reflection/surface_shader_cubemap_reflection.md) | |
| [surface_shader_slices](/Assets/Tutorials/surface_shader_slices/surface_shader_slices.md) | 서피스 쉐이더를 이용하여 물체를 잘라보자 |
| surface_shader_normal_extrusion | |
| [surface_shader_custom_data_computed_per_vertex](/Assets/Tutorials/surface_shader_custom_data_computed_per_vertex/surface_shader_custom_data_computed_per_vertex.md) | |
| surface_shader_final_color_mod | |
| [surface_shader_custom_fog](/Assets/Tutorials/surface_shader_custom_fog/surface_shader_custom_fog.md) | |
| surface_shader_linear_fog | |
| [surface_shader_decals](/Assets/Tutorials/surface_shader_decals/surface_shader_decals.md) | |
| [outline](/Assets/Tutorials/outline/outline.md) | 외곽선을 적용해보자 |
| ramp with slider|  ramp 을 적용해보자 |
| ramp with texture | ramp 을 적용해보자 |
| blinn-phong specular | |
| anisotropic specular |  |
| matcap | 돌, 얼음, 투명, 구리 를 구현해보자 |
| surface scattering | |
| hand painted | |
| sketch | |
| random tiling | |
| x-ray | |
| dissolve | 물체가 점점 사라지게 해보자. | 
| outline with normal | |
| snow | |
| rimlight | rim light 을 적용해보자 |
| pbr |  |
| water |  |
