%% 20230211
%% from 文档\物理问题\静电场.ftxt
%{
地址::Matlab/SEM/Einzel_lens_phi_3D.m
+[保存M函数](,Einzel_lens_phi_3D)

Nini, 打开人体模型的Local_coordinates_pts_Eulers(节点)

+[命令行]"tree 文档/S应用"
+[命令行]"tree 文档/物理问题"
+[命令行]"tree 文档/数学问题"
+[命令行]"tree Matlab"
%}

function u=Einzel_lens_phi_3D(x,y,z,pt,Eulers,U0,H,R0,R1)

% addpath('Matlab\space');
addpath('Matlab/space');

[xo,yo,zo]=Local_coordinates(x,y,z,pt,Eulers);
ro=sqrt(xo.^2+yo.^2);
varphi=Einzel_lens_phi(U0,H,R0,R1);

u=varphi(ro,zo);

end

%{
+[保存M函数](,Einzel_lens_phi_3D)
%}

