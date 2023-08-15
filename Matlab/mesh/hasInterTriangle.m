%% 20230422
%% from 文档/数学问题/有限元分析.ftxt
%{
地址::Matlab/mesh/hasInterTriangle.m
+[保存M函数](,hasInterTriangle)

测试:...
%}

function [state,pts,lines]=hasInterTriangle(li,bd_lines_1,bd_lines_2)
% li=1;
is=[bd_lines_1(li),bd_lines_2(li)];

state=false;
j0=0;
ls=[find(bd_lines_2==is(1)),find(bd_lines_1==is(1))];
js=[bd_lines_1(bd_lines_2==is(1)),bd_lines_2(bd_lines_1==is(1))];
ls(js==is(2))=[];
js(js==is(2))=[];
for i=1:length(js)
    if sum(bd_lines_1(bd_lines_2==js(i))==is(2))
        l0=find(bd_lines_1==is(2) & (bd_lines_2==js(i)));
        state=true;
        j0=js(i);
        break;
    end
    if sum(bd_lines_2(bd_lines_1==js(i))==is(2))
        l0=find(bd_lines_2==is(2) & (bd_lines_1==js(i)));
        state=true;
        j0=js(i);
        break;
    end
end

if state
    lines=[li,ls(i),l0];
    pts=[j0,is];
else
    lines=[];
    pts=[];
end

end


%{
bd_pts_y(is)
+[保存M函数](,hasInterTriangle)
%}

