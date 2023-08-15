%{
地址::Matlab\Hussar\getProfile.m
+[保存文本](,getProfile)
+[M函数](,getProfile)
%}

function [profile,X,Y,E0,E_field]=getProfile(AP)

physics_constant;
space=AP.m_hSpace;
T=fftshift(space.getDimensionByName('T').m_vValues);
X=fftshift(space.getDimensionByName('X').m_vValues);
Y=fftshift(space.getDimensionByName('Y').m_vValues);
In=fftshift(AP.intensity());
IP=fftshift(fft2(AP.m_mGrid));

% profile
profile=reshape(trapz(T,In),size(IP,2),size(IP,3));
E0=trapz(Y,trapz(X,profile));
E_field=reshape(trapz(T,IP),size(IP,2),size(IP,3));

end

%{
+[H函数](,getProfile)
%}