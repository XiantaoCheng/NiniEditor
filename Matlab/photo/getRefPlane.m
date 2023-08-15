%{
地址::Matlab\photo\getRefPlane.m
+[保存文本](,getRefPlane)
%}

function getRefPlane(hObject,~)
    pt=get(gca,'CurrentPoint');
    cType=get(hObject,'SelectionType');
    if strcmp(cType,'alt')
        global refPlane;
        global refLine;
        x=get(refPlane,'XData');
        y=get(refPlane,'YData');
        r=sqrt((x-pt(1,1)).^2+(y-pt(1,2)).^2);
        xi=find(r==min(r));
        x(xi(1))=pt(1,1);
        yi=find(r==min(r));
        y(yi(1))=pt(1,2);
        set(refPlane,'XData',x);
        set(refPlane,'YData',y);
        if length(x)>2
            set(refLine,'XData',x([1,end]));
            set(refLine,'YData',y([1,end]));
        end
    end

    clipboard('copy', [x';y']);
end

