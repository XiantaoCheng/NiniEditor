%% 20230619
%% from 文档\S应用\词典.ftxt
%{
地址::Matlab/photo/addLine.m
+[保存M函数](,addLine)

addLine2:...
addLine3:...
rmLine2:...
rmLine3:...
%}

function addLine(hObject,e)
    pt=get(gca,'CurrentPoint');
    cType=get(hObject,'SelectionType');

    global refLine;
    global refOutput;

    refOutput=cType;
    if strcmp(cType,'alt')
        set(gcf,'WindowButtonMotionFcn',@addLine2);
        set(gcf,'WindowButtonUpFcn',@addLine3);
    elseif strcmp(cType,'extend')
        set(gcf,'WindowButtonMotionFcn',@rmLine2);
        set(gcf,'WindowButtonUpFcn',@rmLine3);
    end

end



