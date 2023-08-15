%% 20220724
%% from 文档\S应用\齿轮模拟.ftxt
%{
地址::Matlab\gears\frame_to_pts.m
+[保存M函数](,frame_to_pts)
测试:...
%}

function pt1=frame_to_pts(pt1_l,pt,angle)

vx=[cosd(angle),sind(angle)];
vy=[-sind(angle),cosd(angle)];
pt1=pt+vx*pt1_l(1)+vy*pt1_l(2);

end


%{
+[保存M函数](,frame_to_pts)
%}

