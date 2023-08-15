%% 20220604
%% from 文档\物理问题\光栅压缩器.ftxt
%{
地址::Matlab\optics\grating_compressor_phase.m
+[保存M函数](,grating_compressor_phase)
%}


function phase_G=grating_compressor_phase(w,D,theta,D_0,theta_0,G)

physics_constant;
%D=0.67;
%theta=47.28;

%D_0=0.67;
%theta_0=47.28;
%G=1480;

d=1e-3/G;
n=1;
w_0=mean(w);

beta=@(w,theta,n)asind(-sind(theta)+n*2*pi*c./w/d);
l=@(w,D,theta,n)D*((1+sind(beta(w,theta,n))*sind(theta))./cosd(beta(w,theta,n)));
phase=@(w,D,theta,n)w.*D/c.*cosd(beta(w,theta,n));
dphi=@(w,D,theta,n)l(w,D,theta,n)/c;

phase_0=phase(w,D_0,theta_0,n)-phase(w_0,D_0,theta_0,n)-dphi(w_0,D_0,theta_0,n)*(w-w_0);
phase2_a=phase(w,D,theta,n)-phase(w_0,D,theta,n)-dphi(w_0,D,theta,n)*(w-w_0);

% phase_a=phase(w,D,theta,n);
% phase01=phase(w_0,D,theta,n)+dphi(w_0,D,theta,n)*(w-w_0);
% phase2_a=phase_a-phase01;

phase_G=phase2_a-phase_0;

end






