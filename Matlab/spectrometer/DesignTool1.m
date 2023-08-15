%{
地址::Matlab\spectrometer\DesignTool1.m
+[保存文本](,DesignTool1)
%}


function [a,Fn,e,theta,energy]=DesignTool1(Cell,Ma,B0,Fx,Fy,shX,shY)

e=1.602e-19;
c=2.999e8;
me=9.109e-31;
physics_constant;



Ma1=Ma(1);
Ma2=Ma(2);


%shY=(shadow-2000)*1e-4-dy(1);
%shX=IP*ones(size(shadow));


Theta=zeros(length(shY),numel(Fx));
E=zeros(length(shY),numel(Fx));
    
for i=1:length(shY)

    Sx=shX(i)*ones(size(Fx));
    Sy=shY(i)*ones(size(Fx));

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

    Theta(i,:)=theta;
end
Theta=Theta';
E=E';

theta=Theta;
energy=E;

the=abs(theta);
the(energy>25)=inf;

a=-theta(the==min(the));
e=energy(the==min(the));
[Fn,~]=find(-theta==a');


end