%% 20221224
%% from 文档\物理问题\刚体运动.ftxt
%{
地址::Matlab\Physics\rigid_bodies_collision_2.m
+[保存M函数](,rigid_bodies_collision_2)

测试:...
%}

function [v_1,omega_1,v_2,omega_2,k_1,k_2]=rigid_bodies_collision_2(u_1,w_1,u_2,w_2,m_1,xs_1,ys_1,m_2,xs_2,ys_2)

addpath('Matlab\draw');
% addpath('Matlab\Physics');


pt_c_1=[mean(xs_1),mean(ys_1)];
pt_c_2=[mean(xs_2),mean(ys_2)];
r=sqrt((xs_1-pt_c_1(1)).^2+(ys_1-pt_c_1(2)).^2);
I_1=m_1*sum(r.^2);
r=sqrt((xs_2-pt_c_2(1)).^2+(ys_2-pt_c_2(2)).^2);
I_2=m_2*sum(r.^2);

xs_bd_1=[xs_1,xs_1(1)];
ys_bd_1=[ys_1,ys_1(1)];
xs_bd_2=[xs_2,xs_2(1)];
ys_bd_2=[ys_2,ys_2(1)];
[xs0,ys0,L1_i,L2_i]=intersection_curve_curve(xs_bd_1,ys_bd_1,xs_bd_2,ys_bd_2);

if std(L1_i)<std(L2_i)
    i_s1=[diff(xs_bd_1(L1_i(1):L1_i(1)+1)),diff(ys_bd_1(L1_i(1):L1_i(1)+1))];
else
    i_s1=[diff(xs_bd_2(L2_i(1):L2_i(1)+1)),diff(ys_bd_2(L2_i(1):L2_i(1)+1))];
end
i_s1=i_s1/norm(i_s1);
i_s2=[-i_s1(2),i_s1(1)];

pt_col=[xs0(1),ys0(1)];
r_1=pt_col-pt_c_1;
r_2=pt_col-pt_c_2;

i_1r=[-r_1(2),r_1(1)];
i_2r=[-r_2(2),r_2(1)];
i_1r=i_1r/norm(i_1r);
i_2r=i_2r/norm(i_2r);
r_1=norm(r_1);
r_2=norm(r_2);

[v_1,omega_1,v_2,omega_2,k_1,k_2]=rigid_bodies_collision(u_1,w_1,u_2,w_2,m_1,I_1,r_1,m_2,I_2,r_2,i_1r,i_2r,i_s2,i_s2);



end




