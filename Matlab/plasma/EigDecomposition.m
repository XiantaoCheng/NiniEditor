%% 20220809
%% from 文档\物理问题\plasma.ftxt
%{
地址::Matlab\plasma\EigDecomposition.m
+[保存M函数](,EigDecomposition)
E1'*E2
%}


function [A1,A2]=EigDecomposition(E,E1,E2)

E=reshape(E,3,1);
E1=reshape(E1,3,1);
E2=reshape(E2,3,1);

A1=E1'*E;
A2=E2'*E;
end

