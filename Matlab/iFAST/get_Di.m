%% 20220615
%% from 文档\实验室信息\iFAST_log2.ftxt
%{
地址::Matlab\iFAST\get_Di.m
+[保存M函数](,get_Di)
%}

function [i1,i2]=get_Di(i0,Di,n1,n2)

i1=max(i0-Di,n1);
i2=min(i0+Di,n2);

end




