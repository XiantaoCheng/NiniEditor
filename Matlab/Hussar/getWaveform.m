%{
地址::Matlab\Hussar\getWaveform.m
+[保存文本](,getWaveform)
+[M函数](,getWaveform)
%}

function [waveform,T,p]=getWaveform(AP)

physics_constant;
space=AP.m_hSpace;
T=fftshift(space.getDimensionByName('T').m_vValues);
X=fftshift(space.getDimensionByName('X').m_vValues);
Y=fftshift(space.getDimensionByName('Y').m_vValues);
In=fftshift(AP.intensity());
IP=AP.m_mGrid;

% profile
profile=reshape(trapz(T,In),size(IP,2),size(IP,3));
E0=trapz(Y,trapz(X,profile));

% waveform
waveform=fftshift(fft(sum(sum(IP,2),3)));
A_n=trapz(T,waveform);
waveform=E0/A_n*waveform;

w0=AP.m_fRefFreq;
p=waveform.*exp(-1i*w0*T');

end

%{
+[M函数](,getWaveform)
%}