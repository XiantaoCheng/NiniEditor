%% 20221224
%% from 文档\S应用\运动场景.ftxt
%{
地址::Matlab\draw\draw_arrow_rt.m
+[保存M函数](,draw_arrow_rt)
%}

function [x,y]=draw_arrow_rt(pt,an_0,omega_0,L,DW,DL)

if omega_0>0
an=linspace(an_0+30,an_0+250,100);
else
an=linspace(an_0-30,an_0-250,100);
end


xs=L*cosd(an)+pt(1);
ys=L*sind(an)+pt(2);

% xs=[0,v_0(1)]/norm(v_0)*L+pt(1);
% ys=[0,v_0(2)]/norm(v_0)*L+pt(2);

dxs=diff(xs([90,100]));
dys=diff(ys([90,100]));
drs=sqrt(dxs.^2+dys.^2);
dxs=dxs./drs;
dys=dys./drs;
v_x=[-dys(end),dxs(end)];
v_y=[dxs(end),dys(end)];


x_L=[-DW/2,0,DW/2];
y_L=-[DL,0,DL];

x_a=x_L*v_x(1)+y_L*v_y(1)+xs(end);
y_a=x_L*v_x(2)+y_L*v_y(2)+ys(end);

x=[xs,nan,x_a];
y=[ys,nan,y_a];

end

