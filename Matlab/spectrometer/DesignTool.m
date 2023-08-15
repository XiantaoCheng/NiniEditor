%{
地址::Matlab\spectrometer\DesignTool.m
+[保存文本](,DesignTool)

测试函数(M函数):...
%}


function [Theta,E]=DesignTool(shadow,Cell,dy,Ma,B0,Fx,Fy,IP,show_Mode)
% shadow=2000:2002;
% Cell=[0.225 0];
% dy=[0 0];
% show_Mode=1;
% Ma1=0;
% Ma2=-0.05;
% if LWFA==7
%     IP=-2.48;
%     Fiducial2=-1.545;
%     Fiducial1=-1.037;
% else
%     IP=-2.476;
%     Fiducial2=IP+0.93345;
%     Fiducial1=IP+1.44145;
% end
% fd=[3.6585 4.3805 4.8965 5.2925 5.6220 5.9205 6.2525 6.5615;
% 	2.9605 3.9015 4.5875 5.1130 5.5545 5.9525 6.2525 6.5545]-6.2525;
% Fy=fd*0.0254;
% Fx=[Fiducial1 0;
%     0 Fiducial2]*ones(size(Fy));

% B0=1.482;
% IP=-2.48;
% Fy=[3.6585 4.3805 4.8965 5.2925 5.6220 5.9205 6.2525 6.5615;
% 	2.9605 3.9015 4.5875 5.1130 5.5545 5.9525 6.2525 6.5545]-6.2525;
% Fy=Fy*0.0254
% Fx=[-1.037 0;
%    0 -1.545]*ones(size(Fy));
% Ma=[0,-0.05];


e=1.602e-19;
c=2.999e8;
me=9.109e-31;



Ma1=Ma(1);
Ma2=Ma(2);



shY=(shadow-2000)*1e-4;


Theta=zeros(length(shY),numel(Fx));
E=zeros(length(shY),numel(Fx));

Fy(2,:)=Fy(2,:)-dy(2);
    
for i=1:length(shY)

    Sx=IP*ones(size(Fx));
    Sy=shY(i)*ones(size(Fx));
    Sy=Sy-dy(1);

    zs=reshape(Sx,[1,numel(Fx)]);
    xs=reshape(Sy,[1,numel(Fy)]);
    zf=reshape(Fx,[1,numel(Fx)]);
    xf=reshape(Fy,[1,numel(Fy)]);
    zm=(Ma1+Ma2)/2;
    D=abs(Ma1-Ma2);
    zo=Cell(1);
    xo=Cell(2);

    k1=(xs-xo)./(zm-zo)+(xs-xf).*(zm-zs)./(zs-zf)/(zm-zo);
    theta=atan(k1);
    k2=(xs-xf)./(zs-zf);
    beta=atan(k2);
    xm=xs+(zm-zs).*k2;

    R=D./(sin(beta)-sin(theta));
    E(i,:)=sqrt(B0^2*e^2*R.^2*c^2+me^2*c^4)/e/1e9;

    Z=[zs;zm*ones(size(xm));zo*ones(size(xm))];
    X=[xs;xm;xo*ones(size(xm))];

    if show_Mode==1
        plot(Z,X,'b',zf,xf,'*')
    end
    Theta(i,:)=theta;
end
Theta=Theta';
E=E';
end