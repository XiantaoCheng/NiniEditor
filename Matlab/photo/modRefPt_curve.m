%% 20221120
%% from 文档\S应用\词典.ftxt
%{
地址::Matlab\photo\modRefPt_curve.m
+[保存M函数](,modRefPt_curve)
参考::https://undocumentedmatlab.com/blog_old/figure-keypress-modifiers
+[打开网页](,参考)
%}

function modRefPt_curve(hObject,e,n)
    pt=get(gca,'CurrentPoint');
    cType=get(hObject,'SelectionType');
    if strcmp(cType,'alt')
        global refPts;
        global refTexts;
        global refCurve;
        x=get(refPts,'XData');
        y=get(refPts,'YData');

        ri=n;
        x(ri(1))=pt(1,1);
        y(ri(1))=pt(1,2);
        refTexts(ri(1)).Position=[pt(1,1),pt(1,2),0];

        set(refPts,'XData',x);
        set(refPts,'YData',y);

        if length(x)>2
            t=1:length(x);
            ts=linspace(1,length(x),100);
            xs=interp1(t,x,ts,'spline');
            ys=interp1(t,y,ts,'spline');
            set(refCurve,'XData',xs);
            set(refCurve,'YData',ys);
        end
    end

    clipboard('copy', [x';y']);
end



