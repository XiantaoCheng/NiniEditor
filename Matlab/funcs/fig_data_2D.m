%% 20220826
%% from 文档\S应用\词典.ftxt
%{
地址::Matlab\funcs\fig_data_2D.m
+[保存M函数](,fig_data_2D)
%}

function [f,x]=fig_data_2D(n)

data=get(gca(2),'Children');
x=data(end).XData;
f=data(end).YData;

end






