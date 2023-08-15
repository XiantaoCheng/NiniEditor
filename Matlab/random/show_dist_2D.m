%% 20230222
%% from 文档\数学问题\随机分布.ftxt
%{
地址::Matlab\random\show_dist_2D.m
+[保存M函数](,show_dist_2D)
%}

function [I,tX,tY]=show_dist_2D(Tx,Ty,N_1,N_2,range)

if nargin>4
    tx_1=range(1);
    tx_2=range(2);
    ty_1=range(3);
    ty_2=range(4);
else
    tx_1=min(Tx);
    tx_2=max(Tx);
    ty_1=min(Ty);
    ty_2=max(Ty);
end

tx=linspace(tx_1,tx_2,N_1);
ty=linspace(ty_1,ty_2,N_2);
[tX,tY]=meshgrid(tx,ty);
I=zeros(size(tX));

I=zeros(size(tX));
for i=1:size(tX,1)-1
    for j=1:size(tX,2)-1
        In=find(Ty>=tY(i,j)&Ty<tY(i+1,j) & Tx>=tX(i,j)&Tx<tX(i,j+1));
        I(i,j)=numel(In);
    end
end

end

