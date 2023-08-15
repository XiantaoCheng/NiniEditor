%% 20220915
%% from 文档\S应用\三维建模.ftxt
%{
+[返回目录](,camera_lookat)
地址::Matlab\space\camera_lookat.m
+[保存M函数](,camera_lookat)

+[M函数](,camera_lookat)
问题(M函数):...
测试:...
+[新建阅读窗口](,测试)
%}

function Eulers=camera_lookat(r0,p0,theta)
%r0=[10,10,10];
%p0=[0,0,0];
%theta=0;

Z=p0-r0;
Z=Z/norm(Z);
beta=acosd(Z(3));
if beta==90 && Z(2)>0
beta=-90;
end

if beta==0 || beta==180
    alpha=0;
else
    alpha=sign(Z(1)/sind(beta))*acosd(-Z(2)/sind(beta));
end
gamma=theta;

Eulers=[alpha,beta,gamma];

end

%{
+[保存M函数](,camera_lookat)
%}

