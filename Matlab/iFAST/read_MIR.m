%% 20220512
%% from 文档\实验室信息\iFAST_log2.ftxt
%{
地址::Matlab\iFAST\read_MIR.m
+[保存M函数](,read_MIR)
测试:...
%}

function [I0,lm0]=read_MIR(date,n,axis_,show_)

if nargin<4
    show_=1;
end

file_type="C:\\Users\\cheng\\Dropbox\\iFAST_log\\resources\\%d\\MIR\\%d.raw";
file_name=sprintf(file_type,date,n);

data=readmatrix(file_name,'FileType','text');

lm=data(:,1);
I=data(:,2);

lm0=linspace(axis_(1),axis_(2),4000);
I0=interp1(lm,I,lm0,'spline');

if show_
    plot(lm0,I0);
    xlabel('\lambda [nm]')
    ylabel('I [a.u.]')
end

end

