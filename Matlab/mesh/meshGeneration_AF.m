%% 20230423
%% from 文档/数学问题/有限元分析.ftxt
%{
地址::Matlab/mesh/meshGeneration_AF.m
+[保存M函数](,meshGeneration_AF)
faces
测试:...
测试2:...
+[M函数](,测试2)
%}

function [pts_x,pts_y,lines_1,lines_2,faces]=meshGeneration_AF(x_bd_0,y_bd_0,bd_lines_1,bd_lines_2,N,ratio,Dr0)

% addpath('Matlab/mesh')
% addpath('Matlab/space')
% addpath('Matlab/draw')

% t=linspace(0,360,20);
% R=5;
% ratio=0.9;
% ratio=0.3;
% Dr0=0.3;
% x_bd_0=R*cosd(t(1:end-1));
% y_bd_0=R*sind(t(1:end-1));

% bd_lines_1=1:length(x_bd_0);
% bd_lines_2=[length(x_bd_0),1:length(x_bd_0)-1];
bd_pts_x=x_bd_0;
bd_pts_y=y_bd_0;

pts_x=x_bd_0;
pts_y=y_bd_0;
lines_1=bd_lines_1;
lines_2=bd_lines_2;
bd_lines_i=1:length(lines_1);
faces=[];


for i=1:N
[state,pts_tri,lines_tri]=hasInterTriangle(1,bd_lines_1,bd_lines_2);
if state
    n_del=rmInterTriangle(pts_tri,lines_tri,bd_lines_1,bd_lines_2);
    face=bd_lines_i(lines_tri);
    bd_pts_x(pts_tri(n_del))=nan;
    bd_pts_y(pts_tri(n_del))=nan;
    bd_lines_1(lines_tri)=[];
    bd_lines_2(lines_tri)=[];
    bd_lines_i(lines_tri)=[];

    faces(:,end+1)=face';
    if isempty(bd_lines_1)
        break;
    else
        continue
    end
else
    face=bd_lines_i(1);
    is=[bd_lines_1(1),bd_lines_2(1)];
end

x0=mean(pts_x(is));
y0=mean(pts_y(is));

Dx=-diff(bd_pts_y(is));
Dy=diff(bd_pts_x(is));
L=sqrt(Dx^2+Dy^2);

x_n=x0-Dx*sqrt(3)/2;
y_n=y0-Dy*sqrt(3)/2;

Dr=ratio*L;
Dr=max([Dr,Dr0]);

n0=pickUpExistedPt(x_n,y_n,Dr,is,pts_x,pts_y,bd_pts_x,bd_pts_y,bd_lines_1,bd_lines_2);

% if isempty(rs(rs<Dr))
if isnan(n0)
    pts_x(end+1)=x_n;
    pts_y(end+1)=y_n;
    bd_pts_x(end+1)=x_n;
    bd_pts_y(end+1)=y_n;

    n0=length(pts_x);
    lines_1(end+1:end+2)=[is(1),n0];
    lines_2(end+1:end+2)=[n0,is(2)];
    bd_lines_1(end+1:end+2)=[is(1),n0];
    bd_lines_2(end+1:end+2)=[n0,is(2)];
    bd_lines_i(end+1:end+2)=[-1,0]+length(lines_1);
    face(end+1:end+2)=[length(lines_1)-1,length(lines_1)];

else
% plot(pts_x(n0),pts_y(n0),'r*')
    con_n=[bd_lines_2(bd_lines_1==n0),bd_lines_1(bd_lines_2==n0)];

    if isempty(con_n(is(1)==con_n))
        lines_1(end+1)=is(1);
        lines_2(end+1)=n0;
        face(end+1)=length(lines_1);
        bd_lines_1(end+1)=is(1);
        bd_lines_2(end+1)=n0;
        bd_lines_i(end+1)=length(lines_1);

    else
        bd_pts_x(is(1))=nan;
        bd_pts_y(is(1))=nan;
        k=find(bd_lines_1==n0&bd_lines_2==is(1));
        if ~isempty(k)
            face(end+1)=bd_lines_i(k);
            bd_lines_1(k)=[];
            bd_lines_2(k)=[];
            bd_lines_i(k)=[];
        else 
            k=find(bd_lines_2==n0&bd_lines_1==is(1));
            face(end+1)=bd_lines_i(k);
            bd_lines_1(k)=[];
            bd_lines_2(k)=[];
            bd_lines_i(k)=[];
        end
    end

    if isempty(con_n(is(2)==con_n))
        lines_1(end+1)=n0;
        lines_2(end+1)=is(2);
        face(end+1)=length(lines_1);
        bd_lines_1(end+1)=n0;
        bd_lines_2(end+1)=is(2);
        bd_lines_i(end+1)=length(lines_1);

    else
        bd_pts_x(is(2))=nan;
        bd_pts_y(is(2))=nan;
        k=find(bd_lines_1==n0&bd_lines_2==is(2));
        if ~isempty(k)
            face(end+1)=bd_lines_i(k);
            bd_lines_1(k)=[];
            bd_lines_2(k)=[];
            bd_lines_i(k)=[];
        else
            k=find(bd_lines_2==n0&bd_lines_1==is(2));
            face(end+1)=bd_lines_i(k);
            bd_lines_1(k)=[];
            bd_lines_2(k)=[];
            bd_lines_i(k)=[];
        end

    end


end

bd_lines_1(1)=[];
bd_lines_2(1)=[];
bd_lines_i(1)=[];
faces(:,end+1)=face';

if isempty(bd_lines_1)
    break;
end

end

end

%{
+[保存M函数](,meshGeneration_AF)
%}

