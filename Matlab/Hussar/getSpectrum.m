%{
地址::Matlab\Hussar\getSpectrum.m
+[保存文本](,getSpectrum)
+[M函数](,getSpectrum)
%}

function [spectrum,lm,p]=getSpectrum(AP)

physics_constant;
space=AP.m_hSpace;
T=fftshift(space.getDimensionByName('T').m_vValues);
X=fftshift(space.getDimensionByName('X').m_vValues);
Y=fftshift(space.getDimensionByName('Y').m_vValues);
In=fftshift(AP.intensity());
IP=AP.m_mGrid;

AF=fftshift(space.getDimensionByName('T').m_vConjValues);
AF=AF+AP.m_fRefFreq;
lm=2*pi*c./AF;

% spectrum
spectrum=sum(sum(IP,2),3);
p=spectrum;
spectrum=fftshift(abs(p).^2);

end

%{
+[H函数](,getSpectrum)
%}