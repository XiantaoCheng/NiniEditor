%% 20230422
%% from 文档\计算机问题\合并多边形.ftxt
%{
地址::Matlab\space\PtsInPolygon.m
+[保存M函数](,PtsInPolygon)

测试:...
含顶点:...
%}

function [n_i,n_w]=PtsInPolygon(x1,y1,xs,ys)

xs(end+1,:)=max(x1)+3;
ys(end+1,:)=ys;
n_i=zeros(1,size(xs,2));
n_w=zeros(1,size(xs,2));

for k=1:size(xs,2)
    ns=find(xs(1,k)==x1 & ys(1,k)==y1);
    if isempty(ns)
        [x0,y0,i]=intersection_line_curve(xs(:,k),ys(:,k),x1,y1);

        if length(i)>1
            n_nodes=length(x0(abs(x0-x0([2:end,1]))<1e-10...
                & abs(y0-y0([2:end,1]))<1e-10));
        else
            n_nodes=0;
        end

        n_w(k)=sum(sign(ys(1,k)-y1(i)));
        n_i(k)=1-mod(length(i)-n_nodes,2);

%         n_w(k)=sum(sign(ys(1,k)-y1(i)));
%         n_i(k)=1-mod(length(i),2);
    
    else
        n_w(k)=0;
        n_i(k)=1;
    
    end
end

end

%{
+[保存M函数](,PtsInPolygon)
%}

