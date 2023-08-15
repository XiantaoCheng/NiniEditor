%{
地址::Matlab\optics\lens_scanning.m
+[保存文本](,lens_scanning)

L2=220.25
L5=638.725
%}



function [d,V,X]=lens_scanning(d0,dp2,dp5,L2,L5)

%d0=5;
p=[0,0];
x=p(1);
v=inf;

V=v;
X=x;


% A0
p=[0,0]+0;
u=p(1)-(v+x);
rv=1/inf-1/u;
v=1/rv;
x=p(1);
V=[V,v];
X=[X,x];

% L1
p=[158.75, 0.0];
u=p(1)-(v+x);
rv=1/150-1/u;
v=1/rv;
x=p(1);
V=[V,v];
X=[X,x];

% L2
p=[L2, 0.0]+dp2;
u=p(1)-(v+x);
rv=1/-80-1/u;
v=1/rv;
x=p(1);
V=[V,v];
X=[X,x];

% L3
p=[336.55, 0.0]+0;
u=p(1)-(v+x);
rv=1/200-1/u;
v=1/rv;
x=p(1);
V=[V,v];
X=[X,x];

% L5
p=[L5, 0.0]+dp5;
u=p(1)-(v+x);
rv=1/40-1/u;
v=1/rv;
x=p(1);
V=[V,v];
X=[X,x];

% NC1
p=[846.725, 0.0]+0;
u=p(1)-(v+x);
rv=1/inf-1/u;
v=1/rv;
x=p(1);
V=[V,v];
X=[X,x];

% shape

r=d0'/2;
f=V;
x=ones(size(r))*X;
y=zeros(size(x));
y(:,1)=r;
for i=1:length(f)-1
    Dx=X(i+1)-X(i);
    Dy=-Dx/f(i)*r;
    r=r+Dy;
    y(:,i+1)=r;
end

y2=fliplr(-y);
y=[y,y2];
y=reshape(y',1,numel(y));
x2=fliplr(x);
x=[x,x2];
x=reshape(x',1,numel(x));

x0=x;
y0=y;
f0=f;


% diameter
addpath('Matlab\optics');

lm=800e-9;


f=f0*1e-3;
y=y0(1,1:length(f0))*1e-3;
x=x0(1,1:length(f0))*1e-3;
z=[846.725, 0.0]*1e-3;
z=z(1);

i=max(find(z>x(1:end-1)));
z0=x(i)+f(i);
w=abs(y(i));
N=f(i)/2/w;
w0=2*N/pi*lm;

%w0
d=2*GaussianBeam_w(z,w0,lm,z0);
%disp(sprintf('Diameter: %.3f mm',d/1e-3))


end

