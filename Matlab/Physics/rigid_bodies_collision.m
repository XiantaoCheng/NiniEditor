%% 20221223
%% from 文档\物理问题\刚体运动.ftxt
%{
地址::Matlab\Physics\rigid_bodies_collision.m

测试(M函数):...
+[保存M函数](,rigid_bodies_collision)
%}

function [v_1,omega_1,v_2,omega_2,k_1,k_2]=rigid_bodies_collision(u_1,w_1,u_2,w_2,m_1,I_1,r_1,m_2,I_2,r_2,i_1r,i_2r,i_1s,i_2s)

%{
m_1=1;
m_2=2;
r_1=1;
r_2=1;
I_1=1;
I_2=10;

w_1=1;
w_2=1;

u_1=[1,0];
u_2=[0,0];

an_1r=20;
i_1r=[cosd(an_1r),sind(an_1r)];
i_2r=[cosd(an_1r),sind(an_1r)];
an_1s=100;
i_1s=[cosd(an_1s),sind(an_1s)];
i_2s=[cosd(an_1s),sind(an_1s)];
%}

A=m_1.*r_1.*i_1r;
B=m_2.*r_2.*i_2r;
A_1=sum(A.*i_1s./I_1);
B_1=sum(B.*i_2s./I_2);

k_1=(2.*(m_2.*sum(u_2.*i_2s)+I_2.*w_2.*B_1).*m_1./m_2-2.*(m_1.*sum(u_1.*i_1s)+I_1.*w_1.*A_1))./((m_1+I_1.*A_1.^(2))+(m_2+I_2.*B_1.^(2)).*m_1.^(2)./m_2.^(2));
v_1=i_1s.*k_1+u_1;
omega_1=A_1.*k_1+w_1;
k_2=-m_1./m_2.*k_1;
v_2=i_2s.*k_2+u_2;
omega_2=B_1.*k_2+w_2;

end

%{
+[M函数](,验证公式)
%}

