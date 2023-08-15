%% 20220610
%% from 文档\物理问题\电子能谱.ftxt
%{
记住"Matlab"
+[M函数](,main)
地址::Matlab\output\spectrometer\main.m
创建"Matlab\output\spectrometer"
+[保存M函数](,main)
%}

physics_constant;
addpath('Matlab\spectrometer');
addpath('Matlab\funcs');

shadow0=8001-e_shadows
X_shadows0=8001-X_shadows

Cell0=Cell00+[dCell_0,0];
IP=IP0+[dIP_0,0];

shadow=4001-shadow0/2;
Cell=Cell0(1:2)*1e-2;
Ma=[-1/2,1/2]*size_m(1)+pos_m(1);
Ma=Ma*1e-2;
Fx1=pos_f1(1)*1e-2;
Fx2=pos_f2(1)*1e-2;
Fy1=pos_f1(2)*1e-2;
Fy2=pos_f2(2)*1e-2;
IPx=IP(1)*1e-2;
IPy=IP(2)*1e-2;

shX=IPx*ones(size(shadow));
shY=(shadow-2000)*1e-4+IPy;

Fy=[f_1*1e-2+Fy1;f_2*1e-2+Fy2];
Fx=[Fx1*ones(size(f_1));Fx2*ones(size(f_2))];

% calibration
ys=(4000-X_shadows0)*50e-6+IPy;
xs=IPx*ones(size(ys));
xo=Cell(1);
yo=Cell(2);

[xo3,yo3,ys3,I,J,f1,f2,xf,yf]=calibrationIP(xo,yo,10e-3,10e-3,Fx,Fy,xs,ys,20);
dIPy=mean(ys3-ys);


% launch angle
Cell=[xo3,yo3,0];
shY=shY+dIPy;
[a,Fn,es,theta,energy]=DesignTool2(Cell,Ma,B0,Fx,Fy,shX,shY);


% image
data=imread(file_name);
data_im=[zeros(4000,2500),data(:,end:-1:1)];
data_im=double(data_im);

% spectrum
pos_m0=[mean(Ma),0];
siz_m0=diff(Ma);
dx=50e-6;
a0=mean(a);


z_i=IPx;
% x_i=linspace(-0.2,0.2,8000)+IPy+dIPy;
% x_i=interp1(shadow0,shY,1:8000);
A=polyfit(shadow0,shY,1);
x_i=A(1)*(1:8000)+A(2);
x_i=-x_i;
E=linspace(0.29,20,10000)*1e9*e;
I0=trapz(data_im);
% I0=I0(end:-1:1);

S=spectrum(I0,E,-a0,Cell(2),Cell(1),-B0,siz_m0,pos_m0(1),x_i,z_i);
E_range=E(S<max(S)*1e-3);
% E_range0=min(E_range);
E_range0=5e9*e;
S_c=S/4.1e-3*e*e*1e9;

%{
记住"Matlab"
+[M函数](,M代码)
%}

figure
subplot(2,2,1)
x=xo-0.05*ones(1,length(I));
y=ys3(J)+(x-xs(J)).*(yf(I)-ys3(J))./(xf(I)-xs(J));
plot(xo,yo,'o',xo3,yo3,'o',xf,yf,'o',xs,ys3,'o'...
    ,[xs(J(f1));x(f1)],[ys3(J(f1));y(f1)],'r'...
    ,[xs(J(f2));x(f2)],[ys3(J(f2));y(f2)],'b')

xlabel('x [m]')
ylabel('y [m]')
title('X-rays calibration')

subplot(2,2,2)
plot(es,a/1e-3,'o-')
xlabel('E [GeV]')
ylabel('\theta [mrad]')
title('Fiducial launch angles');

subplot(2,1,2)
plot(E/e/1e9,S_c/1e-12);
xlabel('E [GeV]')
ylabel('Density [pC/GeV]')
axis([0,1*E_range0/e/1e9,0,1.2*max(S_c/1e-12)])
title(sprintf('No.%d',no_))


%{
subplot(2,2,4)
xs1=-shY;
yI1=interp1(x_i,I0,xs1);

plot(x_i,I0,xs1,yI1,'o');
%}

if ~exist("data_no")
    data_no=[];
    data_energy=[];
    data_spectrum=[];
end

if sum(data_no==no_)
    data_energy(data_no==no_)=E(E<5e9*e)/e/1e9;
    data_spectrum(data_no==no_)=S_c(E<5e9*e);
else
    data_no(end+1)=no_;
    data_energy(end+1,:)=E(E<5e9*e)/e/1e9;
    data_spectrum(end+1,:)=S_c(E<5e9*e);
end





