%% 20221004
%% from 文档\实验室信息\iFAST_log2.ftxt
%{
地址::Matlab\iFAST\get_axis.m
+[保存M函数](,get_axis)
round(1.2222,1)

DX
W=4,H=3
测试:...
%}

function axis_=get_axis(W,H)

    axis_=zeros(1,4);

    axis_(1:2)=get(gca,'XLim');
    axis_(3:4)=get(gca,'YLim');

    if nargin>=2
        X0=mean(axis_(1:2));
        Y0=mean(axis_(3:4));
        
        DX=diff(axis_(1:2));
        DY=diff(axis_(3:4));
        
        if DX/DY>W/H
            DX=W/H*DY;
        elseif DX/DY<W/H
            DY=H/W*DX;
        end
        axis_=[X0-DX/2,X0+DX/2,Y0-DY/2,Y0+DY/2];
    end

    % clipboard('copy',axis_);
    clipboard('copy',sprintf('axis_(i,:)=[%s];',num2str(axis_)));
end




