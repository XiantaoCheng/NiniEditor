%% 20220915
%% from 文档\数学问题\三维旋转.ftxt
%{
+[M函数](,frame2Eulers)

地址::Matlab\space\frame2Eulers.m
+[保存M函数](,frame2Eulers)
%}


function Eulers=frame2Eulers(X,Y,Z)

X=X/norm(X);
Y=Y/norm(Y);
Z=Z/norm(Z);

beta=acosd(Z(3));

if sind(beta)==0
    alpha=0;
    gamma=-sign_1(Y(1))*acosd(Y(2)/cosd(beta));
else
    alpha=sign_1(Z(1)/sind(beta)).*acosd(-Z(2)/sind(beta));
    gamma=sign_1(X(3))*acosd(Y(3)/sind(beta));
end

Eulers=[alpha,beta,gamma];

end


