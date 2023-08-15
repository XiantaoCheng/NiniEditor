%% 20230129
%% from 文档\计算机问题\合并多边形.ftxt
%{
+[保存M函数](,shape_cut)
地址::Matlab\draw\shape_cut.m

测试:...
+[新建阅读窗口](,测试)
%}

function [x3,y3]=shape_cut(x1,y1,x2,y2)

if x1(end)~=x1(1) || y1(end)~=y1(1)
    x1(end+1)=x1(1);
    y1(end+1)=y1(1);
end

if x2(end)~=x2(1) || y2(end)~=y2(1)
    x2(end+1)=x2(1);
    y2(end+1)=y2(1);
end

[xs0,ys0,L1_i,L2_i]=intersection_curve_curve(x1,y1,x2,y2);

%{
+[保存M函数](,shape_merge)
%}

if isempty(L1_i)
    x3=x1;
    y3=y1;
else
    si=L1_i(1);
    x3=xs0(1);
    y3=ys0(1);
    shape_i=1;
    on_intersection=1;

    % init direction
    dx=x1(si)-xs0(1);
    dy=y1(si)-ys0(1);
    L=sqrt(dx.^2+dy.^2);
    dx=dx/L*1e-7;
    dy=dy/L*1e-7;
    n_w=PtsInPolygon(x2,y2,xs0(1)+dx,ys0(1)+dy);
    
    if n_w==0
        ds=1;
    else
        ds=-1;
    end

    for i=1:200
        if shape_i==1
            xs=x1;
            ys=y1;
            xa=x2;
            ya=y2;
            L_i=L1_i;
            L_i_a=L2_i;
        else
            xs=x2;
            ys=y2;
            xa=x1;
            ya=y1;
            L_i=L2_i;
            L_i_a=L1_i;
        end

        j=find(si==L_i);

        if ~isempty(j)
            Dvx=-(xs(si)-x3(end))*ds;
            Dvy=-(ys(si)-y3(end))*ds;
            if on_intersection==1
                if length(j)==1
                    j=[];
                else
                    DL=(xs0(j)-x3(end)).*Dvx+(ys0(j)-y3(end)).*Dvy;
                    j=j(DL>0);
                    DL=DL(DL>0);
                    j=j(DL==min(DL));
                end
                if isempty(j) && ds>0
                    si=si+ds;
                    on_intersection=0;
                
                    if si==0
                        si=length(xs);
                    elseif si>length(xs)
                        si=1;
                    end
                    continue;
                end
            else
                if ds<0
                    L=sqrt((xs0(j)-x3(end)).^2+(ys0(j)-y3(end)).^2);
                    j=j(L==min(L));
                else
                    L=sqrt((xs0(j)-xs(si)).^2+(ys0(j)-ys(si)).^2);
                    j=j(L==min(L));
                    if x3(end)~=xs(si) || y3(end)~=ys(si)
                        x3(end+1)=xs(si);
                        y3(end+1)=ys(si);
                    end
                    on_intersection=0;
                end
            end
        
        end
        
        
        if ~isempty(j)
            shape_i=2-mod(shape_i+1,2);
            x3(end+1)=xs0(j);
            y3(end+1)=ys0(j);
            on_intersection=1;
            si=L_i_a(j);
        
            % direction
            dx=xa(si)-xs0(j);
            dy=ya(si)-ys0(j);
            L=sqrt(dx.^2+dy.^2);
            dx=dx/L*1e-7;
            dy=dy/L*1e-7;
            n_w=PtsInPolygon(xs,ys,xs0(j)+dx,ys0(j)+dy);
        
            if shape_i==1
                if n_w==0
                    ds=1;
                else
                    ds=-1;
                end
            else
                if n_w==0
                    ds=-1;
                else
                    ds=1;
                end
            end
        else
            if x3(end)~=xs(si) || y3(end)~=ys(si)
                x3(end+1)=xs(si);
                y3(end+1)=ys(si);
            end
            on_intersection=0;
        
            si=si+ds;
        
            if si==0
                si=length(xs);
            elseif si>length(xs)
                si=1;
            end
        
        end
        
        
        if length(x3)>2 & x3(1)==x3(end) & y3(1)==y3(end)
            break;
        end
    
    end

end


%{
+[保存M函数](,shape_cut)
%}

