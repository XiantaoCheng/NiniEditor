%{
地址::Matlab\Hussar\example1.m
创建"Matlab\Hussar"
+[保存文本](,例3)
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

% Signal pre streaching - could also be done through propagation
mStreach = Sapphire();
%fStreachMaterialThickness = 5e-3;
%fBeta2 = mStreach.dispersion(fSignalWavelength, 2, 0);
%AS.addSpectralPhase([0 0 fBeta2*fStreachMaterialThickness]);

AS.addSpectralPhase([0 0 GDD1]);

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





