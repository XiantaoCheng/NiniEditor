%% 20220730
%% from 文档\S应用\齿轮模拟.ftxt
%{
地址::Matlab\gears\pt_in_frame.m
+[保存M函数](,pt_in_frame)
测试:...
%}

function pt1=pt_in_frame(pt1_g,pt,angle)

vx=[cosd(angle),sind(angle)];
vy=[-sind(angle),cosd(angle)];
dp=pt1_g-pt;
pt1=[sum(dp.*vx),sum(dp.*vy)];

end


%{
+[保存M函数](,frame_to_pts)
%}

