%{
+[返回目录](,测量波长)
+[M函数](,测量波长)

地址::Matlab\FDTD\measure_wavelength.m
+[保存文本](,测量波长)
%}

function [lm,nlModel]=measure_wavelength(x,y0,lm0)

physics_constant;
% y0=Ex(3:end);
% x=x_E(3:end);

p0=zeros(1,3);
p0(1)=max(y0);
p0(2)=2*pi/lm0;
p0(3)=acos(y0(1)/p0(1));
modelFun = @(p,x) p(1)*cos(p(2)*x+p(3));
nlModel=fitnlm(x,y0,modelFun,p0);
p=nlModel.Coefficients.Estimate;

% plot(x_E,Ex,x_E',predict(nlModel,x_E'),'--')
lm=2*pi/p(2);

end

%{
+[M函数](,测量波长)
%}