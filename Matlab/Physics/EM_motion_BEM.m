%% 20230219
%% from 文档\数学问题\龙格库塔方法.ftxt
%{
地址::Matlab/Physics/EM_motion_BEM.m
+[保存M函数](,EM_motion_BEM)
%}

function [x,y,v_x,v_y]=EM_motion_BEM(x,y,v_x,v_y,Delta_t,t,q,m,B_z,E_x,E_y)
physics_constant;

f_1=@(t,x,y,v_x,v_y)v_x;
f_2=@(t,x,y,v_x,v_y)v_y;
f_3=@(t,x,y,v_x,v_y)(v_y.*B_z(x,y)+E_x(x,y)).*q./m;
f_4=@(t,x,y,v_x,v_y)(-v_x.*B_z(x,y)+E_y(x,y)).*q./m;

h=Delta_t;
F=zeros(4,1);

F(1)=f_1(t,x,y,v_x,v_y);
F(2)=f_2(t,x,y,v_x,v_y);
F(3)=f_3(t,x,y,v_x,v_y);
F(4)=f_4(t,x,y,v_x,v_y);

df_3_dx=(f_3(t,x+h*1e-5/2,y,v_x,v_y)-f_3(t,x-h*1e-5/2,y,v_x,v_y))/h/1e-5;
df_3_dy=(f_3(t,x,y+h*1e-5/2,v_x,v_y)-f_3(t,x,y-h*1e-5/2,v_x,v_y))/h/1e-5;
df_3_dv_y=(f_3(t,x,y,v_x,v_y+h*1e-5/2)-f_3(t,x,y,v_x,v_y-h*1e-5/2))/h/1e-5;

df_4_dx=(f_4(t,x+h*1e-5/2,y,v_x,v_y)-f_4(t,x-h*1e-5/2,y,v_x,v_y))/h/1e-5;
df_4_dy=(f_4(t,x,y+h*1e-5/2,v_x,v_y)-f_4(t,x,y-h*1e-5/2,v_x,v_y))/h/1e-5;
df_4_dv_x=(f_4(t,x,y,v_x+h*1e-5/2,v_y)-f_4(t,x,y,v_x-h*1e-5/2,v_y))/h/1e-5;

A=[1,0,-h,0;
0,1,0,-h;
-df_3_dx.*h,-df_3_dy.*h,1,-df_3_dv_y.*h;
-df_4_dx.*h,-df_4_dy.*h,-df_4_dv_x.*h,1];
K=A\F;

x=x+Delta_t*K(1);
y=y+Delta_t*K(2);
v_x=v_x+Delta_t*K(3);
v_y=v_y+Delta_t*K(4);

end


%{
+[M函数](,验证公式)
%}

