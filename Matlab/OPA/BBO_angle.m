%{
地址::Matlab\OPA\BBO_angle.m
+[保存文本](,BBO_angle)

测试:...
%}

function beta0=BBO_angle(lm1,lm2,BBO_type)
addpath('Matlab\funcs');
addpath('Matlab\OPA');
physics_constant;

% lm1=800e-9;
% lm2=1400e-9;
lm3=1/(1/lm1-1/lm2);

f=@(beta)BBO_Dk(lm1,lm2,lm3,beta,BBO_type);
beta0=func_zero(f,0,90,20);

end



%{
+[M函数](,折射率椭圆)
%}