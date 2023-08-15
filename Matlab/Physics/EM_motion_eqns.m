%% 20230219
%% from 文档\数学问题\龙格库塔方法.ftxt
%{
地址::Matlab/Physics/EM_motion_eqns.m
+[保存M函数](,EM_motion_eqns)
%}

function y=EM_motion_eqns(t,x,q,m,B_z,E_x,E_y)

y=zeros(size(x));
y(1,:)=x(3,:);
y(2,:)=x(4,:);
y(3,:)=(x(4,:).*B_z(x(1,:),x(2,:))+E_x(x(1,:),x(2,:))).*q./m;
y(4,:)=(-x(3,:).*B_z(x(1,:),x(2,:))+E_y(x(1,:),x(2,:))).*q./m;

end



