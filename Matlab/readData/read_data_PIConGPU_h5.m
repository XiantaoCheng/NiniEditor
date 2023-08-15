%% 20230607
%% from 文档\实验室问题\PIConGPU.ftxt
%{
地址::Matlab/readData/read_data_PIConGPU_h5.m
+[保存M函数](,read_data_PIConGPU_h5)
sprintf('%06d',1)
%}

function [data,info]=read_data_PIConGPU_h5(file_name0,ti,field_name0)
% file_name=sprintf("/home/xiantao/Documents/PIC/output/openPMD/simData_%06d.h5",2000);
file_name=sprintf("%s_%06d.h5",file_name0,ti);

if strcmp(field_name0,'Ex')
    field_name='fields/E/y';
elseif strcmp(field_name0,'Ey')
    field_name='fields/E/x';
elseif strcmp(field_name0,'Ez')
    field_name='fields/E/z';
elseif strcmp(field_name0,'Bx')
    field_name='fields/B/y';
elseif strcmp(field_name0,'By')
    field_name='fields/B/x';
elseif strcmp(field_name0,'Bz')
    field_name='fields/B/z';
elseif strcmp(field_name0,'n')
    field_name='fields/e_all_chargeDensity';
elseif strcmp(field_name0,'Rho')
    field_name='fields/e_all_chargeDensity';
else
    field_name='fields/e_all_energyDensity';
end
data_name=sprintf("/data/%d/%s",ti,field_name);

info=h5info(file_name,data_name);
data=h5read(file_name,data_name);

end


%{
+[保存M函数](,read_data_PIConGPU_h5)
%}

