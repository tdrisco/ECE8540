% Tim Driscoll 
% Lab 4 - Kalman Filter
% 8/31/21

clear
clc
close all

%% Read in measurments and plot for reference
fileID = fopen('2D-UWB-data.txt','r');
measurments = fscanf(fileID,'%f %f',[2,Inf]);
measurments = measurments';
[r,c] = size(measurments);
tt = linspace(1,r,r);

%% Define kalman variables
phi = [1 0 1 0;0 1 0 1;0 0 1 0;0 0 0 1]; %transition matrix
X = [measurments(1,1);measurments(1,2);0;0]; %Initial state definition (t-1,t-1)
S = [1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1]; %Initial state estimate covariance (t-1,t-1)
Q = [0 0 0 0;0 0 0 0;0 0 0.01 0.0001;0 0 0.0001 0.01] % Dynamic noise (prediction accuracy)
R = [10 0.0001;0.0001 10] % Measurement Noise (larger value means weight measurments less)
M = [1 0 0 0;0 1 0 0]; % observation matrix
I = [1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1]; % 2x2 identity matrix

for t = 1:1:length(measurments)
    Xt_t1 = phi*X;
    St_t1 = phi*S*phi'+Q;
    Yt(1,1) = measurments(t,1);
    Yt(2,1) = measurments(t,2);
    Kt = St_t1*M'*(M*St_t1*M' + R)^(-1);
    X = Xt_t1 + Kt*(Yt-M*Xt_t1);
    S = (I - Kt*M)*St_t1;
    X_plot(t,1) = X(1,1);
    X_plot(t,2) = X(2,1);
end

% figure('Color','w');
% 
% for t = 1:1:length(measurments)
%     subplot(1,2,1)
%     plot(measurments(t,1),measurments(t,2),'ko','markerfacecolor','k','markersize',2);
%     axis([0 600 100 900])
%    % pause(0.1)
%     hold on
%     subplot(1,2,2)
%     plot(X_plot(t,1),X_plot(t,2),'ro','markerfacecolor','r','markersize',2);
%     hold on
%     %pause(0.1)
% end
% figure('Color','w');
% plot3(measurments(:,1),measurments(:,2),tt,'b-');
% hold on
% plot3(X_plot(:,1),X_plot(:,2),tt,'r-');
% xlabel('X');
% ylabel('Y');
% zlabel('Time');

figure('Color','w');
plot(tt,measurments(:,1),'r-')
hold on 
plot(tt,X_plot(:,1),'k-')
xlabel("Time [T]");
ylabel("Position [X_{t}]");
legend("Measurements","Filtered Estimate");
title("2D Constant Velocity - X Position");

figure('Color','w');
plot(tt,measurments(:,2),'r-')
hold on 
plot(tt,X_plot(:,2),'k-')
xlabel("Time [T]");
ylabel("Position [Y_{t}]");
legend("Measurements","Filtered Estimate");
title("2D Constant Velocity - Y Position");

