%% 20220828
%% from 文档\S应用\词典.ftxt
%{
创建"Matlab\dataVis"
地址::Matlab\dataVis\fig_data_2D.m
+[保存M函数](,fig_data_2D)
%}

function [f,x]=fig_data_2D(n)

data=get(gca(n),'Children');
x=double(data(end).XData);
f=double(data(end).YData);

end






