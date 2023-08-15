%% 20221013
%% from 文档\实验室问题\Dazzler优化.ftxt
%{
地址::Matlab\FROG\read_vis_2.m
+[保存M函数](,read_vis_2)
%}


function [I0,lm0]=read_vis_2(file_name,axis_,show_)


if nargin<3
    show_=1;
end


data=fileread(file_name);
expr='Model Number:(.*)Firmware Version:(.*)Serial Number:(.*)Exposure Time:(.*)Data Taken on:([0-9 /:.]*)(.*)';
tokens=regexp(data,expr,'tokens');
spectrum=str2num(tokens{1}{6});


lm=spectrum(:,1);
I=spectrum(:,2);


lm0=linspace(axis_(1),axis_(2),4000);
I0=interp1(lm,I,lm0,'spline');


if show_
    plot(lm0,I0);
    xlabel('\lambda [nm]')
end


end



