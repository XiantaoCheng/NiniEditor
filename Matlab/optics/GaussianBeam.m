%{
+[返回目录](,GaussianBeam)
地址::Matlab\optics\GaussianBeam.m
+[保存文本](,GaussianBeam)

+[M函数](,GaussianBeam)
%}

function E=GaussianBeam(Z,R,lm,w0,E0,n)
    physics_constant;
    %lm=800e-9;
    %w0=0.01e-3;
    %E0=1;
    %n=1;
    
    zR=pi*w0^2*n/lm;
    k=2*pi/lm;
    
    psi=atan(Z/zR);
    rRc=Z./(Z.^2+zR.^2);
    w=w0*sqrt(1+(Z/zR).^2);
    E=E0*w0./w.*exp(-R.^2./w.^2).*exp(-1i*(k*Z+k*(R.^2/2.*rRc)-psi));

end

%{
+[M函数](,光场分布函数)
%}