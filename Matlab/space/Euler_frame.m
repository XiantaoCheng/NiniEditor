%{
+[M函数](,Euler_frame)
地址::Matlab\space\Euler_frame.m
+[保存文本](,Euler_frame)
%}


function [X,Y,Z]=Euler_frame(alpha,beta,gamma)


% Dr=[1,1,1];
% alpha=45;
% beta=45;
% gamma=0; 


X=[
-sind(gamma)*sind(alpha)*cosd(beta)+cosd(gamma)*cosd(alpha),
sind(gamma)*cosd(alpha)*cosd(beta)+cosd(gamma)*sind(alpha),
sind(gamma)*sind(beta)]';


Y=[
-cosd(gamma)*sind(alpha)*cosd(beta)-sind(gamma)*cosd(alpha),
cosd(gamma)*cosd(alpha)*cosd(beta)-sind(gamma)*sind(alpha),
cosd(gamma)*sind(beta)]';


Z=[
sind(alpha)*sind(beta),
-cosd(alpha)*sind(beta),
cosd(beta)]';

end

