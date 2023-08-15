%% 20230219
%% from 文档\数学问题\龙格库塔方法.ftxt
%{
地址::Matlab/Physics/EM_motion_CM.m
+[保存M函数](,EM_motion_CM)
%}

function [x,y,v_x,v_y]=EM_motion_CM(x,y,v_x,v_y,Delta_t,t,q,m,B_z,E_x,E_y)

f_1=@(t,x,y,v_x,v_y)v_x;
f_2=@(t,x,y,v_x,v_y)v_y;
f_3=@(t,x,y,v_x,v_y)(v_y.*B_z(x,y)+E_x(x,y)).*q./m;
f_4=@(t,x,y,v_x,v_y)(-v_x.*B_z(x,y)+E_y(x,y)).*q./m;

h=Delta_t;
F=zeros(4,1);

k_11=f_1(t,x,y,v_x,v_y);
k_12=f_2(t,x,y,v_x,v_y);
k_13=f_3(t,x,y,v_x,v_y);
k_14=f_4(t,x,y,v_x,v_y);

x1=x+k_11*h/2;
y1=y+k_12*h/2;
v_x1=v_x+k_13*h/2;
v_y1=v_y+k_14*h/2;


F(1)=f_1(t,x1,y1,v_x1,v_y1);
F(2)=f_2(t,x1,y1,v_x1,v_y1);
F(3)=f_3(t,x1,y1,v_x1,v_y1);
F(4)=f_4(t,x1,y1,v_x1,v_y1);

df_3_dx=(f_3(t,x1+h*1e-5/2,y1,v_x1,v_y1)-f_3(t,x1-h*1e-5/2,y1,v_x1,v_y1))/h/1e-5;
df_3_dy=(f_3(t,x1,y1+h*1e-5/2,v_x1,v_y1)-f_3(t,x1,y1-h*1e-5/2,v_x1,v_y1))/h/1e-5;
df_3_dv_y=(f_3(t,x1,y1,v_x1,v_y1+h*1e-5/2)-f_3(t,x1,y1,v_x1,v_y1-h*1e-5/2))/h/1e-5;

df_4_dx=(f_4(t,x1+h*1e-5/2,y1,v_x1,v_y1)-f_4(t,x1-h*1e-5/2,y1,v_x1,v_y1))/h/1e-5;
df_4_dy=(f_4(t,x1,y1+h*1e-5/2,v_x1,v_y1)-f_4(t,x1,y1-h*1e-5/2,v_x1,v_y1))/h/1e-5;
df_4_dv_x=(f_4(t,x1,y1,v_x1+h*1e-5/2,v_y1)-f_4(t,x1,y1,v_x1-h*1e-5/2,v_y1))/h/1e-5;


A=[1,0,-h/2,0;
0,1,0,-h/2;
-df_3_dx.*h/2,-df_3_dy.*h/2,1,-df_3_dv_y.*h/2;
-df_4_dx.*h/2,-df_4_dy.*h/2,-df_4_dv_x.*h/2,1];

K=A\F;

x=x1+h/2*K(1);
y=y1+h/2*K(2);
v_x=v_x1+h/2*K(3);
v_y=v_y1+h/2*K(4);

end


%{
+[M函数](,验证公式)
%}

