%% 20220714
%% from 文档\物理问题\能谱仪误差.ftxt
%{
地址::Matlab\spectrometer\fiducial_method.m
+[保存M函数](,fiducial_method)
%}


function [E_f,R,theta,beta]=fiducial_method(z_o,x_o,z_m,B,D,z_f,x_f,z_s,x_s)
    physics_constant;
    q=e;
    theta=atan((x_s-x_o)./(z_m-z_o)+((x_s-x_f).*(z_m-z_s))./((z_s-z_f).*(z_m-z_o)));
    beta=atan((x_s-x_f)./(z_s-z_f));
    R=(D)./(sin(beta)-sin(theta));
    E_f=sqrt(B.^(2).*c.^(2).*R.^(2).*q.^(2)+m_e.^(2).*c.^(4));
end



