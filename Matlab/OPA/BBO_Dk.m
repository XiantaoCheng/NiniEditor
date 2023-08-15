%{
地址::Matlab\OPA\BBO_Dk.m
+[保存文本](,BBO_Dk)
测试:...
%}

function [Dk,k1,k2,k3,E1,E2,E3]=BBO_Dk(lm1,lm2,lm3,beta,BBO_type)
%addpath('Matlab\OPA');
physics_constant;

% lm1=800e-9;
% lm2=1400e-9;
% beta=20;
% BBO_type='eoo';
% lm3=1/(1/lm1-1/lm2);

k=[sind(beta),0,cosd(beta)];
if strcmp(BBO_type(1),'e')
    [~,n1,~,E1]=n_bbo2(lm1,k);
else
    [n1,~,E1,~]=n_bbo2(lm1,k);
end

if strcmp(BBO_type(2),'e')
    [~,n2,~,E2]=n_bbo2(lm2,k);
else
    [n2,~,E2,~]=n_bbo2(lm2,k);
end

if strcmp(BBO_type(3),'e')
    [~,n3,~,E3]=n_bbo2(lm3,k);
else
    [n3,~,E3,~]=n_bbo2(lm3,k);
end

k1=2*pi*n1/lm1;
k2=2*pi*n2/lm2;
k3=2*pi*n3/lm3;

Dk=2*pi*(n1./lm1-n2./lm2-n3./lm3);

end


%{
+[M函数](,折射率椭圆)
%}