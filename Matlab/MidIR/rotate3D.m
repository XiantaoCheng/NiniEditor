%{
+[返回目录]

地址::Matlab\MidIR\rotate3D.m
+[保存文本](,三维旋转)

%}

function [X1,Y1,Z1]=rotate3D(alpha,beta,gamma,X,Y,Z)
%alpha=70;
%beta=45;
%gamma=00;


M=[cosd(gamma) -sind(gamma) 0;
   sind(gamma)  cosd(gamma) 0;
          0           0     1]*[cosd(beta) 0 -sind(beta);
         0      1     0;
     sind(beta) 0  cosd(beta)]*[cosd(alpha)  sind(alpha) 0;
    -sind(alpha)  cosd(alpha) 0;
            0           0     1];
pts=zeros(numel(X),3);
pts(:,1)=reshape(X,numel(X),1);
pts(:,2)=reshape(Y,numel(Y),1);
pts(:,3)=reshape(Z,numel(Z),1);

pts=pts*M;

X1=reshape(pts(:,1),size(X));
Y1=reshape(pts(:,2),size(Y));
Z1=reshape(pts(:,3),size(Z));

%A=[0,0,1];
%B=A*M(alpha,beta,gamma);

%hold on;
%plot3([0,A(1)],[0,A(2)],[0,A(3)])
%plot3([0,B(1)],[0,B(2)],[0,B(3)])
%grid on
%xlabel('X');
%ylabel('Y');
%zlabel('Z');

end