%{
地址::Matlab\spectrometer\LaunchAngles.m
+[保存文本](,LaunchAngles)

测试函数(M函数):...
%}

function [a,Fn,e,theta,energy]=LaunchAngles(shadowE,Cell,dy,Ma,B0,Fx,Fy,IP)
% [theta,energy]=DesignTool(shadowE,Cell,dy,0);
[theta,energy]=DesignTool(shadowE,Cell,dy,Ma,B0,Fx,Fy,IP,0);
the=abs(theta);
% Assume that energy of electrons can't be larger than 30GeV
% the(energy>100)=inf;
the(energy>25)=inf;

a=-theta(the==min(the));
e=energy(the==min(the));
[Fn,~]=find(-theta==a');
% Fn=[fix((I+1)/2) mod(I+1,2)+1];
end


