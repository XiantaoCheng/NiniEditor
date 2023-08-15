%% 20221013
%% from 文档\实验室问题\Dazzler优化.ftxt
%{
地址::Matlab\FROG\read_FROG_2.m
+[保存M函数](,read_FROG_2)
%}

function [I0,dt,lm]=read_FROG_2(A,B,file_name,axis_,show_)

if nargin<4
    axis_=zeros(1,4);
end
if nargin<5
    show_=1;
end

data=imread(file_name)';
I0=double(data);
y=1:size(I0,1);
x=1:size(I0,2);


lm=2*(A(1)*y+A(2));
dt=B*x;

if sum(abs(axis_))~=0
    I0=I0(lm<axis_(4)&lm>axis_(3),dt<axis_(2)&dt>axis_(1));
    lm=lm(lm<axis_(4)&lm>axis_(3));
    dt=dt(dt<axis_(2)&dt>axis_(1));
end


if show_==1
    surf(dt,lm,I0)
    shading interp
    view([0,90])
    xlabel('Delay [fs]')
    ylabel('Wavelength [nm]')
    axis([min(dt),max(dt),min(lm),max(lm)])
end

end




