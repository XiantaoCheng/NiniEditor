%{
+[返回目录](,输出代码)

内容解释:...
地址::Matlab\output\20210626\OPA_test.m
+[保存文本](,输出代码)
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


%% initial pulses temporal and spatial separation (cross the pulses in
% the center of the medium)
% group velocity mismatch
[fSigV] = m.groupVelocity(fSignalWavelength, fTheta, fPhi);
[~, fPumpV] = m.groupVelocity(fPumpWavelength, fTheta, fPhi);
GVM = (1/fSigV - 1/fPumpV); % s/m

AP.addSpectralPhase([0, 0.5*fCrystalThickness * GVM ]); % delay

% walk-off and non-collinearity
[fWalkOffAngleE] = m.getWalkOffAngles(fPumpWavelength, fTheta);
% fWalkOffAngleE=45/180*pi;
fPumpXShift = -0.5* fCrystalThickness * tan(fWalkOffAngleE);

% AP.setReferenceWavevectorComponent('X',3e4)
AP.shiftInSpace('Y', fPumpXShift);



%% back propagation
% get the flat pulse front in the center of the crystal
[n] = m.refractiveIndex(fIdlerWavelength, fTheta);
vRefractiveIndices(1) = n;
[n] = m.refractiveIndex(fSignalWavelength, fTheta);
vRefractiveIndices(2) = n;
vBackPropagateLength(2) = 0.5*fCrystalThickness * n;
[~, n] = m.refractiveIndex(fPumpWavelength, fTheta);
vRefractiveIndices(3) = n;
vBackPropagateLength(3) = 0.5*fCrystalThickness * n;


for it = 2:3 % only the signal and the pump
    Ai = A(it);
    backPropagateMM = CMaterialManager(vacuum, vBackPropagateLength(it));
    pm = CPropagationManager(backPropagateMM, Ai, 'o');
    dp = CProcessContainer(pm);
    
    le = CLinearEffects('BackPropagation', 'on');
    dp.addProcess(le);
    
    ee = CExpEuler(dp, 1);
    stepper = CConstantStepSizeStepper(ee, 1);
    
    %% Listeners
    caColor = {'m', 'r', 'g'}; % colors for the envelopes
    
    hFig = figure('Position', [100+(it-2)*520, 100, 500, 800]);
    lfigure = CListenerFigure([3 1], hFig);
    
    hEnergyListener = CEnergyListener({caColor{it}});
    hEnergyListener.placeOn(lfigure, [1]);
    stepper.addListener(hEnergyListener);
    
    visual = C3DVisualizeListener({caColor{it}});
    visual.placeOn(lfigure, [2 3], 1);
    stepper.addListener(visual);
    
    %% solve!
    Ai = stepper.solve(Ai);
end


m.m_fMaxWavelength=4000e-9;
% interface = CInterface(mmVacuum, mm);

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

%% Listeners

caColor = {'m', 'r', 'g'};

hFig = figure('Position', [100, 100, 1400, 800], 'Color', [0.8, 0.8 ,1.0]);
set(hFig,'Renderer','zbuffer');
lfigure = CListenerFigure([1 3], hFig);

hFig2 = figure('Position', [100, 100, 1400, 800], 'Color', [0.8, 0.8 ,1.0]);
set(hFig2,'Renderer','zbuffer');
lfigure2 = CListenerFigure([2 3], hFig2);

hFig3 = figure('Position', [100, 100, 1400, 800], 'Color', [0.8, 0.8 ,1.0]);
set(hFig3,'Renderer','zbuffer');
lfigure3 = CListenerFigure([2 2], hFig3);


hEnergyListener = CEnergyListener(caColor);
hEnergyListener.setRefractiveIndex(vRefractiveIndices); % more or less
hEnergyListener.placeOn(lfigure3, 1);
hEnergyListener.setPlotType(@plot);
hEnergyListener.setVisible([1, 1, 0]);
hEnergyListener.setAxesUnits( 'Energy', 'nJ');
stepper.addListener(hEnergyListener);

hEnergyListener2 = CEnergyListener(caColor);
hEnergyListener2.setRefractiveIndex(vRefractiveIndices); % more or less
hEnergyListener2.placeOn(lfigure3, 2);
hEnergyListener2.setPlotType(@semilogy);
hEnergyListener2.setAxesUnits( 'Energy', 'nJ');
stepper.addListener(hEnergyListener2);

bpl1 = CProfileListener(1);
bpl2 = CProfileListener(2);
bpl3 = CProfileListener(3);
bpl1.placeOn(lfigure2, 1, 1);
bpl1.placeOn(lfigure2, 4, 2);
bpl2.placeOn(lfigure2, 2, 1);
bpl2.placeOn(lfigure2, 5, 2);
bpl3.placeOn(lfigure2, 3, 1);
bpl3.placeOn(lfigure2, 6, 2);
stepper.addListener(bpl1);
stepper.addListener(bpl2);
stepper.addListener(bpl3);

visual = C3DVisualizeListener(caColor); %, 'SHG (BBO)', gm);
visual.placeOn(lfigure, 1, 1);
stepper.addListener(visual);


visual2 = CTrailListener(caColor); %, 'SHG (BBO)', gm);
visual2.placeOn(lfigure, 2, 1);
visual2.setGradientSteps([0.1 0.5]);
visual2.setAlpha(0.2);
visual2.setView(0,90);
stepper.addListener(visual2);


specL = CSpectrumListener(caColor, 'Wavelength');
specL.placeOn(lfigure, 3);
specL.normalize('on');
stepper.addListener(specL);

specL = CSpectrumListener(caColor);
specL.placeOn(lfigure3, 3);
specL.normalize('on');
stepper.addListener(specL);

tpl = CTimeProfileListener(caColor);
tpl.placeOn(lfigure3, 4);
tpl.setAxesUnits('Local Time', 'ps');
stepper.addListener(tpl);

%% solve
A = stepper.solve(A);

interface = CInterface(mm, mmVacuum);
A = interface.transfer(A, 'ooe', 'ooo');

disp(['output energy: ' num2str(1e12* AS.energy()) ' pJ']);

EP=AP.energy();
ES=AS.energy();
EI=AI.energy();

IP=AP.intensity();
IS=AS.intensity();
II=AI.intensity();

save('output.mat','EP','ES','EI','IP','IS','II');


