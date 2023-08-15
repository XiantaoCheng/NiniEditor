%% 20221004
%% from 文档\实验室信息\iFAST_log2.ftxt
%{
地址::Matlab\iFAST\read_FROG.m
Nini, 打开iFAST日志2的read_profile(节点)
+[保存M函数](,read_FROG)
%}

function [I0,dt,lm]=read_FROG(A,B,date,n,axis_,show_)


if nargin<5
    axis_=zeros(1,4);
end
if nargin<6
    show_=1;
end


[I0,x,y]=read_profile(date,n,zeros(1,4),0);
x=x/5.5e-3;
y=y/5.5e-3;

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




