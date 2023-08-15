%{
+[返回目录]
地址::Matlab\TOPAS\phase_m.m
+[保存文本](,材料色散)

测试:...
+[M函数](,材料色散)
%}


function [w,phase,GDD_m]=phase_m(data_lambda,data_GVD,lambda0,lambda,L)
%address='C:\Users\cheng\Desktop\physics\GVD\data.csv';
%data=readtable(address);
%data_lambda=data.Wavelength*1e-9;
%data_GVD=data.Air;

%lambda0=800e-9;
%lambda=linspace(200e-9,2000e-9,10000);
%L=10;

physics_constant;
L=L*1e3;
w=wl_transform(lambda,0);
w0=2*pi*c/lambda0
GVD=interp1(data_lambda,data_GVD,lambda0,'spline');
GDD_m=GVD*L;
GDD_m=GDD_m*1e-30/10;

phase=exp(-1i*GDD_m/2*(w-w0).^2);

end