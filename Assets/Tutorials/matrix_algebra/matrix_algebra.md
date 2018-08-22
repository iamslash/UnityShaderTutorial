# Abstract

행렬대수를 정리한다.

# 행렬 곱셈

+ A의 행과 B의 열을 곱하여 값을 구한다.
+ AxB는 가능하지만 BxA는 가능하지 않다, 그 이유는 곱하려는 행과 열의 개수가 맞아야 하기때문이다.

ex)

![](./Images/1.png)

![](./Images/1-1.png)

![](./Images/1-2.png)

![](./Images/1-3.png)

```
\\A=\begin{bmatrix}
-1 & 5 & -4\\ 
3 & 2 & 1
\end{bmatrix}
B=\begin{bmatrix}
2 & 1 & 0\\ 
0 & -2 & 1\\ 
-1 & 2 & 3
\end{bmatrix}\\
AB=\begin{bmatrix}
-1 & 5 & -4\\ 
3 & 2 & 1
\end{bmatrix}
\begin{bmatrix}
2 & 1 & 0\\ 
0 & -2 & 1\\ 
-1 & 2 & 3
\end{bmatrix}\\
= \begin{bmatrix}
(-1,5,4)\cdot (2,0,-1) & (-1,5,4)\cdot (1,-2,2) & (-1,5,4)\cdot (0,1,3)\\ 
(3,2,1)\cdot (2,0,-1) & (3,2,1)\cdot (1,-2,2) & (3,2,1)\cdot (0,1,3)
\end{bmatrix}\\
= \begin{bmatrix}
2 & -19 & -7\\ 
5 & 1 & 5
\end{bmatrix}
```

```
ex) (-1, 5, -4) x (2, 0, -1)

= -1x2 + 5x0 + -4x-1
= -2 + 0 + 4
= 2
``` 

# 전치행렬

+ 정의 : 행과 열을 교환하여 얻는 행렬이다.
+ 전치 행렬은 'T' or 't'를 사용하여 표시해준다. 

ex)

![](./Images/2.png)

![](./Images/2-1.png)

```
\\A=\begin{bmatrix}
2 & -1 & 8\\ 
3 & 6 & -4
\end{bmatrix}
, B=\begin{bmatrix}
a & b & c\\ 
d & e & f\\ 
g & h & i
\end{bmatrix}
, C=\begin{bmatrix}
1\\ 
2\\ 
3\\ 
4
\end{bmatrix}\\
A^{T}=\begin{bmatrix}
2 & 3\\ 
-1 & 6\\ 
8 & -4
\end{bmatrix}
, B^{T}=\begin{bmatrix}
a & d & g\\ 
b & e & h\\ 
c & f & i
\end{bmatrix}
, C^{T}=\begin{bmatrix}
1 & 2 & 3 & 4
\end{bmatrix}
```

# 단위행렬

+ 정의 : 주대각선을 제외한 모든 원소가 0인 정방행렬(행과 열의 수가 같은 행렬)이다.

![](./Images/3.png)

```
\\\begin{bmatrix}
1 & 0\\ 
0 & 1
\end{bmatrix}
,\begin{bmatrix}
1 & 0 & 0\\ 
0 & 1 & 0\\ 
0 & 0 & 1
\end{bmatrix}
,\begin{bmatrix}
1 & 0 & 0 & 0\\ 
0 & 1 & 0 & 0\\ 
0 & 0 & 1 & 0\\ 
0 & 0 & 0 & 1
\end{bmatrix}
```

+ 단위행렬과 곱셈을 하는 경우 그대로 자신의 행렬로 돌아오는 것을 확인 할 수 있다.

![](./Images/3-1.png)

![](./Images/3-2.png)

![](./Images/3-3.png)

```
\\M=\begin{bmatrix}
1 & 2\\ 
0 & 4
\end{bmatrix}
,I=\begin{bmatrix}
1 & 0\\ 
0 & 1
\end{bmatrix}\\
MI=\begin{bmatrix}
1 & 2\\ 
0 & 4
\end{bmatrix}
\begin{bmatrix}
1 & 0\\ 
0 & 1
\end{bmatrix}
= \begin{bmatrix}
(1,2)\cdot (1,0) & (1,2)\cdot (0,1)\\ 
(0,1)\cdot (1,0) & (0,1)\cdot (2,4)
\end{bmatrix}
=\begin{bmatrix}
1 & 2\\ 
0 & 4
\end{bmatrix}\\
IM=\begin{bmatrix}
1 & 0\\ 
0 & 1
\end{bmatrix}
\begin{bmatrix}
1 & 2\\ 
0 & 4
\end{bmatrix}
= \begin{bmatrix}
(1,0)\cdot (1,0) & (1,0)\cdot (2,4)\\ 
(0,1)\cdot (1,0) & (0,1)\cdot (2,4)
\end{bmatrix}
=\begin{bmatrix}
1 & 2\\ 
0 & 4
\end{bmatrix}
```

