%{

地址::Matlab\optics\tilt.m
+[保存文本](,tilt)
%}



function[uout]=tilt(uin,L,lambda,alpha,theta) 
% tilt phasefront 
% uniform sampling assumed 
% uin - input field 
% L - side length 
% lambda - wavelength 
% alpha - tilt angle 
% theta - rotation angle (x axis 0) 



% uout - output field 

[M,N]=size(uin);
%get input field array size 
dx=L/M;
%sample interval 
k=2*pi/lambda;
%wavenumber 

x=-L/2:dx:L/2-dx;
%coords 
[X,Y]=meshgrid(x,x);


uout=uin.*exp(j*k*(X*cos(theta)+Y*sin(theta))... 
*tan(alpha));
%apply tilt 
end 