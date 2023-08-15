%% 20220416
%% from 文档\实验室问题\能谱仪校正.ftxt
%{
地址::Matlab\spectrometer\DesignTool2.m
+[保存M函数](,DesignTool2)
Nini, 打开能谱仪原理的trajectory_fs(节点)
%}


function [a,Fn,e,theta,energy]=DesignTool2(Cell,Ma,B0,Fx,Fy,shX,shY)
addpath('Matlab\spectrometer');

e=1.602e-19;
c=2.999e8;
me=9.109e-31;
physics_constant;



Ma1=Ma(1);
Ma2=Ma(2);


%shY=(shadow-2000)*1e-4-dy(1);
%shX=IP*ones(size(shadow));


Theta=zeros(length(shY),numel(Fx));
E=zeros(length(shY),numel(Fx));
    
for i=1:length(shY)

    Sx=shX(i)*ones(size(Fx));
    Sy=shY(i)*ones(size(Fx));

    zs=reshape(Sx,[1,numel(Fx)]);
    xs=reshape(Sy,[1,numel(Fy)]);
    zf=reshape(Fx,[1,numel(Fx)]);
    xf=reshape(Fy,[1,numel(Fy)]);
    zm=(Ma1+Ma2)/2;
    D=abs(Ma1-Ma2);
    zo=Cell(1);
    xo=Cell(2);

    [energy,theta]=trajectory_fs(zo,xo,zm,D,B0,zf,xf,zs,xs);

    E(i,:)=energy/e/1e9;
    Theta(i,:)=theta;
end
Theta=Theta';
E=E';

theta=Theta;
energy=E;

the=abs(theta);
the(energy>25)=inf;

a=theta(the==min(the));
e=energy(the==min(the));
[Fn,~]=find(theta==a');


end

