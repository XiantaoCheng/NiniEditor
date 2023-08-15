%% 20220824
%% from 文档\模拟\Smilei源码分析.ftxt
%{
地址::Matlab\Smilei\read_smilei_track.m
+[保存M函数](,read_smilei_track)
%}

function [a,x,py,pz]=read_smilei_track(fileName)
% fileName='文档\\模拟\\Smilei\\code\\20220824\\1_0_1e_8.mat';
result=load(fileName);
a=result.result;

x=a{1}.x;
py=a{1}.py;
pz=a{1}.pz;

end






