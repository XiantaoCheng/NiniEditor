%% 20230410
%% from 文档\论文\能谱仪论文.ftxt
%{
地址::Matlab/tmp/read_data_G4BL.m
+[保存M函数](,read_data_G4BL)
%}

function [x2,i2,f2,D2]=read_data_G4BL(file_name)
addpath('Matlab/random')
addpath('Matlab/fitting')

data1=readmatrix(file_name);

% e^-
Px2=data1(data1(:,8)==11,4);
Py2=data1(data1(:,8)==11,5);
Pz2=data1(data1(:,8)==11,6);
tx2=Py2./Px2;
ty2=Pz2./Px2;
n2=numel(Px2);

tx_min=-5*std(tx2(Px2>mean(Px2)));
tx_max=5*std(tx2(Px2>mean(Px2)));


x2=linspace(tx_min,tx_max,100);
i2=histc(tx2,x2)';
i2=i2/trapz(x2,i2);
[f2,D2]=Gaussian_fitting(x2,i2,100);

end





%{
+[M函数](,highEnergyShadow)
%}

