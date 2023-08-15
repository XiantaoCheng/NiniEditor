%{
+[返回目录]

地址::Matlab\Smilei\trapezoidal.m
+[保存文本](,trapezoidal)

+[M函数](,trapezoidal)
%}

function y=trapezoidal(x,xvacuum,xslope1,xplateau,xslope2,max)

%x=ones(10,1)*linspace(0,100,1000);
%xvacuum=10;
%xslope1=20;
%xplateau=20;
%xslope2=20;
%max=20;

y=zeros(size(x));
x1=xvacuum;
x2=x1+xslope1;
x3=x2+xplateau;
x4=x3+xslope2;

y(x>x1 & x<=x2)=(x(x>x1 & x<=x2)-x1)*max/xslope1;
y(x>x2 & x<=x3)=max;
y(x>x3 & x<=x4)=(x4-x(x>x3 & x<=x4))*max/xslope2;

%surf(y)
end