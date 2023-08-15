%% 20230219
%% from 文档\数学问题\龙格库塔方法.ftxt
%{
地址::Matlab/Physics/EM_motion_ODEs.m
+[保存M函数](,EM_motion_ODEs)

测试:...
%}

function [x,y,v_x,v_y]=EM_motion_ODEs(x0,y0,v_x0,v_y0,t,q,m,B_z,E_x,E_y,ode_type)

tspan=[min(t),max(t)];
f=@(t,x)EM_motion_eqns(t,x,q,m,B_z,E_x,E_y);

for i=1:length(x0)
fy0=[x0(i),y0(i),v_x0(i),v_y0(i)]';
% fy0=[x0,y0,v_x0,v_y0]'

if strcmp(ode_type,'ode45')
    [t_ode,fy_t]=ode45(f,tspan,fy0);
elseif strcmp(ode_type,'ode15s')
    [t_ode,fy_t]=ode45(f,tspan,fy0);
else
    [t_ode,fy_t]=ode45(f,tspan,fy0);
end

x(:,i)=interp1(t_ode,fy_t(:,1),t);
y(:,i)=interp1(t_ode,fy_t(:,2),t);
v_x(:,i)=interp1(t_ode,fy_t(:,3),t);
v_y(:,i)=interp1(t_ode,fy_t(:,4),t);

end

end



