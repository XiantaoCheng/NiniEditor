%% 20230412
%% from 文档\论文\能谱仪论文.ftxt
%{
+[保存M函数](,read_data_G4BL_IP)
地址::Matlab/tmp/read_data_G4BL_IP.m
测试:...
%}

function [I,X,Y]=read_data_G4BL_IP(file_name,Nx,Ny,area_box)

addpath('Matlab/random')
addpath('Matlab/fitting')

% data=readmatrix('output/spectrometer/GEANT4/G.txt');
data=readmatrix(file_name);

% total
x0=data(:,2);
y0=data(:,3);
E0=sqrt(data(:,4).^2+data(:,5).^2+data(:,6).^2);

% e^-
x0=data(data(:,8)==11,2);
y0=data(data(:,8)==11,3);

[I,X,Y]=show_dist_2D(x0,y0,Nx,Ny,area_box);

end

%{
+[M函数](,shadowList)
%}

