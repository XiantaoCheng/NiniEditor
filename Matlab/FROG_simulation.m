%% 20230117
%% from 文档\物理问题\FROG.ftxt
%{
+[M函数](,验证公式)
记住"Matlab"
Nini, 打开词典的条目(节点)
地址::Matlab\FROG_simulation.m
+[保存M函数](,验证公式)

pulse_shift(M函数):...
FROG_In(M函数):...
FROG_trace(M函数):...
+[新建阅读窗口](,FROG_trace)
+[新建阅读窗口](,FROG_In)
+[新建阅读窗口](,pulse_shift)

测试FROG_trace:...
空间色散:...
光栅FROG:...
光栅和空间色散:...

保存:...
%}

addpath('Matlab\FROG')
addpath('Matlab\optics')

physics_constant;
Dt=40e-15;
lm0=800e-9;
Dlm=20e-9;
lm_chirp=30e-9;

% Grating pair
angle_0=47.28;
angle=47.28;
D_0=0.67;
D=0.670-1.5e-3;
G=1450;

%{
20*Dt
+[M函数](,验证公式)
%}

% tau=linspace(-40*Dt,40*Dt,100);
tau=linspace(-800e-15,800e-15,200);
t0=linspace(-40*Dt,40*Dt,5000);
lm=linspace(lm0-Dlm,lm0+Dlm,1000)/2;

lms=linspace(-1,1,length(tau))*lm_chirp;

% spectrum
w0=2*pi*c/lm0;
E0=exp(-t0.^2/Dt^2).*exp(1i*w0*t0);
[w0,f_E0]=fft_x(t0,E0);
lm_x=2*pi*c./w0;
I0_S=abs(f_E0).^2;

% pulse shape
w=linspace(max(w0)/length(w0),max(w0),length(w0));
f_E=interp1(w0,f_E0,w);
f_E(isnan(f_E))=0;
phase_G=grating_compressor_phase(w,D,angle,D_0,angle_0,G);
S=f_E.*exp(-1i*phase_G);
[t1,f1]=ifft_k(w,S);
E1=f1;
I1=abs(f1).^2;
t1=t1-t1(I1==max(I1));

%{
plot(lm_x/1e-9,real(phase_G),lm_x/1e-9,imag(phase_G))
axis([700,900,-80,2000])
+[M函数](,验证公式)
%}


% FROG_trace
FROG_tr=zeros(size(tau,2),size(lm,2));

for i=1:length(tau)
w0=2*pi*c/(lm0+lms(i));
E0=exp(-t0.^2/Dt^2).*exp(1i*w0*t0);
[w0,f_E0]=fft_x(t0,E0);
lm_x=2*pi*c./w0;

% pulse shape
w=linspace(max(w0)/length(w0),max(w0),length(w0));
f_E=interp1(w0,f_E0,w);
f_E(isnan(f_E))=0;
phase_G=grating_compressor_phase(w,D,angle,D_0,angle_0,G);
S=f_E.*exp(-1i*phase_G);
[t1x,f1]=ifft_k(w,S);
E1=f1;


I_f=FROG_In(t1x,E1,tau(i),lm);
FROG_tr(i,:)=I_f;
end
FROG_tr=FROG_tr';



clf
subplot(1,2,1)
surf(tau/1e-15,lm/1e-9,FROG_tr)
shading interp
view([0,90])
xlabel('Delay [fs]')
ylabel('Wavelength [nm]')
colormap('gray')
axis([-500,500,390,410])

subplot(2,2,2)
plot(lm_x/1e-9,I0_S)
axis([700,900,0,1.1*max(I0_S)])
xlabel('Wavelength [nm]')

subplot(2,2,4)
plot(t1/1e-15,I1)
axis([-500,500,0,1.2*max(I1)])
xlabel('Delay [fs]')


%{
Nini, 打开透镜波前(文件)
Nini, 打开光栅压缩器(文件)
+[M函数](,验证公式)
%}

