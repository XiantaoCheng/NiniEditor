%% 20220821
%% from 文档\物理问题\plasma.ftxt
%{
地址::Matlab\Smilei\Boris_relativistic_osc.m
+[保存M函数](,Boris_relativistic_osc)
%}

function [x,y,z,v_x,v_y,v_z]=Boris_relativistic_osc(pt,v,dt,Ex,Ey,Ez,Bx,By,Bz,m,q)

physics_constant;

if nargin<10
m=m_e;
end
if nargin<11
q=e;
end

x=zeros(size(Ex));
y=zeros(size(Ex));
z=zeros(size(Ex));

v_x=zeros(size(Ex));
v_y=zeros(size(Ex));
v_z=zeros(size(Ex));

x0=pt(1);
y0=pt(2);
z0=pt(3);

v0_x=v(1);
v0_y=v(2);
v0_z=v(3);

for i=1:length(Ex)
[x0,y0,z0,v0_x,v0_y,v0_z]=BorisPusher(x0,y0,z0,v0_x,v0_y,v0_z,dt,[Ex(i),Ey(i),Ez(i)],[Bx(i),By(i),Bz(i)],m,q);

x(i)=x0;
y(i)=y0;
z(i)=z0;

v_x(i)=v0_x;
v_y(i)=v0_y;
v_z(i)=v0_z;
end

end





