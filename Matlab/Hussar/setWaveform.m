%{
地址::Matlab\Hussar\setWaveform.m
+[保存文本](,setWaveform)
%}

function setWaveform(AP,waveform);

profile=getProfile(AP);
I0=fftshift(profile);
spectrum=fft(fftshift(waveform));

Data=spectrum'*reshape(fft2(I0),[1,numel(I0)]);
Data=reshape(Data,[length(spectrum),size(I0)]);

E0=AP.energy();
AP.m_mGrid=Data;
E1=AP.energy();
AP.m_mGrid=Data*sqrt(E0/E1);


end

%{
+[M函数](,setWaveform)
%}