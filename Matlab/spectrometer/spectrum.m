%% 20220417
%% from 文档\物理问题\电子能谱.ftxt
%{
+[M函数](,spectrum)

spectrum_x(M函数):...
spectrum2IP(M函数):...
+[新建阅读窗口](,spectrum2IP)

地址::Matlab\spectrometer\spectrum.m
+[保存M函数](,spectrum)

互逆测试(M函数):...
轨迹测试(M函数):...
+[新建阅读窗口](,互逆测试)

测试(M函数):...
+[新建阅读窗口](,测试)
spectrum1(M函数):...
spectrum2(M函数):...
(曲线轨迹的能谱, 里面和折线轨迹做了对比)

Nini, 打开能谱仪原理的u_substitution(节点)
%}
%% function [S,E_x,p_x,dE_x,I]=spectrum(data,bd_0,bd_1,pos_s,theta_e,pos_m0,siz_m0,B,pos_p0,theta_p0,dx)

function [S,E]=spectrum(data,E_x,t_0,x_o,z_o,B,D,z_m,x_i,z_i)

physics_constant;
E=-B*e*c*D*(z_i-z_m)./(x_i-x_o-t_0*(z_i-z_o));
S=u_substitution(x_i,data,x_i,E,E_x);

end


%{
+[保存M函数](,spectrum)
%}

