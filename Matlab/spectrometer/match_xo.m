%{
地址::Matlab\spectrometer\match_xo.m
+[保存文本](,match_xo)
%}


function [I,cellx]=match_xo(xo)
xo_max=max(max(xo));
xo_min=min(min(xo));
Dxo=xo_max-xo_min;
N=1000;
x=xo_min:Dxo/N:xo_max;
y=zeros(size(x));
for i=1:length(x)
    dx=abs(x(i)-xo);
    y(i)=std(xo(dx==min(dx)));
end

x_min=x(y==min(y));
x_min=x_min(1);
dx=abs(x_min-xo);
[I,~]=find(dx==min(dx));
cellx=xo(dx==min(dx));
end
