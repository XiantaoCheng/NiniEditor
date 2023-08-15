%{
Hussar的n_bbo
地址::MATLAB\OPA\n_bbo.m
+[保存文本](,n_bbo)

BBO性质
Smellmeier Equations::https://www.unitedcrystals.com/BBOProp.html
+[打开](,Smellmeier Equations)

测试(M函数):...
+[新建阅读窗口](,测试)
这个n_bbo不太好用, E和传播方向不一定匹配. 在给定了传播方向后, 偏振方向就确定了
写一个函数, 自动输出偏振方向
(晶轴朝向z轴方向)

n_BBO(M函数):...

%}

function n=n_bbo(lambda_0,alpha,beta,E)
lambda_0=lambda_0/1e-6;
no=sqrt(2.7359+0.01878/(lambda_0^2-0.01822)-0.01354*lambda_0^2);
ne=sqrt(2.3753+0.01224/(lambda_0^2-0.01667)-0.01516*lambda_0^2);

%alpha=30;
%beta=45;


M=@(alpha,beta,gamma)[cosd(gamma) -sind(gamma) 0;
   sind(gamma)  cosd(gamma) 0;
          0           0     1]*[cosd(beta) 0 -sind(beta);
         0      1     0;
     sind(beta) 0  cosd(beta)]*[cosd(alpha)  sind(alpha) 0;
    -sind(alpha)  cosd(alpha) 0;
            0           0     1];
T=M(alpha,beta,0);
N=@(ne,no,alpha,beta)M(alpha,beta,0)'*[1/no^2   0   0;
	       0  1/no^2   0;
               0   0  1/ne^2]*M(alpha,beta,0);


N_co=N(ne,no,alpha,beta);
E=E/norm(E);
n=1/sqrt(E'*N_co*E);
end