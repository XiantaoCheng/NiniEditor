%% 20230502
%% from 文档\实验室问题\PIConGPU.ftxt
%{
地址::Matlab/FDH/field_spatial_phase.m
+[保存M函数](,field_spatial_phase)
%}

function ph_z=field_spatial_phase(E_z)
F_1=fft(E_z')';
F_1(:,end/2:end)=0;
in_1=ifft(F_1')';
ph_z=sign_1(imag(in_1)).*acos(real(in_1)./abs(in_1));
end




