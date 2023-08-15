%{
+[返回目录]
地址::Matlab\TOPAS\phaseGrating.m
+[保存文本](,光栅色散)

光栅GDD:...
测试:...
+[M函数](,光栅色散)
%}


function [w,phase,GDD]=phaseGrating(a,G,theta_i,lambda0,lambda)
% Grating compressor
%a=1200;
%G=0.2;
%theta_i=10;
%lambda0=800e-9;
%lambda=linspace(200e-9,2000e-9,10000);

physics_constant;
w=wl_transform(lambda,0);
w0=2*pi*c/lambda0;

GDD=GratingGDD(theta_i,lambda0,a,G);

phase=exp(-1i*GDD/2*(w-w0).^2);
%plot(w,phase);

end