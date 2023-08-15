%{
+[返回目录]

地址::MATLAB\OPA\X_BBO.m
+[保存文本](,X_BBO)
%}


function X2EE=X_BBO(E)
%E=[0,1,1];

X(2,2,2)=2.2e-12/2;
X(2,1,1)=-X(2,2,2);
X(1,2,1)=-X(2,2,2);
X(1,1,2)=-X(2,2,2);

X(3,2,2)=-0.07*2.2e-12/2;
X(2,3,2)=X(3,2,2);
X(2,2,3)=X(3,2,2);
X(3,1,1)=X(3,2,2);
X(1,3,1)=X(3,2,2);
X(1,1,3)=X(3,2,2);

X2EE=zeros(3,3);
for i=1:3
    for n=1:3
        for j=1:3
            for k=1:3
                for m=1:3
                
                X2EE(i,n)=X2EE(i,n)+X(i,j,k)*X(k,m,n)*E(j)*E(m)';
                
                end
            end
        end
    end
end
