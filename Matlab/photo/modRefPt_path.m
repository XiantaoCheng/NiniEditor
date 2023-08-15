%% 20230312
%% from 文档\S应用\词典.ftxt
%{
地址::Matlab\photo\modRefPt_path.m
+[保存M函数](,modRefPt_path)
参考::https://undocumentedmatlab.com/blog_old/figure-keypress-modifiers
+[打开网页](,参考)
%}

function modRefPt_path(hObject,e,n)
    pt=get(gca,'CurrentPoint');
    cType=get(hObject,'SelectionType');
    if strcmp(cType,'alt')
        global refPts;
        global refCurve;
        global refTexts;
        x=get(refPts,'XData');
        y=get(refPts,'YData');

        ri=n;
        x(ri(1))=pt(1,1);
        y(ri(1))=pt(1,2);
        refTexts(ri(1)).Position=[pt(1,1),pt(1,2),0];

        set(refPts,'XData',x);
        set(refPts,'YData',y);
        set(refCurve,'XData',x);
        set(refCurve,'YData',y);
    end

%    clipboard('copy', [x';y']);
end



