%{
地址::Matlab\paper_spectrometer\scattering_angle.m
+[保存文本](,scattering_angle)
%}


function [A,s]=scattering_angle(Ex,E_data,D_data)
% E--MeV, sigma--rad
E=E_data;
sigma=D_data;

x0=1./E;
y0=sigma;
A=polyfit(x0,y0,3);

s=A(4)+A(3)./Ex+A(2)./Ex.^2+A(1)./Ex.^3;
end

