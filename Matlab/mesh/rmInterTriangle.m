%% 20230422
%% from 文档/数学问题/有限元分析.ftxt
%{
地址::Matlab/mesh/rmInterTriangle.m
+[保存M函数](,rmInterTriangle)
%}

function n_del=rmInterTriangle(pts_tri,lines_tri,bd_lines_1,bd_lines_2)
n_del=[false,false,false];
for i=1:3
    ls=[find(bd_lines_1==pts_tri(i)),find(bd_lines_2==pts_tri(i))];
    ls(ls==lines_tri(1))=[];
    ls(ls==lines_tri(2))=[];
    ls(ls==lines_tri(3))=[];
    n_del(i)=isempty(ls);
end

end

%{
+[M函数](,rmInterTriangle)
%}

