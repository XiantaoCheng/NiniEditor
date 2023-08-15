%% 20230619
%% from 文档\S应用\词典.ftxt
%{
地址::Matlab/photo/addLine3.m
+[保存M函数](,addLine3)
%}

function addLine3(hObject,e)
    pt=get(gca,'CurrentPoint');
    cType=get(hObject,'SelectionType');

    global refLine;
    global refAxis;

    refAxis=zeros(1,4);
    refAxis(1:2)=get(gca,'XLim');
    refAxis(3:4)=get(gca,'YLim');

    if strcmp(cType,'alt')
        global refLine;
        x=get(refLine,'XData');
        y=get(refLine,'YData');

        if isnan(x(1))
            x(1)=pt(1,1);
        else
            x(end+1)=pt(1,1);
        end
        
        if isnan(y(1))
            y(1)=pt(1,2);
        else
            y(end+1)=pt(1,2);
        end

        x(end+1)=nan;
        y(end+1)=nan;

        set(refLine,'XData',x);
        set(refLine,'YData',y);
        axis(refAxis);
    end
    set(gcf,'WindowButtonMotionFcn',@(h,e)0);
    set(gcf,'WindowButtonUpFcn',@(h,e)0);

end



