%{
+[返回目录]

地址::Matlab/MidIR/CodeV2Pt.m
%}


function [pt,drc]=CodeV2Pt(pt,drc)
drc(1)=90-drc(1);
drc=drc([2,1,3])
pt=pt([2,3,1]);
end