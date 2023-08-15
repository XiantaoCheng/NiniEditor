%{
地址::Matlab\photo\get3DPointFromPhoto.m
+[保存文本](,get3DPointFromPhoto)
%}

function get3DPointFromPhoto(hObject,~)
    pt_m=get(gca,'CurrentPoint');
    cType=get(hObject,'SelectionType');

    global GET3DPOINT
    if strcmp(cType,'alt')
        pt=GET3DPOINT.PT;
        abc=GET3DPOINT.ABC;
        pt1=GET3DPOINT.PT1;
        Eulers1=GET3DPOINT.EULERS1;
        D=GET3DPOINT.DD;
        center=GET3DPOINT.CENTER;

        x=pt_m(1)-center(1);
        y=pt_m(2)-center(2);

        [X,Y,Z]=GetPointOnPlane(x,y,pt,abc,Eulers1,pt1,D);
    end
    clipboard('copy', [X,Y,Z]);
end

