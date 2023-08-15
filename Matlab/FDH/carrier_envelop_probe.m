%% 20230601
%% from 文档/物理问题/FDH.ftxt
%{
地址::Matlab/FDH/carrier_envelop_probe.m
+[保存M函数](,carrier_envelop_probe)

测试:...
%}

function [x_pk,y_pk,f_1]=carrier_envelop_probe(x0,f,f_min)


zeros_l=[];
zeros_r=[];
for si=1:length(x0)-1
    if f(si)*f(si+1)<0
        zeros_l(end+1)=si;
        zeros_r(end+1)=si+1;
    end
end

x_pk=[];
y_pk=[];

for si=1:length(zeros_l)-1
    f_lc=f(zeros_r(si):zeros_l(si+1));
    f_max=max(f_lc);
    si_max=find(f_lc==f_max);
    si_0=si_max(1)-1+zeros_r(si);
    x_pk(end+1)=x0(si_0);
    y_pk(end+1)=f(si_0);
end
x_pk(y_pk<f_min)=[];
y_pk(y_pk<f_min)=[];

f_1=interp1(x_pk,y_pk,x0,'spline');
f_1(x0<min(x_pk) | x0>max(x_pk))=0;


end




