%% 20230414
%% from 文档\数学问题\随机分布.ftxt
%{
+[M函数](,random_func_1D)
地址::Matlab\random\random_func_1D.m
+[保存M函数](,random_func_1D)
呃, 就加一个很小的background
%}

function y=random_func_1D(N,M,Y,G)
% Y=linspace(-10,10,100);
% Dy=1.5;
% G=exp(-(Y-2).^2/Dy^2)+exp(-(Y+2).^2/Dy^2);

G0=mean(G)*1e-5;
G=G+G0;
X=cumsum(G)/sum(G);
x=rand(N,M);
y=interp1(X,Y,x,'spline');

% plot(Y,X)
% hist(y,30)
% plot(y,'.')

end

%{
+[M函数](,公式验证)
%}

