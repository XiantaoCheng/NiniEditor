%% 20221013
%% from 文档\实验室问题\Dazzler优化.ftxt
%{
地址::Matlab\FROG\read_FROG_retrieval.m
+[保存M函数](,read_FROG_retrieval)
%}

function [wavelength,intensity,phase,t,E]=read_FROG_retrieval(file_name,show_)

physics_constant;
% file_name='文档\实验室问题\Dazzler优化\image\Speck.dat';
data=readmatrix(file_name);

lms=[720,900];

wavelength=data(:,1)';
intensity=data(:,2)';
phase=data(:,3)';

%wavelength_0=wavelength;
%intensity_0=intensity;
%phase_0=phase;

intensity(wavelength<lms(1)|wavelength>lms(2))=[];
phase(wavelength<lms(1)|wavelength>lms(2))=[];
wavelength(wavelength<lms(1)|wavelength>lms(2))=[];

lm=wavelength;
I0=intensity;
phi=phase;

% pulse shape
lm_x=lm*1e-9;
w_x=2*pi*c./lm_x;

if length(w_x)~=length(phi)
    phi=zeros(size(w_x));
end

w=linspace(max(w_x)/length(w_x),max(w_x),length(w_x));
In_w=interp1(w_x,I0,w);
phi_w=interp1(w_x,phi,w);

S=sqrt(In_w).*exp(-1i*phi_w);
S(isnan(S))=0;

[t,f]=ifft_k(w,S);
t=t-mean(t);
E=fftshift(f);


if show_
    % image
    subplot(1,2,1)
    yyaxis left
    plot(lm,I0);
    xlabel('Wavelength [nm]')
    ylabel('Intensity [a.u.]')
    
    yyaxis right
    if isempty(phi)
    plot(lm,0);
    else
    plot(lm,phi);
    end
    ylabel('Phase [rad]')
    
    subplot(1,2,2)
    plot(t/1e-15,abs(E).^2)
    xlabel('Delay [fs]')
    ylabel('Intensity [a.u.]')
    axis([-150,150,0,1.2*max(abs(E).^2)])
end

end

%{
+[M函数](,获取FROG图像)
%}

