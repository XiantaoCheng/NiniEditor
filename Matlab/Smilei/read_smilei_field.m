%% 20220824
%% from 文档\模拟\Smilei源码分析.ftxt
%{
地址::Matlab\Smilei\read_smilei_field.m
+[保存M函数](,read_smilei_field)
%}

function a=read_smilei_field(fileName,ratio)
% fileName='文档\\模拟\\Smilei\\code\\20220824\\1_0_1e_8.mat';
result=load(fileName);
a=result.result*ratio;

end






