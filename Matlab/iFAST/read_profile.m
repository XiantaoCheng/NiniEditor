%{
+[保存文本](,read_profile)
地址::Matlab\iFAST\read_profile.m

测试:...
+[新建阅读窗口](,测试)
%}

function [I0,x0,y0]=read_profile(date,n,axis_,show_)

file_type="C:\\Users\\cheng\\Dropbox\\iFAST_log\\resources\\%d\\pro\\%d.raw";
file_name=sprintf(file_type,date,n);

x=(1:1200)*5.5e-3;
y=(1:1600)*5.5e-3;
data=readmatrix(file_name,'FileType','text');
I0=data;


if nargin<3
    x0=x;
    y0=y;
    axis_=[min(x),max(x),min(y),max(y)];
end
if nargin<4
    show_=1;
end

if sum(abs(axis_))==0
    x0=x;
    y0=y;
    axis_=[min(x),max(x),min(y),max(y)];
else
    I0=I0(y<axis_(4)&y>axis_(3),x<axis_(2)&x>axis_(1));
    y0=y(y<axis_(4)&y>axis_(3));
    x0=x(x<axis_(2)&x>axis_(1));
end

I0=I0/max(max(I0));

if show_
    surf(x0,y0,I0);
    shading interp
    view([0,90])
    axis equal
    axis(axis_)
    xlabel('x [mm]')
    ylabel('y [mm]')
end

end

