%% 20220416
%% from 文档\实验室问题\能谱仪校正.ftxt
%{
Nini, 打开能谱仪设计的动词库(节点)
(参考能谱仪校正的13975场景)
Nini, 打开能谱仪原理(文件)
Nini, 打开能谱仪原理的trajectory_fiducial(节点)
Nini, 打开能谱仪原理的trajectory_uniform(节点)
Nini, 打开能谱仪原理的trajectory_fs(节点)

地址::Matlab\spectrometer\expected_shadows_13975.m
+[保存M函数](,expected_shadows_13975)

spectrometer_para_13975(M函数):...
spectrometer_para_shadow(M函数):...
spectrometer_para_shadow的"spectrometer_para_13975"替换为"spectrometer_para_shadow"

测试(M函数):...
+[新建阅读窗口](,测试)
%}

function [px,px0,energy]=expected_shadows_13975(theta_e,dr_e,dr_m,dr_f1,dr_f2,dr_p,pt0,Dtheta)
addpath('Matlab\spectrometer');
physics_constant;

[Cell,Ma,B0,Fx,Fy,shX,shY,pos_p]=spectrometer_para_13975(dr_e,dr_m,dr_f1,dr_f2,dr_p,pt0,Dtheta);

pos_m=[mean(Ma),0];
siz_m=diff(Ma);

E_f=trajectory_fiducial(Fx,Fy,Cell(1),Cell(2),theta_e,pos_m,siz_m,B0);
E0=E_f;
xe1=Cell(1)*ones(size(E0));
ye1=Cell(2)*ones(size(E0));
theta=theta_e*ones(size(E0));

[x0,y0]=trajectory_uniform(xe1,ye1,theta_e,E0,pos_m,siz_m,B0,pos_p,Dtheta);

X=-sind(Dtheta)*(x0-pos_p(1))+cosd(Dtheta)*(y0-pos_p(2));
%{
+[保存M函数](,expected_shadows_13975)
%}



px0=[4207 4264 4516 4597 4862.15428101106 4961.79896560229 5272.45584655822 5400.23550091639 5808.19261938067 5967.62411472665 6540.87398391396 6764.7814516425];
px0=sort(px0,'descend');

px=4002-X/50e-6;
px=reshape(px,1,numel(px));
px(isnan(px))=[];
px=sort(px,'descend');
px=px(1:length(px0));

energy=reshape(E0,1,numel(E0));
energy=energy(1:length(px0));

end

%{
+[保存文本](,expected_shadows_13975)
%}

