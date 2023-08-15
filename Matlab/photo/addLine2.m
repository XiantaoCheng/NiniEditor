%% 20230619
%% from 文档\S应用\词典.ftxt
%{
地址::Matlab/photo/addLine2.m
+[保存M函数](,addLine2)
%}

function addLine2(hObject,e)
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

        set(refLine,'XData',x);
        set(refLine,'YData',y);
        axis(refAxis);
    end

end



