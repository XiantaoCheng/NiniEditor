%{
地址::Matlab\Hussar\OPA_test.m
+[保存文本](,简化模拟)->+[matlab2014](,地址)
Nini, 打开TOPAS模拟的setProfile(节点)

保存:...
%}




%% clean up
clc;
close all;
clear all;
format long e;


lm0=800e-9;
tau0=23e-15;
E0=20e-3;
w0=10e-3;

lm1=1.8e-6;
tau1=50e-15;
E1=30e-6;
w1=1e-3;
GDD1=20e-28;

D=1.5e-3;
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

%% envelopes
%signal
fSignalWavelength = lm1;
AS = CEnvelope('A_S', space, fSignalWavelength);

composer = CPulseComposer(space);
composer.append('T', CSincPF('FWHM', tau1));
composer.append('X',  CGaussPF('Waist', w1));
composer.append('Y', CGaussPF('Waist', w1));
fSignalEnergy = E1;
AS.put(fSignalEnergy, composer);

%pump
fPumpWavelength = lm0;
AP = CEnvelope('A_P', space, fPumpWavelength);

composer = CPulseComposer(space);
composer.append('T', CGaussPF('FWHM', tau0));
composer.append('X', CGaussPF('Waist', w0/2));
composer.append('Y', CGaussPF('Waist', w0/2));

fPumpEnergy = E0;
AP.put(fPumpEnergy, composer);

%idler
fIdlerWavelength = 1/(1/fPumpWavelength - 1/fSignalWavelength);
AI = CEnvelope('A_I', space, fIdlerWavelength);


A(1) = AI;
A(2) = AS;
A(3) = AP;

%% materials
%start in vacuum
vacuum = Vacuum();
mmVacuum = CMaterialManager(vacuum, 0);

%nonlinear medium
m = BBO();
fCrystalThickness = D;

fPhi = 90*pi/180;
fTheta = m.phaseMatch([fIdlerWavelength fSignalWavelength], ...
    ['o' 'o'], fPumpWavelength, 'e', pi/4);
deff = m.getDeff([fIdlerWavelength fSignalWavelength, ...
    fPumpWavelength], ['o' 'o' 'e'], fTheta, fPhi);

mm = CMaterialManager(m, fCrystalThickness, fTheta);


m.m_fMaxWavelength=4000e-9;

%% nonlinear propagation

pm = CPropagationManager(mm, A, 'ooe');
dp = CProcessContainer(pm);

dp.addProcess(CLinearEffects());
dp.addProcess(OPA(deff));
n2 = 6e-20; % m^2/W
dp.addProcess(SPM(n2));
dp.addProcess(XPM(n2));

% method = CRK45Method(dp, space, length(A), 'Dormand-Prince');
method = CIFRK45Method(dp, space, length(A), 'Dormand-Prince');

stepper = CHairerStepper(method);

fAccuracy = 1e-6;
fMinStepSize = 0.5e-6;
fMaxAmplitude = max(max(max(AP.m_mGrid)));
stepper.setAccuracy(fAccuracy, 0.1*fAccuracy*fMaxAmplitude, fMinStepSize);


% set profile
[~,x,y]=getProfile(AP);
[~,~,spectrum]=getSpectrum(AP);
[X,Y]=meshgrid(x,y);
Dx=max(x)-min(x);

I0=exp(-((X-Dx/8).^2+Y.^2)/(Dx/8)^2);
I0=I0+exp(-((X+Dx/8).^2+Y.^2)/(Dx/8)^2);

setProfile(AP,I0)


%% solve
A = stepper.solve(A);

interface = CInterface(mm, mmVacuum);
A = interface.transfer(A, 'ooe', 'ooo');

disp(['output energy: ' num2str(1e6* AS.energy()) ' uJ']);

% profile
[profile,x,y]=getProfile(AP);
[waveform,t,p]=getWaveform(AP);

subplot(1,2,1)
surf(x,y,profile)
view(0,90)
axis equal
axis([min(x),max(x),min(y),max(y)])
subplot(1,2,2)
plot(t/1e-15,p,t/1e-15,abs(waveform))
xlabel('t [fs]')


EP=AP.energy();
ES=AS.energy();
EI=AI.energy();

IP=AP.intensity();
IS=AS.intensity();
II=AI.intensity();


%{
+[保存文本](,简化模拟)->+[matlab2014](,地址)
%}