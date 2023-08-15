%{
地址::Matlab\spectrometer\mouseClick.m
+[保存文本](,mouseClick)
%}

function mouseClick(hObject,~)
pt=get(gca,'CurrentPoint');
clipboard('copy', pt(1));
end

