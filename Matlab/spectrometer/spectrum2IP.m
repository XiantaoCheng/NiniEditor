%% 20220417
%% from 文档\物理问题\电子能谱.ftxt
%{
地址::Matlab\spectrometer\spectrum2IP.m
+[保存M函数](,spectrum2IP)

Nini, 打开阴影形状(文件)
%}


function [I,E]=spectrum2IP(E0,S0,t_0,x_o,z_o,B,D,z_m,x_i,z_i)
%addpath('Matlab\paper_spectrometer');
physics_constant;

dx_i=abs(x_i(2)-x_i(1));

N1=length(x_i);

% L=z_i-z_o;
% L_0=z_i-z_m;

% t=t_0;
I=zeros(1,N1);

% dEdt=B*e*c*D*(z_i-z_m)*(z_i-z_o)./(x_i-x_o-t_0*(z_i-z_o)).^2;
dEdx_i=-B*e*c*D*(z_i-z_m)./(x_i-x_o-t_0*(z_i-z_o)).^2;
E=-B*e*c*D*(z_i-z_m)./(x_i-x_o-t_0*(z_i-z_o));
S=interp1(E0,S0,E,'spline');
S(E>max(E0)|E<min(E0))=0;
I0=dEdx_i.*S;
I=abs(I0);

end

%{
+[保存M函数](,spectrum2IP)
%}

