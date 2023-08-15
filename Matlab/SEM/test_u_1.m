%% 20230311
%% from 文档\物理问题\电透镜.ftxt
%{
地址::Matlab/SEM/test_u_1.m
+[保存M函数](,test_u_1)
%}

function [u,u_1,u_2,u_3,u_0]=test_u_1(z,d_1,d_0,D,E_0,U_1)

u_1=d_1*E_0/2*log(cosh((z+D)/d_1));
i1=find(abs(u_1)==inf & (z+D)>0);
i2=find(abs(u_1)==inf & (z+D)<0);
u_1(i1)=E_0/2*(z(i1)+D)-d_1*E_0/2*log(2);
u_1(i2)=-E_0/2*(z(i2)+D)-d_1*E_0/2*log(2);

u_2=d_1*E_0/2*log(cosh((z-D)/d_1));
i1=find(abs(u_2)==inf & (z-D)>0);
i2=find(abs(u_2)==inf & (z-D)<0);
u_2(i1)=E_0/2*(z(i1)-D)-d_1*E_0/2*log(2);
u_2(i2)=-E_0/2*(z(i2)-D)-d_1*E_0/2*log(2);

u_3=d_0*E_0*log(cosh(z/d_0));
i1=find(abs(u_3)==inf & z>0);
i2=find(abs(u_3)==inf & z<0);
u_3(i1)=E_0*z(i1)-d_0*E_0*log(2);
u_3(i2)=-E_0*z(i2)-d_0*E_0*log(2);

u_0=-log(2)*E_0*(d_0-d_1);

u=u_1+u_2-u_3+u_0+U_1;


end


%{
+[保存M函数](,test_u_1)
%}

