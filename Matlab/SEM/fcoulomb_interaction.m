% coulomb interaction: slice method [doi.org/10.1016/j.ultramic.2020.113050]
function intgnd = fcoulomb_interaction(r_alpha, r_s, V_all, I_all, mm)   
    c_x = 2.51979e13;      % V^0.5/(A*m)
    c_a = 1.02905e18;      % V^2/(A^2*m)
    
    chi = c_x*I_all.*r_s./sqrt(V_all);
    
    % max((chi.^(8/7)+chi.^(-6/7)).^(-7/6)) = 0.45 @ chi = 1)
    intgnd = -c_a/mm/sqrt(V_all(end)).*r_alpha.*sign(r_alpha).*I_all.^2./V_all.^1.5.*(chi.^(8/7)+chi.^(-6/7)).^(-7/6);
end

% chi = 0:0.1:25;
% y = (chi.^(8/7)+chi.^(-6/7)).^(-7/6);
% figure;
% plot(chi,y);
