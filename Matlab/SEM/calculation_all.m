clc;
clear all;
close all;

%% define geometry 

% einzel lens
V0 = 8000;
V1 = 4400;%3.987707230110555e3;    %1.614044233312194e4;
V2 = 1700;%3.574309348644629e3;    %1.809231935002980e4;
V_landing = 8000;

lens{1}.volts = [V0, V0, V1, V1, V0, V0];
lens{1}.pos_rel = [-5.5, -3.5, -1.5, 1.5, 3.5, 5.5]*1e-3;         %[-5, -3, -1, 1, 3, 5] % [-10, -7, -3, 3, 7, 10]
lens{1}.pos_abs = 0;

lens{2}.volts = [V0, V0, V2, V2, V0, V0];
lens{2}.pos_rel = [-5.5, -3.5, -1.5, 1.5, 3.5, 5.5]*1e-3;
lens{2}.pos_abs = 85e-3;

pos_source = -350e-3;
pos_cross = [18, 95]*1e-3;  % [12, 95]
pos_screen = pos_cross(end);

flag_auto_focus = 1;
variable_volts_ind = [4,5; 10,11];

flag_coulomb = 1;

scale_x_units = 1e3;        % convert [m] to [mm] for x axis in plots only

V_list = V0;
x_list = pos_source;
electrode_pos = [];
for i = 1:length(lens)
    V_list = [V_list, lens{i}.volts];
    x_list = [x_list, lens{i}.pos_rel+lens{i}.pos_abs];
    electrode_pos = [electrode_pos; reshape(lens{i}.pos_rel,[2,3])'+lens{i}.pos_abs];
end
V_list = [V_list, V_landing];
x_list = [x_list, pos_screen];

x_all = linspace(min(x_list),max(x_list),20000);    % x_all: list of corresponding positions
V_all = interp1(x_list, V_list, x_all, 'Linear');   % V_all: list of voltages

% % cathode lens
% V_all = [linspace(1,8000,40),8000*ones(1,10)];
% x_all = linspace(0,100,length(V_all));
% electrode_ind = [1,2; 40,41];

%% auto focus
if flag_auto_focus == 1
    [V_list, V_all] = auto_focus(x_list, V_list, x_all, variable_volts_ind, pos_cross);
end

%% calculate trajectory
[r_alpha, angle_alpha] = tm_traj(x_all, V_all, [0;1*sqrt(V_all(1))]);

[r_gamma, angle_gamma] = tm_traj(x_all, V_all, [1;0]);  % [pos; angle*sqrt(V)]

mm = angle_alpha(end);      % mm = ai/ao; angular magnification
mag = r_gamma(end);   
display(['angular mag = ', num2str(mm)]);
display(['mag = ', num2str(mag)]);

fig_num = 1;
plot_all(x_all, V_all, electrode_pos, pos_cross, r_alpha, r_gamma, fig_num);

%% calculate coulomb_interaction

if flag_coulomb == 1
    Br = 2e7;           % brightness [A/m2/sr/V]
    alpha = 2e-3;       % source half angle [rad]
    ds = 1e-6;          % source diameter [m]
    PE0 = 8000;         % beam energy [V]
    
    I_factor = ones(size(x_all));       % no aperture for now
    r_factor = ones(size(x_all))*alpha;
    
    I_all = Br*pi/4*ds^2*pi*alpha^2*PE0*I_factor;   % ~1uA/1um^2
    r_s = sqrt((r_alpha.*r_factor).^2+(ds/2*r_gamma).^2);
    
    intgnd = fcoulomb_interaction(r_alpha, r_s, V_all, I_all, mm);
    
    %% plot coulomb interaction

    figure(2);
    subplot(2,1,1);
    plot(x_all*scale_x_units,cumsum(intgnd.*[x_all(2)-x_all(1),diff(x_all)])*1e9, 'LineWidth',1.5);
    xlabel('pos [mm]');
    ylabel('fw50 blur [nm]');
    
    subplot(2,1,2);
    plot(x_all*scale_x_units,intgnd*1e9, 'LineWidth',1.5);
    xlabel('pos [mm]');
    ylabel('differtial fw50 blur [nm/m]');
    
    figure(3);
    hold on;
    plot(x_all*scale_x_units, r_alpha.*r_factor*1e6, 'LineWidth',1.5,'Color','r');
    plot(x_all*scale_x_units, ds/2*r_gamma*1e9, 'LineWidth',1.5,'Color','g');
    plot(x_all*scale_x_units, r_s*1e6, 'LineWidth',1.5,'Color','b','LineStyle','-.');
    legend('r_{alpha}','1000*r_{gamma}','r_{tot}','Location','southwest');
    xlabel('pos [mm]');
    ylabel('r_s [um]');
end
    