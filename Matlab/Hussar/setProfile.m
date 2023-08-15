%{
地址::Matlab\Hussar\setProfile.m
+[保存文本](,setProfile)
%}

function setProfile(AP,I0);

[~,~,spectrum]=getSpectrum(AP);
I0=fftshift(I0);
spectrum=fftshift(spectrum);

Data=spectrum*reshape(fft2(I0),[1,numel(I0)]);
Data=reshape(Data,[length(spectrum),size(I0)]);

E0=AP.energy();
AP.m_mGrid=Data;
E1=AP.energy();
AP.m_mGrid=Data*sqrt(E0/E1);


end

%{
+[M函数](,setProfile)
%}