# 소행렬식

+ 정의 : n차 행렬식에서 i행과 j열의 원소를 제외한 나머지 행렬.

![](./Images/4.png) 인 행렬에서

원소 ![](./Images/4-1.png)의 소행렬식은
![](./Images/4-2.png) 입니다.

```
\\A=\begin{bmatrix}
3 & 1 & -4\\ 
2 & 5 & 6\\ 
1 & 4 & 8
\end{bmatrix}\\
M_{1}_{1}=\begin{bmatrix}
5 & 6\\ 
4 & 8
\end{bmatrix}
```

# 여인수 행렬

+ 정의 : 소행렬식에 +, - 부호를 붙인 것.

공식

![](./Images/5.png)

```
C_{ij}=(-1)^{i+j}\cdot M_{ij}
```

ex)

![](./Images/5-1.png)

```
C_{11}=(-1)^{1+1}\cdot M_{11}
```

# 행렬식

+ 정의 : 행렬의 원소들을 대입하여 얻은 결과값(수치)을 지칭한다.
+ n x n (n은 2 이상)의 정방행렬을 사용한다.
+ detA11 이란 A에서 1행과 1열을 제외한 행렬의 행렬식을 의미한다.

공식

![](./Images/6.png)

![](./Images/6-1.png)

```
\\detA=\sum_{j=1}^{n}A_{1j}\cdot (-1)^{1+j}\cdot det\bar{A}_{1j}\\
det\begin{bmatrix}
A_{11} & A_{12}\\ 
A_{21} & A_{22}
\end{bmatrix}
= A_{11}\cdot det[A_{22}]-A_{12}\cdot det[A_{21}]
= A_{11}\cdot A_{22}-A_{12}\cdot A_{21}
```

ex)

![](./Images/6-2.png)

![](./Images/6-3.png)

![](./Images/6-4.png)

![](./Images/6-5.png)

```
\\A=\begin{bmatrix}
2 & -5 & 3\\ 
1 & 3 & 4\\ 
-2 & 3 & 7
\end{bmatrix}\\
detA=A_{11}\cdot det\begin{bmatrix}
A_{22} & A_{23}\\ 
A_{32} & A_{33}
\end{bmatrix}
- A_{12}\cdot det\begin{bmatrix}
A_{21} & A_{23}\\ 
A_{31} & A_{33}
\end{bmatrix}
+ A_{13}\cdot det\begin{bmatrix}
A_{21} & A_{22}\\ 
A_{31} & A_{32}
\end{bmatrix}\\
detA=2\cdot \begin{bmatrix}
3 & 4\\ 
3 & 7
\end{bmatrix}
-(-5)\cdot \begin{bmatrix}
1 & 4\\ 
-2 & 7
\end{bmatrix}
+ 3\cdot \begin{bmatrix}
1 & 3\\ 
-2 & 3
\end{bmatrix}\\
=2\cdot (3\cdot7 - 4\cdot3)+5\cdot(1\cdot 7 - 4\cdot (-2)) + 3\cdot (1\cdot 3 - 3\cdot (-2))\\
=2\cdot (9) + 5\cdot (15) + 3\cdot (9)\\
=18 + 75 + 27\\
=120
```

```
= A11 x (-1)(1+1) // (1+1) = 제곱이 짝수이므로 +가 된다 
  x det A11 + 
  A12 x (-1)(1+2) // (1+3) = 제곱이 홀수이므로 -가 된다.
  x det A12 ...
= A11 x det A11 -A12 x det A12 .. 
```

# 딸림행렬 (= 수반행렬)

+ 정의 : n차 정방행렬 A에 대해 A의 여인수 행렬의 전치행렬이라 의미하고, adjA라 표기한다.

![](./Images/7.png)

