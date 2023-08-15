%% 20220527
%% from 文档\物理问题\衍射.ftxt
%{
地址::Matlab\funcs\func_peak.m
+[保存M函数](,func_peak)
%}

function range_x=func_peak(x,y)
%x=linspace(-Dx,Dx,Dx/dx);
%y=J_1(x);

range_x=[];
for i=2:length(x)-1
    if (y(i)-y(i-1))*(y(i)-y(i+1))>0
        range_x(end+1)=x(i);
    end
end

end


