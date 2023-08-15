%% 20221010
%% from 文档\数学问题\傅里叶变换.ftxt
%{
+[保存M函数](,spatial_phase)
地址::Matlab\fft\spatial_phase.m
测试:...
%}

function [Ey_ph,Ey_x]=spatial_phase(field_y)

Ey_w=fft(field_y);
N=length(Ey_w);
x=1:N;

if size(field_y,1)==1
    Ey_w(x<=N/2)=0;
elseif size(field_y,2)==1
    Ey_w(x<=N/2)=0;
else
    Ey_w(x<=N/2,:)=0;
end

Ey_x=ifft(Ey_w);

Ey_ph=sign_1(imag(Ey_x)).*acos(real(Ey_x)./abs(Ey_x));

% subplot(2,1,1)
% plot(x,real(Ey_x)*2,x,field_y,'--')
% subplot(2,1,2)
% plot(x,Ey_ph)

end

%{
+[M函数](,空间相位)
%}

