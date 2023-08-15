%% 20220714
%% from 文档\物理问题\能谱仪误差.ftxt
%{
地址::Matlab\spectrometer\radiation_method.m
+[保存M函数](,radiation_method)
%}


function [E_r,R,theta,beta]=radiation_method(z_o,x_o,z_m,B,D,z_c,x_c,z_e,x_e)
    physics_constant;
    q=e;
    x_m=x_o+(z_m-z_o)./(z_c-z_o).*(x_c-x_o);
    theta=atan((x_c-x_o)./(z_c-z_o));
    beta=atan((x_e-x_m)./(z_e-z_m));
    
    R=(D)./(sin(beta)-sin(theta));
    E_r=sqrt(B.^(2).*c.^(2).*R.^(2).*q.^(2)+m_e.^(2).*c.^(4));
end



