
本学习教程内容主要来自互联网，个人学习记录，仅供参考。<br>
代码仓库[DFTplusU-Parameter-Calculation@cndaqiang](https://github.com/cndaqiang/DFTplusU-Parameter-Calculation)





## 参考
[Examples of using DFT+U with Quantum Espresso package.](https://www.slideshare.net/BurakHimmetoglu/exercises-with-dftu)



## 计算流程
### 传统方式
1. `scf+U0`计算`PBEU_0` :`PBEU_0`
2. `scf+U0.1`计算`PBEU_0.1` :`PBEU_0.1`
3. `scf+U0`=>`nscf+U0.1` :`PBEU_0_nscf0.1`

注+U0.1的方式, 参数`Hubbard_U(1)`或`Hubbard_alpha(1)`取0.1都可以,进行的计算是一样的,即下面两种参数效果相同
```
    Hubbard_U(1) = 1.d-10
    Hubbard_alpha(1) = 0.1
#or
    Hubbard_U(1) = 0.1
    Hubbard_alpha(1) = 0.0
```

由于QE本身的nscf计算不会输出计算后的波函数(nscf+U)对应的原子轨道占据情况,此处使用我的脚本`pw2udm.x`处理nscf的结果,将原子占据情况输出的到udm.result如下
处理结果
```
(python37) [SSLAB2 cndaqiang@login001 test_NiO]$ls
input  PBEU_0  PBEU_0.1  PBEU_0_nscf0.1  VO
(python37) [SSLAB2 cndaqiang@login001 test_NiO]$grep 'Tr' PBEU_0/result | grep 'atom    1' | tail -1
atom    1   Tr[ns(na)] (up, down, total) =   4.95331  3.64051  8.59382
(python37) [SSLAB2 cndaqiang@login001 test_NiO]$grep 'Tr' PBEU_0.1/result | grep 'atom    1' | tail -1
atom    1   Tr[ns(na)] (up, down, total) =   4.95344  3.63131  8.58475
(python37) [SSLAB2 cndaqiang@login001 test_NiO]$grep 'Tr' PBEU_0_nscf0.1/result | grep 'atom    1' | tail -1
atom    1   Tr[ns(na)] (up, down, total) =   4.95331  3.64051  8.59382
(python37) [SSLAB2 cndaqiang@login001 test_NiO]$grep 'Tr' PBEU_0_nscf0.1/udm.result | grep 'atom    1' | tail -1
atom    1   Tr[ns(na)] (up, down, total) =   4.95156  3.62356  8.57512
(python37) [SSLAB2 cndaqiang@login001 test_NiO]$cal.py '0.1/(8.57512-8.59382)-0.1/(8.58475-8.59382)'
expr       	 =  value
0.1/(8.57512-8.59382)-0.1/(8.58475-8.59382) 	 =  5.67776474125821
```

这里我用的模守恒赝势, 得到NiO中Ni的U值为5.68eV.和VASP的[5.58eV](https://www.vasp.at/wiki/index.php/Calculate_U_for_LSDA%2BU)接近,反而和参考的QE教程(PAW赝势)的[~4.0eV](https://www.slideshare.net/BurakHimmetoglu/exercises-with-dftu)有差别.
仅对Ni+U(5.68eV)得到gap=2.87eV

### 优化一下
如果读入scf+U0的结果进行计算scf+U0.1,则第一个scf步输出的就是nscf的计算结果,我们只要设置第一步对角化的精度足够高就可以.这样第一步的结果输出的电荷占据就当作nscf的结果.最终计算结果是scf+U0.1的结果,如下
```
(python37) [SSLAB2 cndaqiang@login001 test_NiO]$grep 'Tr' PBEU_0.1_diago_thr_init/result | grep 'atom    1' | tail -1
atom    1   Tr[ns(na)] (up, down, total) =   4.95344  3.63130  8.58474
(python37) [SSLAB2 cndaqiang@login001 test_NiO]$grep 'Tr' PBEU_0.1_diago_thr_init/result | grep 'atom    1' | head -2 | tail -1
atom    1   Tr[ns(na)] (up, down, total) =   4.95155  3.62357  8.57512
```
