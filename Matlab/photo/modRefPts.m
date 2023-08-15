%% 20220512
%% from 文档\S应用\词典.ftxt
%{
地址::Matlab\photo\modRefPts.m
+[保存M函数](,modRefPts)
参考::https://undocumentedmatlab.com/blog_old/figure-keypress-modifiers
+[打开网页](,参考)
%}

function modRefPts(hObject,e)
    pt=get(gca,'CurrentPoint');
    cType=get(hObject,'SelectionType');
    if strcmp(cType,'alt')
        global refPts;
        global refTexts;
        x=get(refPts,'XData');
        y=get(refPts,'YData');

        r=sqrt((x-pt(1,1)).^2+(y-pt(1,2)).^2);
        ri=find(r==min(r));
        x(ri(1))=pt(1,1);
        y(ri(1))=pt(1,2);
        refTexts(ri(1)).Position=[pt(1,1),pt(1,2),0];

        set(refPts,'XData',x);
        set(refPts,'YData',y);
    end

    clipboard('copy', [x';y']);
end



