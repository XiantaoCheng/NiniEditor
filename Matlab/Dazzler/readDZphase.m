%% 20220505
%% from 文档\实验室问题\Dazzler优化.ftxt
%{
地址::Matlab\Dazzler\readDZphase.m
+[保存M函数](,readDZphase)

addpath('Matlab\Dazzler');

file_name="文档\实验室问题\Dazzler优化\data\phase.txt";

lms=[725.7,729.8;
742.4,856.2;
860.4,864];

%}

function [phase_y,lm_x,phase0,lm0]=readDZphase(file_name,lms)

data=readtable(file_name);
data=data{:,:};

lm0=data(:,1)';
phase0=data(:,2)';

if lm0(1)>lm0(end)
lm0=fliplr(lm0);
phase0=fliplr(phase0);
end

if nargin>1
    lm=[];
    phase=[];

    for i=1:size(lms,1)
        lm=[lm,lm0(lm0>lms(i,1)&lm0<lms(i,2))];
        phase=[phase,phase0(lm0>lms(i,1)&lm0<lms(i,2))];
    end

    lm(end+1)=lm0(end);
    phase(end+1)=phase0(end);
    
    lm_x=lm0;
    phase_y=interp1(lm,phase,lm_x,'spline');
else
    lm_x=lm0;
    phase_y=phase0;
end




end



%{
+[M函数](,优化phase)
%}

