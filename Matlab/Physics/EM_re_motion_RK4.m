%% 20230106
%% from 文档\数学问题\龙格库塔方法.ftxt
%{
地址::Matlab\Physics\EM_re_motion_RK4.m
+[保存M函数](,EM_re_motion_RK4)

测试(M函数):...
+[新建阅读窗口](,测试)
将'测试'的"v"替换为"p"
%}

function [x,y,p_x,p_y]=EM_re_motion_RK4(x,y,p_x,p_y,Delta_t,t,q,m,B_z,E_x,E_y)
physics_constant;

f_1=@(t,x,y,p_x,p_y)c.*p_x./sqrt(p_x.^(2)+p_y.^(2)+m.^(2).*c.^(2));
f_2=@(t,x,y,p_x,p_y)c.*p_y./sqrt(p_x.^(2)+p_y.^(2)+m.^(2).*c.^(2));
f_3=@(t,x,y,p_x,p_y)q.*(c.*p_y.*B_z(x,y)./sqrt(p_x.^(2)+p_y.^(2)+m.^(2).*c.^(2))+E_x(x,y));
f_4=@(t,x,y,p_x,p_y)q.*(-c.*p_x.*B_z(x,y)./sqrt(p_x.^(2)+p_y.^(2)+m.^(2).*c.^(2))+E_y(x,y));

a_1=f_1(t,x,y,p_x,p_y);
a_2=f_2(t,x,y,p_x,p_y);
a_3=f_3(t,x,y,p_x,p_y);
a_4=f_4(t,x,y,p_x,p_y);

b_1=f_1(t+Delta_t./2,x+Delta_t./2.*a_1,y+Delta_t./2.*a_2,...
    p_x+Delta_t./2.*a_3,p_y+Delta_t./2.*a_4);
b_2=f_2(t+Delta_t./2,x+Delta_t./2.*a_1,y+Delta_t./2.*a_2,...
    p_x+Delta_t./2.*a_3,p_y+Delta_t./2.*a_4);
b_3=f_3(t+Delta_t./2,x+Delta_t./2.*a_1,y+Delta_t./2.*a_2,...
    p_x+Delta_t./2.*a_3,p_y+Delta_t./2.*a_4);
b_4=f_4(t+Delta_t./2,x+Delta_t./2.*a_1,y+Delta_t./2.*a_2,...
    p_x+Delta_t./2.*a_3,p_y+Delta_t./2.*a_4);

c_1=f_1(t+Delta_t./2,x+Delta_t./2.*b_1,y+Delta_t./2.*b_2,...
    p_x+Delta_t./2.*b_3,p_y+Delta_t./2.*b_4);
c_2=f_2(t+Delta_t./2,x+Delta_t./2.*b_1,y+Delta_t./2.*b_2,...
    p_x+Delta_t./2.*b_3,p_y+Delta_t./2.*b_4);
c_3=f_3(t+Delta_t./2,x+Delta_t./2.*b_1,y+Delta_t./2.*b_2,...
    p_x+Delta_t./2.*b_3,p_y+Delta_t./2.*b_4);
c_4=f_4(t+Delta_t./2,x+Delta_t./2.*b_1,y+Delta_t./2.*b_2,...
    p_x+Delta_t./2.*b_3,p_y+Delta_t./2.*b_4);

d_1=f_1(t+Delta_t,x+Delta_t.*c_1,y+Delta_t.*c_2,...
    p_x+Delta_t.*c_3,p_y+Delta_t.*c_4);
d_2=f_2(t+Delta_t,x+Delta_t.*c_1,y+Delta_t.*c_2,...
    p_x+Delta_t.*c_3,p_y+Delta_t.*c_4);
d_3=f_3(t+Delta_t,x+Delta_t.*c_1,y+Delta_t.*c_2,...
    p_x+Delta_t.*c_3,p_y+Delta_t.*c_4);
d_4=f_4(t+Delta_t,x+Delta_t.*c_1,y+Delta_t.*c_2,...
    p_x+Delta_t.*c_3,p_y+Delta_t.*c_4);

x=x+Delta_t/6*(a_1+2*b_1+2*c_1+d_1);
y=y+Delta_t/6*(a_2+2*b_2+2*c_2+d_2);
p_x=p_x+Delta_t/6*(a_3+2*b_3+2*c_3+d_3);
p_y=p_y+Delta_t/6*(a_4+2*b_4+2*c_4+d_4);

end


%{
记住"Matlab"
+[M函数](,验证公式)
%}

