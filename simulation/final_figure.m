

% clc;clear;
%  load double_lane_change_pure_MPC.mat
%  figure(1)
%  set(gcf,'color','w'); 
%  plot(x_predict.data,y_predict.data,'LineWidth',2,'color','k');
%  load double_lane_change_MPC_feedback.mat

%   figure(1)
%   set(gcf,'color','w');
%   hold on
%   plot(x_real.data,y_real.data,'LineWidth',2,'color','r');
%   hold on;
%   plot(x_predict.data,y_predict.data,'LineWidth',2,'color','k');
%   hold off;
%   xlabel('x (m)')
%   ylabel('y (m)')

%  figure(2)
  set(gcf,'color','w');
  plot(delta_predict.time,delta_predict.data,'LineWidth',2,'color','k');       % ǰ��ת��(rad)
 hold on
 plot(delta_predict.time,delta_predict.data*16.28,'LineWidth',2,'color','r'); % ������ת��(rad)
  xlabel('time (s)')
  ylabel('steering wheel angle (rad)')       % ylabel�ǵö�ӦҲ��һ��
% 
% figure(3)
% set(gcf,'color','w');
% y_error1 = y_predict.data-y_real.data;
% plot(y_predict.time,y_error1,'LineWidth',2,'color','k');       % ǰ��ת��(rad)
% xlabel('time (s)')
% ylabel('y error (m)')       % ylabel�ǵö�ӦҲ��һ��
% 
% 
% 
