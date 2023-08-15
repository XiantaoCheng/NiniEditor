%% 20230105
%% from 文档\数学问题\龙格库塔方法.ftxt
%{
地址::Matlab\Physics\EM_motion_RK4.m
+[保存M函数](,EM_motion_RK4)

测试(M函数):...
%}

function [x,y,v_x,v_y]=EM_motion_RK4(x,y,v_x,v_y,Delta_t,t,q,m,B_z,E_x,E_y)
%{
physics_constant;
q=-1;
m=1;
Delta_t=0.1;
x=0;
y=0;
v_x=1;
v_y=0;
N=1000;

B_z=@(x,y)1;
E_x=@(x,y)1;
E_y=@(x,y)0;
%}

f_1=@(t,x,y,v_x,v_y)v_x;
f_2=@(t,x,y,v_x,v_y)v_y;
f_3=@(t,x,y,v_x,v_y)(v_y.*B_z(x,y)+E_x(x,y)).*q./m;
f_4=@(t,x,y,v_x,v_y)(-v_x.*B_z(x,y)+E_y(x,y)).*q./m;

a_1=f_1(t,x,y,v_x,v_y);
a_2=f_2(t,x,y,v_x,v_y);
a_3=f_3(t,x,y,v_x,v_y);
a_4=f_4(t,x,y,v_x,v_y);

b_1=f_1(t+Delta_t./2,x+Delta_t./2.*a_1,y+Delta_t./2.*a_2,...
    v_x+Delta_t./2.*a_3,v_y+Delta_t./2.*a_4);
b_2=f_2(t+Delta_t./2,x+Delta_t./2.*a_1,y+Delta_t./2.*a_2,...
    v_x+Delta_t./2.*a_3,v_y+Delta_t./2.*a_4);
b_3=f_3(t+Delta_t./2,x+Delta_t./2.*a_1,y+Delta_t./2.*a_2,...
    v_x+Delta_t./2.*a_3,v_y+Delta_t./2.*a_4);
b_4=f_4(t+Delta_t./2,x+Delta_t./2.*a_1,y+Delta_t./2.*a_2,...
    v_x+Delta_t./2.*a_3,v_y+Delta_t./2.*a_4);

c_1=f_1(t+Delta_t./2,x+Delta_t./2.*b_1,y+Delta_t./2.*b_2,...
    v_x+Delta_t./2.*b_3,v_y+Delta_t./2.*b_4);
c_2=f_2(t+Delta_t./2,x+Delta_t./2.*b_1,y+Delta_t./2.*b_2,...
    v_x+Delta_t./2.*b_3,v_y+Delta_t./2.*b_4);
c_3=f_3(t+Delta_t./2,x+Delta_t./2.*b_1,y+Delta_t./2.*b_2,...
    v_x+Delta_t./2.*b_3,v_y+Delta_t./2.*b_4);
c_4=f_4(t+Delta_t./2,x+Delta_t./2.*b_1,y+Delta_t./2.*b_2,...
    v_x+Delta_t./2.*b_3,v_y+Delta_t./2.*b_4);

d_1=f_1(t+Delta_t,x+Delta_t.*c_1,y+Delta_t.*c_2,...
    v_x+Delta_t.*c_3,v_y+Delta_t.*c_4);
d_2=f_2(t+Delta_t,x+Delta_t.*c_1,y+Delta_t.*c_2,...
    v_x+Delta_t.*c_3,v_y+Delta_t.*c_4);
d_3=f_3(t+Delta_t,x+Delta_t.*c_1,y+Delta_t.*c_2,...
    v_x+Delta_t.*c_3,v_y+Delta_t.*c_4);
d_4=f_4(t+Delta_t,x+Delta_t.*c_1,y+Delta_t.*c_2,...
    v_x+Delta_t.*c_3,v_y+Delta_t.*c_4);

x=x+Delta_t/6*(a_1+2*b_1+2*c_1+d_1);
y=y+Delta_t/6*(a_2+2*b_2+2*c_2+d_2);
v_x=v_x+Delta_t/6*(a_3+2*b_3+2*c_3+d_3);
v_y=v_y+Delta_t/6*(a_4+2*b_4+2*c_4+d_4);

end


%{
记住"Matlab"
+[M函数](,验证公式)
%}

