%% 20220903
%% from 文档\物理问题\Projector.ftxt
%{
地址::Matlab\Smilei\Shape_function.m
测试:...
+[保存M函数](,Shape_function)
%}

function S=Shape_function(xs,Delta_x,n)

if n==1
    S=ones(size(xs));
    S(xs<-Delta_x/2 | xs>=Delta_x/2)=0;
elseif n==2
    S=1-abs((xs)./(Delta_x));
    S(abs(xs)>Delta_x)=0;
elseif n==3
    S=zeros(size(xs));
    S(Delta_x./2<=abs(xs) & abs(xs)<=3.*Delta_x./2)=9/8*(1-2/3.*abs((xs(Delta_x./2<=abs(xs) & abs(xs)<=3.*Delta_x./2))./(Delta_x))).^2;
    S(abs(xs)<=Delta_x./2)=3/4*(1-4/3*(xs(abs(xs)<=Delta_x./2)./(Delta_x)).^2);
else
    S=zeros(size(xs));
    S(Delta_x<abs(xs) & abs(xs)<= 2.*Delta_x)=(4)./(3).*(1-(1)./(2).*abs((xs(Delta_x<abs(xs) & abs(xs)<= 2.*Delta_x))./(Delta_x))).^(3);
    S(abs(xs)<= Delta_x)=(2)./(3).*(1-(3)./(2).*((xs(abs(xs)<= Delta_x))./(Delta_x)).^(2)+(3)./(4).*abs((xs(abs(xs)<= Delta_x))./(Delta_x)).^(3));
end


end


%{
+[M函数](,验证公式)
%}

