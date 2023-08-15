%{
+[M函数](,GaussianBeam_w)

地址::Matlab\optics\GaussianBeam_w.m
+[保存文本](,GaussianBeam_w)
%}

function w=GaussianBeam_w(z,w0,lm,z0)

%w0=1;
%lm=1;
%z0=5;
%z=linspace(-10,10,1000);

zR=w0^2*pi/lm;
w=w0*sqrt(1+((z-z0)/zR).^2);

end
