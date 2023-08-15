%% 20230223
%% from 文档\实验室信息\UT3日志.ftxt
%{
地址::Matlab/UT3/read_G4_radiation_2D.m
+[保存M函数](,read_G4_radiation_2D)
%}

function [I1,X1,Y1,E1]=read_G4_radiation_2D(file_name,axis_type)
physics_constant;
addpath('Matlab/random')

data1=readmatrix(file_name);
% all
if axis_type(1)=='x'
    x1=data1(:,1);
elseif axis_type(1)=='y'
    x1=data1(:,2);
else
    x1=data1(:,3);
end

if axis_type(2)=='x'
    y1=data1(:,1);
elseif axis_type(2)=='y'
    y1=data1(:,2);
else
    y1=data1(:,3);
end
De=data1(:,13);

range1=[min(x1),max(x1),min(y1),max(y1)];
DX1=max(x1)-min(x1);
DY1=max(y1)-min(y1);
[E,X1,Y1]=dist_2D_val(x1,y1,De,300,300,range1);
E1=E;
I1=E1/(DX1/299)/(DY1/299)/1e-3/1e-3;

end


