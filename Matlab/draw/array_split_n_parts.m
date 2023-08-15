%% 20230528
%% from 文档\S应用\图形库.ftxt
%{
地址::Matlab/draw/array_split_n_parts.m
+[保存M函数](,array_split_n_parts)
%}

function lines=array_split_n_parts(ns,pts)
% ns=1:50;
% pts=[30,1];

pts=sort(pts);
lines=cell(1);
lines{1}=1:pts(1);
for i=1:length(pts)-1
    lines{end+1}=ns(pts(i):pts(i+1));
end
lines{1}=[pts(end):length(ns),lines{1}];

end


%{
+[M函数](,array_split_n_parts)
%}

