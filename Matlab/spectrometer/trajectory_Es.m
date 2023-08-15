%% 20221229
%% from 文档\物理问题\电子能谱.ftxt
%{
地址::Matlab\spectrometer\trajectory_Es.m
+[保存M函数](,trajectory_Es)

保存:...
%}

function [theta,y_f]=trajectory_Es(x_s,y_s,E,x_m,D,B,x_i,y_i,x_f)
physics_constant;

x_m1=x_m-D/2;
x_m2=x_m+D/2;


R=(sqrt(E.^(2)./c.^(2)-m_e.^(2).*c.^(2)))./(e.*B);

beta=atan((y_i-y_s)./(x_i-x_s));
theta=beta;

for i=1:100

    y_m2=y_i-tan(beta).*(x_i-x_m2);
    theta=asin(sin(beta)+(D)./(R));
    Delta=R.*(cos(beta)-cos(theta));
    y_m1=y_m2-Delta;
    y_sx=y_m1-tan(theta).*(x_m1-x_s);
    Dt=(y_sx-y_s)./(x_i-x_s);

    beta=beta+Dt*0.9;

end

y_f=y_i+tan(beta).*(x_f-x_i);

end


%{
+[M函数](,验证公式)
%}

