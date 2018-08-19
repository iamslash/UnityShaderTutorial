# Abstract

Unity3d 의 rendering pipeline 을 정리한다.

# Materials

* [Optimizing graphics rendering in Unity games @ unity](https://unity3d.com/kr/learn/tutorials/temas/performance-optimization/optimizing-graphics-rendering-unity-games?playlist=44069)
* [21 - Rendering Pipeline (Shaderdev.com) @ youtube](https://www.youtube.com/watch?v=qHpKfrkpt4c)
* [cg tutorial, Chapter 1. Introduction @ nvidia](http://developer.download.nvidia.com/CgTutorial/cg_tutorial_chapter01.html)

# Overview

![](http://developer.download.nvidia.com/CgTutorial/elementLinks/fig1_7.jpg)

![](http://developer.download.nvidia.com/CgTutorial/elementLinks/fig1_5.jpg)

# Command Buffer

CPU 는 GPU 에게 여러 command 들을 하나의 batch 로 묶어서 command buffer 를 통해 전송한다. command 의 종류는 SetPass call 과 Draw call 등으로 나눌 수 있다. 

SetPass call 은 render-state 을 설정한다. Draw call 은 설정된 render-state 으로 오브젝트를 렌더링 한다. CPU 입장에서 SetPass call 은 Draw call 에 비해 비용이 크다. 예를 들어 RAM 에 저장된 Vertex Buffer 는 VRAM 에 그대로 복사되야 하는데 이와 같이 비용이 큰 작업은 SetPass call 에서 실행된다.

# Batching

여러 개의 Draw call 은 여러 개의 batch 를 만들어 낸다. 만약 이 것들을 하나의 Draw call 으로 줄일 수 있다면 결국 여러개의 batch 들을 하나의 batch 로 줄이게 된다. 이러한 행위를 batching 이라고 한다.