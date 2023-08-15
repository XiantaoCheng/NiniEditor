%{
+[返回目录](,模式分解)
地址::Matlab\Physics\EigDecomposition.m

+[保存文本](,模式分解)
显示偏振态:...
+[M函数](,模式分解)
%}

function A=EigDecomposition(E,mode)
%mode=[1,1i;
%      1i,1]/sqrt(2);
%E=[1;1i];

E1=reshape(E,2,1);
A=mode'*E1;
A=reshape(A,size(E));
%mode*A
end