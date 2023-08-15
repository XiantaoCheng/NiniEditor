%% 20220828
%% from 文档\S应用\词典.ftxt
%{
地址::Matlab\dataVis\setRefPt.m
+[保存M函数](,setRefPt)
%}

function setRefPt(pt_x,pt_y)
global refPts;
global refTexts;

hold on
refPts=plot(pt_x,pt_y,'o');
set(refPts,'MarkerEdgeColor','k');
set(refPts,'MarkerFaceColor','w');

text_N=cell(1,length(pt_x));
for i=1:length(pt_x)
text_N{i}=sprintf('%d',i);
end
refTexts=text(pt_x,pt_y,text_N);
end





