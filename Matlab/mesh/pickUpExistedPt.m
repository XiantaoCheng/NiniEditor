%% 20230422
%% from 文档/数学问题/有限元分析.ftxt
%{
地址::Matlab/mesh/pickUpExistedPt.m
+[保存M函数](,pickUpExistedPt)

测试区域:...
测试区域2:...
测试区域3:...
+[新建阅读窗口](,测试区域3)

intersection_line_lines_2(M函数):...
保存:...
%}

function n0=pickUpExistedPt(x_n,y_n,Dr,is,pts_x,pts_y,bd_pts_x,bd_pts_y,bd_lines_1,bd_lines_2)

n0=nan;
rs=sqrt((bd_pts_x-x_n).^2+(bd_pts_y-y_n).^2);
if ~isempty(rs(rs<Dr))
    n0=find(rs==min(rs));
    n0=n0(1);
end

ax=[x_n,pts_x(is),x_n];
ay=[y_n,pts_y(is),y_n];
[n_i,n_w]=PtsInPolygon(ax,ay,pts_x,pts_y);
if ~isempty(n_i(n_i==0))
    n1=find(n_i==0);
    n1(n1==is(1))=[];
    n1(n1==is(2))=[];
    if ~isempty(n1)
        n0=n1(1);
    end
end

if ~isnan(n0)
    x_n=pts_x(n0);
    y_n=pts_y(n0);
end

for i=1:2
    x1=[x_n,pts_x(is(i))];
    y1=[y_n,pts_y(is(i))];
    
    xs(1,:)=pts_x(bd_lines_1);
    ys(1,:)=pts_y(bd_lines_1);
    xs(2,:)=pts_x(bd_lines_2);
    ys(2,:)=pts_y(bd_lines_2);
    
    [x0,y0,li]=intersection_line_lines_2(x1,y1,xs,ys);
    li(abs(x0-x1(2))<1e-10&abs(y0-y1(2))<1e-10)=nan;
    li(abs(x0-x1(1))<1e-10&abs(y0-y1(1))<1e-10)=nan;
    li(isnan(li))=[];
    if ~isempty(li)
        % n0=bd_lines_1(li(1));
        ns=[bd_lines_1(li),bd_lines_2(li)];
        ns(ns==is(1))=[];
        ns(ns==is(2))=[];
        xs=pts_x(ns);
        ys=pts_y(ns);
        rs=sqrt((xs-mean(pts_x(is))).^2+(ys-mean(pts_y(is))).^2);
        n0=ns(rs==min(rs));
        n0=n0(1);

        break;
    end
end
end

%{
+[保存M函数](,pickUpExistedPt)
%}