```
\\A=\begin{bmatrix}
1 & 2 & 5\\ 
2 & 3 & 7\\ 
1 & 5 & 6
\end{bmatrix}\\
adjA=\begin{bmatrix}
+\begin{bmatrix}
3 & 7\\ 
5 & 6
\end{bmatrix} & -\begin{bmatrix}
2 & 7\\ 
1 & 6
\end{bmatrix} & +\begin{bmatrix}
2 & 3\\ 
1 & 5
\end{bmatrix}\\ 
-\begin{bmatrix}
2 & 5\\ 
5 & 6
\end{bmatrix} & +\begin{bmatrix}
1 & 5\\ 
1 & 6
\end{bmatrix} & -\begin{bmatrix}
1 & 2\\ 
1 & 5
\end{bmatrix}\\ 
+\begin{bmatrix}
2 & 5\\ 
3 & 7
\end{bmatrix} & -\begin{bmatrix}
1 & 5\\ 
2 & 7
\end{bmatrix} & +\begin{bmatrix}
1 & 2\\ 
2 & 3
\end{bmatrix}
\end{bmatrix}^{T}\\
=\begin{bmatrix}
-17 & -5 & 7\\ 
13 & 1 & -3\\ 
-1 & 3 & 1
\end{bmatrix}^{T}
=\begin{bmatrix}
-17 & 13 & -1\\ 
-5 & 1 & 3\\ 
7 & -3 & 1
\end{bmatrix}
```

# 역행렬

+ 정의 : 곱하였을때 단위행렬이 나오게하는 행렬을 의미한다.
+ 행렬식과 딸림행렬을 이용하여 역행렬을 구할 수 있다.

공식

![](./Images/8.png)

```
A^{-1}=\left ( \frac{1}{detA} \right )\cdot adjA
```

ex)

![](./Images/8-1.png)

![](./Images/8-2.png)

![](./Images/8-3.png)

![](./Images/8-4.png)

```
\\A=\begin{bmatrix}
2 & 2 & 0\\ 
-2 & 1 & 1\\ 
3 & 0 & 1
\end{bmatrix}\\
detA=A_{11}\cdot det\begin{bmatrix}
A_{22} & A_{23}\\ 
A_{32} & A_{33}
\end{bmatrix}
-A_{12}\cdot \begin{bmatrix}
A_{21} & A_{23}\\ 
A_{31} & A_{33}
\end{bmatrix}
+A_{13}\cdot det\begin{bmatrix}
A_{21} & A_{22}\\ 
A_{31} & A_{32}
\end{bmatrix}\\
=2\cdot \begin{bmatrix}
1 & 1\\ 
0 & 1
\end{bmatrix}
-2\cdot \begin{bmatrix}
-2 & 1\\ 
3 & 1
\end{bmatrix}
+0\cdot \begin{bmatrix}
-2 & 1\\ 
3 & 0
\end{bmatrix}\\
=2\cdot (1-0) - 2\cdot (-2-3) + 0\\
=2 - 2\cdot (-5) = 12\\
adjA=\begin{bmatrix}
+\begin{bmatrix}
1 & 1\\ 
0 & 1
\end{bmatrix} & -\begin{bmatrix}
-2 & 1\\ 
3 & 1
\end{bmatrix} & +\begin{bmatrix}
-2 & 1\\ 
3 & 0
\end{bmatrix}\\ 
-\begin{bmatrix}
2 & 0\\ 
0 & 1
\end{bmatrix} & +\begin{bmatrix}
2 & 0\\ 
3 & 1
\end{bmatrix} & -\begin{bmatrix}
2 & 2\\ 
3 & 0
\end{bmatrix}\\ 
+\begin{bmatrix}
2 & 0\\ 
1 & 1
\end{bmatrix} & -\begin{bmatrix}
2 & 0\\ 
-2 & 1
\end{bmatrix} & +\begin{bmatrix}
2 & 2\\ 
-2 & 1
\end{bmatrix}
\end{bmatrix}^{T}\\
\begin{bmatrix}
+(1-0) & -(-2-3) & +(0-3)\\ 
-(2-0) & +(2-0) & -(0-6)\\ 
+(2-0) & -(2-0) & +(2+4)
\end{bmatrix}^{T}\\
=\begin{bmatrix}
1 & 5 & -3\\ 
-2 & 2 & 6\\ 
2 & -2 & 6
\end{bmatrix}\\
A^{-1}=\left ( \frac{1}{12} \right )\cdot \begin{bmatrix}
1 & -2 & 2\\ 
5 & 2 & -2\\ 
-3 & 6 & 6
\end{bmatrix}\\
=\begin{bmatrix}
\frac{1}{12} & -\frac{1}{6} & \frac{1}{6}\\ 
\frac{5}{12} & \frac{1}{6} & -\frac{1}{6}\\ 
-\frac{1}{4} & \frac{1}{2} & \frac{1}{2}
\end{bmatrix}
```
