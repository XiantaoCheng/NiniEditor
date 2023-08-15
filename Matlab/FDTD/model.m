%{
+[返回目录](,数值模型)
+[M函数](,数值模型)
地址::Matlab\FDTD\model.m
+[保存文本](,数值模型)

测试(M函数):...
+[M函数](,测试)
%}

function [x_E,Ex,Ey,x_B,Bx,By]=model(dx,dt,N,T,lm0,A,E0,n_e,show_mode)
physics_constant;

%dx=50e-9;
%dt=dx/c;

%N=1000;
%T=1000;

%lm0=500e-9;
%A=[1,1i];
%E0=1e10;


fx=@(t)A(1)*exp(-1i*2*pi*t*c/lm0);
fy=@(t)A(2)*exp(-1i*2*pi*t*c/lm0);

t1=(1:T)*dt;
t2=(1:T)*dt+dt/2;
Ex_in=E0*real(fx(t1));
Ey_in=E0*real(fy(t1));
Bx_in=-E0/c*real(fy(t2));
By_in=E0/c*real(fx(t2));


x=(1:2*N-1)*dx/2;
x_E=x(1:2:2*N-1);
x_B=x(2:2:2*N-1);

Ex=zeros(1,N);
Ey=zeros(1,N);
Bx=zeros(1,N-1);
By=zeros(1,N-1);

Ex_out=zeros(1,T);
Ey_out=zeros(1,T);
Bx_out=zeros(1,T);
By_out=zeros(1,T);

Jx=zeros(1,N);
Jy=zeros(1,N);
Jz=zeros(1,N);

wp=sqrt(n_e*e^2/me/epsilon0);
v=0; 

for t=1:T
    % current
    Jx_0=Jx;
    Jy_0=Jy;
    Jx=(2-v*dt)/(2+v*dt)*Jx+(2*epsilon0*wp^2*dt)/(2+v*dt)*Ex;
    Jy=(2-v*dt)/(2+v*dt)*Jy+(2*epsilon0*wp^2*dt)/(2+v*dt)*Ey;


    dEx=zeros(size(Ex));
    dEy=zeros(size(Ey));
    Ex(1)=Ex_in(t);
    Ey(1)=Ey_in(t);
    Bx(1)=Bx_in(t);
    By(1)=By_in(t);

    Ex(N)=Ex(N-1);
    Ey(N)=Ey(N-1);
    for i=2:N-1
        dEx(i)=-(By(i)-By(i-1))*c^2/dx;
        dEy(i)=(Bx(i)-Bx(i-1))*c^2/dx;
    end
    dEx=dEx-mu0*(Jx+Jx_0)/2;
    dEy=dEy-mu0*(Jy+Jy_0)/2;
    Ex=Ex+dEx*dt;
    Ey=Ey+dEy*dt;


    dBx=zeros(size(Bx));
    dBy=zeros(size(By));
    for i=1:N-1
        dBx(i)=(Ey(i+1)-Ey(i))/dx;
        dBy(i)=-(Ex(i+1)-Ex(i))/dx;
    end
    Bx=Bx+dBx*dt;
    By=By+dBy*dt;

    

    if mod(t,15)==1 && show_mode==1
        subplot(2,2,1)
        plot(x_E/1e-6,Ex);
        xlabel('x [um]')
        title('E_x')

        subplot(2,2,2)
        plot(x_E/1e-6,Ey);
        xlabel('x [um]')
        title('E_y')

        subplot(2,2,3)
        plot(x_E/1e-6,Jx);
        xlabel('x [um]')
        title('J_x')

        subplot(2,2,4)
        plot(x_E/1e-6,Jy);
        xlabel('x [um]')
        title('J_y')
        pause(0.01)
    end

    Ex_out(t)=Ex(end);
    Ey_out(t)=Ey(end);
    Bx_out(t)=Bx(end);
    By_out(t)=By(end);

end


%{
+[M函数](,等离子体FDTD)
等离子体折射率(html):...
+[H函数](,等离子体折射率)
检验模型:...
%}
