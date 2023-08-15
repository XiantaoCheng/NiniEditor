%% 20230422
%% from 文档/数学问题/有限元分析.ftxt
%{
地址::Matlab/mesh/bdFormPolygon.m
+[保存M函数](,bdFormPolygon)

获取数据:...
测试:...
+[新建阅读窗口](,测试)

%}

function [xs,ys,ns]=bdFormPolygon(pts_x,pts_y,lines_1,lines_2,i0)

n0=lines_1(i0);
xs=pts_x(n0);
ys=pts_y(n0);
ns=n0;
n=lines_2(i0);

for i=1:length(pts_x)
xs(end+1)=pts_x(n);
ys(end+1)=pts_y(n);
ns(end+1)=n;

k=find(lines_1==n);
if isempty(k)
    break;
elseif length(k)>1
    for j=1:length(k)
        if ~sum(lines_2(k(j))==ns)
            k=k(j);
            break;
        elseif lines_2(k(j))==n0
            k=k(j);
            break;
        end
    end
    k=k(1);
end

n=lines_2(k);

if n==n0
    break;
end
end

xs(end+1)=xs(1);
ys(end+1)=ys(1);
ns(end+1)=ns(1);

end

%{
+[保存M函数](,bdFormPolygon)
%}

