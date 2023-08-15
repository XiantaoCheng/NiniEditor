%{
+[返回目录](,field_fun)
地址::Matlab\Physics\field_fun.m
+[保存文本](,field_fun)

+[matlabStart](,Matlab)
+[M函数](,field_fun)

field_fun:...
%}

function field=field_fun(X,k,omega,dx,t,t0,v)

physics_constant;
%t0=200e-6/c;
%t=500e-6/c;
%X=0:300;
%dx=50.8e-9;
%v=0.9971;

if t<t0
    x1=0;
else
    x1=(t-t0)*v*c;
end
x=x1+X*dx;

field=cos(omega*t-k*x);

end