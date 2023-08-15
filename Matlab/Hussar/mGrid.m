%{
地址::Matlab\Hussar\mGrid.m
+[保存文本](,测试m_mGrid)->+[matlab2014](,地址)

sinc::https://en.wikipedia.org/wiki/Sinc_function
+[打开网页](,sinc)

测试profile(M函数):...
显示waveform(M函数):...

getProfile(M函数):...
getWaveform(M函数):...
getSpectrum(M函数):...
+[新建阅读窗口](,getProfile)
测试get函数(M函数):...

位移问题:...

setProfile(M函数):...
setWaveform(M函数):...
setWaveform的"setProfile"替换为"setWaveform"

%}

%% clean up
clc;
close all;
clear all;
format long e;


lm0=800e-9;
tau0=20e-15;
E0=20e-3;
w0=10e-3;

%D=1.5e-3;
H=13e-3;
W=13e-3;

%% include Hussar
run('C:\Users\cheng\Desktop\Laser\tools\OPA\Hussar-1.3-p\includeAll');

%% space
space = CSpace('TXY');

fTimeSpan = 3e-12; % time window span in SI units [s]
iTimeSize = 2^9;   % number of time grid points


space.setDimension('T', fTimeSpan, iTimeSize);
space.setDimension('X', W, 2^5);
space.setDimension('Y', H, 2^5);

%pump
fPumpWavelength = lm0;
AP = CEnvelope('A_P', space, fPumpWavelength);

composer = CPulseComposer(space);
composer.append('T', CSincPF('FWHM', tau0));
composer.append('X', CGaussPF('Waist', w0/2));
composer.append('Y', CGaussPF('Waist', w0/2));

fPumpEnergy = E0;
AP.put(fPumpEnergy, composer);

% set profile
[~,x,y]=getProfile(AP);
[~,~,spectrum]=getSpectrum(AP);
[X,Y]=meshgrid(x,y);
Dx=max(x)-min(x);

I0=exp(-((X-Dx/8).^2+Y.^2)/(Dx/8)^2);
I0=I0+exp(-((X+Dx/8).^2+Y.^2)/(Dx/8)^2);

setProfile(AP,I0)

% set waveform
[waveform,t]=getWaveform(AP);
Dtau=50e-15;
waveform=exp(-t.^2/Dtau^2+1i*t.^2/Dtau^2);

setWaveform(AP,waveform);

[profile,x,y]=getProfile(AP);
[waveform,t,p]=getWaveform(AP);
AP.energy()

subplot(1,2,1)
surf(x,y,profile)
view(0,90)
axis equal
axis([min(x),max(x),min(y),max(y)])
subplot(1,2,2)
plot(t/1e-15,p,t/1e-15,abs(waveform))
xlabel('t [fs]')

%{
地址::Matlab\Hussar\mGrid.m
+[保存文本](,测试m_mGrid)->+[matlab2014](,地址)
%}