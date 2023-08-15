%% 20220721
%% from 文档\实验室信息\iFAST_log2.ftxt
%{
Nini, 打开iFAST日志2的get_axis(节点)
地址::Matlab\iFAST\get_axis_all.m
+[保存M函数](,get_axis_all)
%}

function axis_=get_axis_all(W,H,n0)
    h_as=get(gcf,'Children');
    text_out='';

    if nargin<3
        n0=0;
    end

    for i=1:length(h_as)
        axis_=zeros(1,4);
        h=h_as(end-i+1);
    
        axis_(1:2)=get(h,'XLim');
        axis_(3:4)=get(h,'YLim');
    
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
    
        text_out=[text_out,sprintf('\naxis_(%d,:)=[%s];',i+n0,num2str(axis_))];
    end

    clipboard('copy',text_out);
end



