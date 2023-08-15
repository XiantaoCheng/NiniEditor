%% 20220416
%% from 文档\物理问题\电子能谱.ftxt
%{
地址::Matlab\funcs\u_substitution.m
+[保存M函数](,u_substitution)

测试(M函数):...
测试2(M函数):...
+[新建阅读窗口](,测试2)
%}

function [F1,dYdX]=u_substitution(x0,f0,x01,y01,y1)

y0=interp1(x01,y01,x0,'spline');
x1=interp1(y01,x01,y1,'spline');
dydx=[1,diff(y0)./diff(x0)];
F0=abs(f0./dydx);
%F0=abs(f0);

F1=interp1(y0,F0,y1,'spline');
F1(y1>max(y01)|y1<min(y01))=0;
F1(y1>max(y0)|y1<min(y0))=0;
F1(x1>max(x0)|x1<min(x0))=0;
dYdX=interp1(y0,dydx,y1,'spline');

end

%{
地址::Matlab\funcs\u_substitution.m
+[保存M函数](,u_substitution)
%}

