%{
+[M函数](,model_lens)
+[新建阅读窗口](,model_lens)
地址::Matlab\space\model_lens.m
+[保存文本](,model_lens)

参考::文档\S应用\光路场景.ftxt
的(参考,镜子)->的(镜子,验证透镜)->+[H函数](,镜子)

框架:...
代码测试(M函数):...

%}

function model_lens(D,dc,R1,R2,Eulers,orig_0)

%D=1;
%dc=0.1;
%R1=2;
%R2=-20;

%orig_0=[0,0,10];
%Eulers=[90,90,0];


N=20;
N2=21;

theta1=asind(D/2/R1);
theta2=asind(D/2/R2);
de=dc-R1*(1-cosd(theta1))-R2*(1-cosd(theta2));
z01=-R1*cosd(theta1);
z02=R2*cosd(theta2)-de;


t1=linspace(0,theta1,N);
t2=linspace(-theta2,0,N)+180;

r1=R1*sind(t1);
z1=R1*cosd(t1)+z01;
r2=R2*sind(t2);
z2=R2*cosd(t2)+z02;

r=[r1,r2];
z=[z1,z2];

t=linspace(0,360,N2);
[R,T]=meshgrid(r,t);
[Z,T]=meshgrid(z,t);

X=R.*cosd(T);
Y=R.*sind(T);

alpha=Eulers(1);
beta=Eulers(2);
gamma=Eulers(3);

[X,Y,Z]=transform_3D(orig_0,alpha,beta,gamma,X,Y,Z);

plot3(X(:,N),Y(:,N),Z(:,N),'k',X(:,N+1),Y(:,N+1),Z(:,N+1),'k')
for i=1:2*N-1
    fill_3D(X(:,i),Y(:,i),Z(:,i),X(:,i+1),Y(:,i+1),Z(:,i+1),[0.9,0.9,1]);
end

end

%{
+[M函数](,model_lens)
%}