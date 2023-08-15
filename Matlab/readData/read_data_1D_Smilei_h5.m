%% 20230530
%% from 文档\物理问题\plasma.ftxt
%{
地址::Matlab/readData/read_data_1D_Smilei_h5.m
+[保存M函数](,read_data_1D_Smilei_h5)
%}

function [x,I,info]=read_data_1D_Smilei_h5(file_name,ti,field_name0,lm_r)

physics_constant;
if nargin < 4
    lm_r=800e-9;
end

omega_r=c/lm_r*2*pi;
T_r=1/omega_r;
L_r=c/omega_r;
E_r=m_e.*c.*omega_r./e;
B_r=m_e.*omega_r./e;
N_r=epsilon_0.*m_e.*omega_r.^(2)./e.^(2);
J_r=c.*e.*N_r;

if strcmp(field_name0,'Bx') || strcmp(field_name0,'By')...
     || strcmp(field_name0,'Bz')
    unit=B_r;
elseif strcmp(field_name0,'Ex') || strcmp(field_name0,'Ey')...
     || strcmp(field_name0,'Ez')
    unit=E_r;
elseif strcmp(field_name0,'Jx') || strcmp(field_name0,'Jy')...
     || strcmp(field_name0,'Jz')
    unit=J_r;
else
    unit=N_r;
end

if strcmp(field_name0,'n')
    field_name=sprintf('/data/%010d/%s',ti,"Rho");
else
    field_name=sprintf('/data/%010d/%s',ti,field_name0);
end

info=h5info(file_name,field_name);
data=h5read(file_name,field_name);
space=h5readatt(file_name,field_name,'gridSpacing');
% unit=h5readatt(file_name,field_name,'unitSI');

x=1:size(data,1);
x=x*space(1)*L_r;
I=data'*unit;

end


%{
+[保存M函数](,read_data_1D_Smilei_h5)
%}

