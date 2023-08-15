function plot_all(x_all, V_all, electrode_pos, pos_cross, r_alpha, r_gamma, fig_num)
    
    %% plot configuration
    scale_x_units = 1e3;
    scale_y_plots = 1.2;
    
    % electrode_ind: index of electrode positions, for plot only
    electrode_ind = zeros(size(electrode_pos));
    for i = 1:size(electrode_pos,1)
       [~, electrode_ind(i,1)] = min(abs(electrode_pos(i,1)-x_all));
       [~, electrode_ind(i,2)] = min(abs(electrode_pos(i,2)-x_all));
    end
    
    figure(fig_num);
    plot(x_all*scale_x_units, V_all, 'LineWidth',1, 'Color','b','LineStyle','-');
    hold on;
    for i = 1:size(electrode_ind,1)
        rectangle('Position', [x_all(electrode_ind(i,1))*scale_x_units, -max(V_all)*scale_y_plots, ...
            (x_all(electrode_ind(i,2))-x_all(electrode_ind(i,1)))*scale_x_units, 2*max(V_all)*scale_y_plots], 'FaceColor',[0,0,1,0.4]);
    end
    line([x_all(end),x_all(end)]*scale_x_units,[-max(V_all)*scale_y_plots,max(V_all)*scale_y_plots], 'LineWidth',2, 'Color','b');
    xlabel('pos [mm]');
    ylabel('volts [V]');
    
    for i = 1:length(pos_cross)
        plot(pos_cross(i)*scale_x_units, 0, '+k','MarkerSize',10, 'LineWidth',1);
    end
    
    %% plot trajectory
    
    % scale_y: scale factor for trajectory, for plot only
    scale_y1 = max(V_all)/max(abs(r_alpha))/3;
    scale_y2 = max(V_all)/max(abs(r_gamma))/1.5;
    
    figure(fig_num);
    plot(x_all*scale_x_units, r_alpha*scale_y1,'r-', 'LineWidth',1.5);
    plot(x_all*scale_x_units, -r_alpha*scale_y1,'r-', 'LineWidth',1.5);
    plot(x_all*scale_x_units, r_gamma*scale_y2,'g-', 'LineWidth',1.5);
    plot(x_all*scale_x_units, -r_gamma*scale_y2,'g-', 'LineWidth',1.5);
    xlim([min(x_all),max(x_all)]*scale_x_units);
   
    
    % line([x_all(1)-10*cos(angle_all(1)), x_all(1)], [r_list(1)-10*sin(angle_all(1)),r_list(1)]*scale_y,...
    %     'LineWidth',1.5, 'Color','r','LineStyle','-');
    % line([x_all(1)-10*cos(angle_all(1)), x_all(1)], -[r_list(1)-10*sin(angle_all(1)),r_list(1)]*scale_y,...
    %     'LineWidth',1.5, 'Color','r','LineStyle','-');
    
    % line_length = 1;
    
    % for i = 1:length(x_all)
    %     line([x_all(i)-line_length*cos(angle_all(i)), x_all(i)+line_length*cos(angle_all(i))],...
    %         [r_list(i)-line_length*sin(angle_all(i)),r_list(i)+line_length*sin(angle_all(i))]*scale_y,...
    %         'LineWidth',1.5, 'Color','r');
    %     line([x_all(i)-line_length*cos(angle_all(i)), x_all(i)+line_length*cos(angle_all(i))],...
    %         -[r_list(i)-line_length*sin(angle_all(i)),r_list(i)+line_length*sin(angle_all(i))]*scale_y,...
    %         'LineWidth',1.5, 'Color','r');
    % end

end