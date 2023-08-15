%% 20230406
%% from 文档\实验室问题\PIConGPU.ftxt
%{
运行指令"mkdir Matlab/tmp"
地址::Matlab/tmp/read_data_PIC_PNG.m
+[保存M函数](,read_data_PIC_PNG)

测试:...
%}

function [I_1,I_2,I_3]=read_data_PIC_PNG(folder_name,i)
% i=70
% dt=1.39e-16;
% dx=4.43e-8;

folder_address=sprintf("/home/xiantao/Documents/sim_output/results/%s/pngElectronsYX",folder_name);

files=dir(sprintf("%s/*.png",folder_address));

file_name=sprintf("%s/%s",folder_address,files(i).name);
data=double(imread(file_name));
I_1=data(:,:,1);
I_2=data(:,:,2);
I_3=data(:,:,3);
% x=(1:size(data,2))*dx;

end

%{
clf
+[M函数](,一维分布)
%}

