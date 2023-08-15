%% 20221224
%% from 文档\S应用\运动场景.ftxt
%{
地址::Matlab\draw\draw_arrow_2.m
+[保存M函数](,draw_arrow_2)
%}

function [x,y]=draw_arrow_2(pt,v_0,L,DW,DL)

xs=[0,v_0(1)]/norm(v_0)*L+pt(1);
ys=[0,v_0(2)]/norm(v_0)*L+pt(2);

dxs=diff(xs);
dys=diff(ys);
drs=sqrt(dxs.^2+dys.^2);
dxs=dxs./drs;
dys=dys./drs;
v_x=[-dys(1),dxs(1)];
v_y=[dxs(1),dys(1)];


x_L=[-DW/2,0,DW/2];
y_L=-[DL,0,DL];

x_a=x_L*v_x(1)+y_L*v_y(1)+xs(end);
y_a=x_L*v_x(2)+y_L*v_y(2)+ys(end);

x=[xs,nan,x_a];
y=[ys,nan,y_a];

end

