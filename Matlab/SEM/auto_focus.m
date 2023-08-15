% auto focus
function [V_list_af, V_all_af] = auto_focus(x_list, V_list, x_all, variable_volts_ind, pos_cross)
    epsilon = 1e-10;
    fudge = 0.5;
    delta_V0 = 1;
    delta_V_epsilon = 1e-20;

    V_list_af = V_list;
    if size(variable_volts_ind,1) == length(pos_cross)
        cross_ind = zeros(size(pos_cross));
        for i = 1:length(pos_cross)
            [~, cross_ind(i)] = min(abs(pos_cross(i)-x_all));
        end

        for i = 1:length(cross_ind)
            delta_V = delta_V0;
            flag_focus = [0,0];
            while 1
                V_all_af = interp1(x_list, V_list_af, x_all, 'Linear');
                [r_alpha, ~] = tm_traj(x_all, V_all_af, [0;1*sqrt(V_all_af(1))]);

%                 figure(101);      % for debug autofocus process
%                 clf;
%                 scale_x_units = 1000;
%                 plot(x_all*scale_x_units, r_alpha);
%                 hold on;
%                 for ii = 1:length(pos_cross)
%                     plot(pos_cross(ii)*scale_x_units, 0, '+k','MarkerSize',10, 'LineWidth',1);
%                 end
%                 pause(0.1);
            
                if abs(r_alpha(cross_ind(i))) > epsilon
                    flag_focus(1) = flag_focus(2);
                    flag_focus(2) = sign(r_alpha(cross_ind(i)));
                    if sign(r_alpha(cross_ind(i))) == (-1)^i
                        disp(["over focus, error=" num2str(r_alpha(cross_ind(i)))]);
                        V_list_af(variable_volts_ind(i,:)) = V_list_af(variable_volts_ind(i,:))-sign(V_list(variable_volts_ind(i,1))-V_list(variable_volts_ind(i,1)-1))*delta_V;
                    else
                        disp(["under focus, error=" num2str(r_alpha(cross_ind(i)))]);
                        V_list_af(variable_volts_ind(i,:)) = V_list_af(variable_volts_ind(i,:))+sign(V_list(variable_volts_ind(i,1))-V_list(variable_volts_ind(i,1)-1))*delta_V;
                    end
                else
                    % update voltages
                    V_list_af(variable_volts_ind(:,:))
                    V_all_af = interp1(x_list, V_list_af, x_all, 'Linear');
                    break;
                end
                if flag_focus(1)*flag_focus(2)==1
                    delta_V = delta_V/fudge
                else
                    delta_V = delta_V*fudge
                end
                if delta_V < delta_V_epsilon
                    disp(["could not auto-focus for cross number" num2str(i)]);
                    break;
                end

            end
        end
    else
        disp("Error number of variables for auto focusing!")
    end
 
end
