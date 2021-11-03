% Tim Driscoll 
% Lab 4 - Kalman Filter
% 10/5/21

clear
clc
close all

%% Read in measurments and plot for reference
fileID = fopen('1D-data.txt','r');
measurements = fscanf(fileID,'%f');
measurements  = measurements';
tt = linspace(1,639,639);

figure('Color','w');
plot(tt,measurements,'r-');
hold on

%% Define kalman variables
phi = [1 1;0 1]; %transition matrix
X = [0;0]; %Initial state definition (t-1,t-1)
S = [1 0;0 1]; %Initial state estimate covariance (t-1,t-1)
Q = [0 0; 0 0.0000000000001]; % Dynamic noise (prediction accuracy)
R = 10000000; % Measurement Noise (larger value means weight measurments less)
M = [1 0]; % observation matrix
I = [1 0;0 1]; % 2x2 identity matrix

for t = 1:1:length(measurements)
    Xt_t1 = phi*X;
    St_t1 = phi*S*phi'+Q;
    Yt = measurements(t);
    Kt = St_t1*M'*(M*St_t1*M' + R)^(-1);
    X = Xt_t1 + Kt*(Yt-M*Xt_t1);
    S = (I - Kt*M)*St_t1;
    X_plot(t) = X(1);
end
plot(tt,X_plot,'k-');
xlabel("Time [T]");
ylabel("Position [X_{t}]");
legend("Measurements","Filtered Estimate");
title("1D Constant Velocity - Ratio Case 2");
