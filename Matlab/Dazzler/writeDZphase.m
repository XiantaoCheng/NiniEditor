%% 20220505
%% from 文档\实验室问题\Dazzler优化.ftxt
%{
创建"Matlab\Dazzler"
地址::Matlab\Dazzler\writeDZphase.m
+[保存M函数](,writeDZphase)
%}


function writeDZphase(file_name,lm_x,phase_y)

fid=fopen(file_name,'w');
for i=1:length(lm_x)
fprintf(fid,'%.6f\t%.6f\n',lm_x(i),phase_y(i));
end
fclose(fid);

end

