%% 20220724
%% from 文档\S应用\齿轮模拟.ftxt
%{
地址::Matlab\gears\gear_rotation.m
+[保存M函数](,gear_rotation)
%}

function angle2=gear_rotation(angle1,N1,N2,angle01,angle02)
angle2=-(angle1-angle01)*N1/N2+angle02;
end


%{
+[保存M函数](,gear_rotation)
%}

