%{
地址::Matlab\spectrometer\LaunchAngle.m
+[保存文本](,LaunchAngle)
%}

function [angle,Angles,e,Fn,Cell,dy,sx]=LaunchAngle(SD,dy2,show_mode)
% Cell=[0.225,0];
% dy2=-0.000632;
% Ma=[0 -0.05];

Cell=[0.225,0];


shadowX=SD(1,SD(1,:)~=0);
shadowE=SD(2,SD(2,:)~=0);


% if Cal_type==1
% [cellx,dy,sx,~,zw]=IPCalibrationWaist(IP,shadowX,Cell,dy2,20,show_mode);
% Cell(1)=zw;
% else
[cellx,dy,sx]=AutoCalibrationIP(shadowX,Cell,dy2,show_mode,[0,0],20);
fprintf('The size of the source is %1.8f mm!\n',sx*1e3);

Cell(2)=cellx;
[Angles,Fn,e]=LaunchAngles(shadowE,Cell,dy);
angle=mean(Angles);                                 %rad
end