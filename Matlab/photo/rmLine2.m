%% 20230619
%% from 文档\S应用\词典.ftxt
%{
地址::Matlab/photo/rmLine2.m
+[保存M函数](,rmLine2)
%}

function rmLine2(hObject,e)
    pt=get(gca,'CurrentPoint');
    cType=get(hObject,'SelectionType');

    global refLine;
    global refErase;
    global refAxis;

    refAxis=zeros(1,4);
    refAxis(1:2)=get(gca,'XLim');
    refAxis(3:4)=get(gca,'YLim');
    refErase=0.03*diff(refAxis(1:2));

    r0=refErase;

    if strcmp(cType,'extend')
        global refLine;
        x=get(refLine,'XData');
        y=get(refLine,'YData');

        x0=pt(1,1);
        y0=pt(1,2);
        r=sqrt((x-x0).^2+(y-y0).^2);

        x(r<r0)=nan;
        y(r<r0)=nan;

        set(refLine,'XData',x);
        set(refLine,'YData',y);
%         axis(refAxis);
    end

end



