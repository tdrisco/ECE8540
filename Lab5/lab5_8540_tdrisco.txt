% Tim Driscoll 
% Lab 5 - Extended Kalman Filter
% 10/21/21

clear
clc
close all

%% Read in measurments and plot for reference
fileID = fopen('sin-data.txt','r');
measurements = fscanf(fileID,'%f %f',[2,Inf]);
measurements = measurements';
[r,c] = size(measurements);
t = linspace(1,r,r);

%% Plot the truth and measurments
figure('Color','w');
plot(t,measurements(:,2),'k-') %plotting the measurements
xlabel("Time [T]");
ylabel("Sinusoid Height [h_{t}]");


%% Define the Kalman Variables

%define the sate variables/covariance
X = [0;0;measurements(1,2)]; %State variables
S = [1 0 0; 0 1 0; 0 0 1];  %State transition matrix
I = [1 0 0; 0 1 0; 0 0 1];  %3x3 Identity Matrix

%define the jacobians
J_dfdx = [1 1 0; 0 1 0; (1/10)*cos(X(1)/10) 0 0];
J_dfda = [0 0 0; 0 1 0; 0 0 0];
J_dgdx = [0 0 1];
J_dgdn = [1];

%define the noise covariances
Q = [0 0 0; 0 0.001 0; 0 0 0]; %dynamic noise covariance (how much prediction is trusted (0 is no noise))
R = [1]; %measurement noise

%% Loop to perform Kalman Estimation
for tt = 1:1:r
    J_dfdx(3,1) = (1/10)*cos(X(1)/10); %Update the jacobians
    
    Xt_t1(1,1) = X(1) + X(2);
    Xt_t1(2,1) = X(2);
    Xt_t1(3,1) = sin(X(1)/10);
    
    St_t1 = J_dfdx*S*J_dfdx' + J_dfda*Q*J_dfda';
    Yt = measurements(tt,2);
    Kt = St_t1*J_dgdx'*((J_dgdx*St_t1*J_dgdx' + J_dgdn*R*J_dgdn')^-1);
    
    g = sin(X(1)/10);
    X = Xt_t1 + Kt*(Yt - g);
    S = (I - Kt*J_dgdx)*St_t1;
    
    estimates(tt) = X(3); 
end
figure('Color','w');
plot(t,estimates,'k-')
hold on
plot(t,measurements(:,1),'r-') %plotting the truth
xlabel("Time [T]");
ylabel("Sinusoid Height [h_{t}]");
axis([0 800 -1.5 1.5])
legend("Filter Estimates","Ground Truth");
%legend("Ground Truth","Filter Estimates");

