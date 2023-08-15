%{
地址::Matlab\TOPAS\BBO_index.m
+[保存文本](,BBO_index.m)
依据公式:...
+[网页](web,依据公式)
%}

function [n1,n2,n_o,n_e]=BBO_index(lambda_0,k)
%lambda_0=0.266;
%k=[0,1,0];
lambda_0=lambda_0/1e-6;

n_o=sqrt(2.7359+0.01878/(lambda_0^2-0.01822)-0.01354*lambda_0^2);
n_e=sqrt(2.3753+0.01224/(lambda_0^2-0.01667)-0.01516*lambda_0^2);

k=k/norm(k);

n1=n_o;
n2=1/sqrt((k(1)^2+k(2)^2)/n_e^2+k(3)^2/n_o^2);

end