%% 20221113
%% from 文档\物理问题\CBS.ftxt
%{
+[保存M函数](,ComptonCrossSection_KN)
地址::Matlab\CBS\ComptonCrossSection_KN.m

测试:...
%}

function dsigma=ComptonCrossSection_KN(omega_1,theta_p)

physics_constant;

omega_2=(omega_1.*m_e.*c.^(2))./(m_e.*c.^(2)+hbar.*omega_1.*(1-cos(theta_p)));
alpha=(e.^(2))./(2.*epsilon_0.*h.*c);
r_e=(alpha.*hbar)./(m_e.*c);
dsigma=(1)./(2).*r_e.^(2).*((omega_2)./(omega_1)).^(2).*((omega_2)./(omega_1)+(omega_1)./(omega_2)-sin(theta_p).^(2));

end

%{
+[M函数](,蒙卡模拟)
%}

