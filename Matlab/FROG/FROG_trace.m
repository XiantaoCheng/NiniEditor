%% 20220602
%% from 文档\物理问题\FROG.ftxt
%{
地址::Matlab\FROG\FROG_trace.m
+[保存M函数](,FROG_trace)
测试:...
测试实验数据:...
%}

function FROG_tr=FROG_trace(t0,E0,lm,tau)


FROG_tr=zeros(size(tau,2),size(lm,2));
for i=1:length(tau)
I_f=FROG_In(t0,E0,tau(i),lm);
FROG_tr(i,:)=I_f;
end
FROG_tr=FROG_tr';


end


