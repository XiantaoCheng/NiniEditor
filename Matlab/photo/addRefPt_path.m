%% 20230312
%% from 文档\S应用\词典.ftxt
%{
地址::Matlab\photo\addRefPt_path.m
+[保存M函数](,addRefPt_path)
参考::https://undocumentedmatlab.com/blog_old/figure-keypress-modifiers
+[打开网页](,参考)
%}

function addRefPt_path(hObject,e)
    pt=get(gca,'CurrentPoint');
    cType=get(hObject,'SelectionType');
    if strcmp(cType,'alt')
        global refPts;
        global refCurve;
        global refTexts;
        x=get(refPts,'XData');
        y=get(refPts,'YData');

        if isnan(x(1))
            x(1)=pt(1,1);
            refTexts(1).Position=[pt(1,1),pt(1,2),0];
            refTexts(1).String='1';
        else
            x(end+1)=pt(1,1);
            refTexts(end+1)=text(pt(1,1),pt(1,2),sprintf('%d',length(x)));
            set(refTexts(end),'Color','k');
            %set(refTexts(end),'BackgroundColor','w');
        end
        
        if isnan(y(1))
            y(1)=pt(1,2);
        else
            y(end+1)=pt(1,2);
        end

        set(refPts,'XData',x);
        set(refPts,'YData',y);
        set(refCurve,'XData',x);
        set(refCurve,'YData',y);
    end

%    clipboard('copy', [x';y']);
end



