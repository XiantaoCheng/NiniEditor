%{
地址::Matlab\spectrometer\XrayAutoMatch.m
+[保存文本](,XrayAutoMatch)

算法解释:...

match_xo(M函数):...
+[新建阅读窗口](,match_xo)
show_XrayAutoMatch(M函数):...

测试输入(M函数):...
%}


function [cellx,Fn]=XrayAutoMatch(shadow,Cell,dy,IP,Fx,Fy,show_mode)
% global GAS_CELL_Z_POSITION;
% shadow=[
%     2047.805964	2038.307034	1920.865711	1882.869989
% ];
% shadow=sort(4001-shadow);
% dy=[0,0];
% Cell=[GAS_CELL_Z_POSITION,0];
% show_mode=1;

% IP=-2.48;
% Fy=[3.6585 4.3805 4.8965 5.2925 5.6220 5.9205 6.2525 6.5615;
% 	2.9605 3.9015 4.5875 5.1130 5.5545 5.9525 6.2525 6.5545]-6.2525;
% Fy=Fy*0.0254
% Fx=[-1.037 0;
%    0 -1.545]*ones(size(Fy));


shY=(shadow-2000)*1e-4;

Fy(2,:)=Fy(2,:)-dy(2);
xo=zeros(length(shY),numel(Fx));

for i=1:length(shY)
    zs=IP;
    xs=shY(i)-dy(1);
    zf=reshape(Fx,1,numel(Fx));
    xf=reshape(Fy,1,numel(Fy));
    zo=Cell(1);
    xo(i,:)=xf+(xf-xs).*(zo-zf)./(zf-zs);
end

% xo=xo';
% distance=abs(xo-Cell(2));
% cellx=xo(distance==ones(size(distance,1),1)*min(distance));
% [I,~]=find(distance==ones(size(distance,1),1)*min(distance));

[I,cellx]=match_xo(xo');
Fn=[fix(I/2) mod(I,2)+1];


if show_mode==1
    show_XrayAutoMatch(cellx,Fn,Cell,shY,dy,IP,Fx,Fy,shadow);
end

end



