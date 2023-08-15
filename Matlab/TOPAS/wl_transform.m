%{
+[返回目录]
地址::Matlab\TOPAS\wl_transform.m
+[保存文本](,坐标变换)
+[matlab](Matlab,)->+[code](+[matlab],坐标变换)

用上次的测量结果作为输入样本喽~
样本::C:\Users\cheng\Dropbox\iFAST_log\data\20201009SpectrumMeasurement
+[打开](,样本)

理论依据:
坐标变换->的(_,坐标变换)->的(_,波长转换)->+[网页](web,波长转换)

测试:...
%}

function [w,inty_w,inty_w1,omega]=wl_transform(lambda,inty)

physics_constant;
%spectrum=readtable('C:\Users\cheng\Dropbox\iFAST_log\data\20201009SpectrumMeasurement\2nd_stage.csv');
%lambda=spectrum.Var1;
%inty=spectrum.Var2;

%background=mean(inty(lambda<650&lambda>550))
%inty=inty-background;
%inty(inty<0)=0;
%lambda=lambda*1e-9;

% lambda to omega
omega=2*pi*c./lambda;
dlambda=zeros(size(lambda));
dlambda(2:end)=diff(lambda);
domega=zeros(size(omega));
domega(2:end)=diff(omega);

inty_om=-inty.*dlambda./domega;
inty_om1=inty.*2*pi*c./omega.^2;
% plot(omega,inty_om/max(inty_om),omega,inty_om1/max(inty_om1),omega,inty/max(inty),'--');

w=linspace(min(omega),max(omega),length(omega));
inty_w=interp1(omega,inty_om,w,'spline');
inty_w1=interp1(omega,inty_om,w,'spline');

end