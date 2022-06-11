% Tim Driscoll 
% Lab 6 - Particle Filter
% 11/16/21

clear
clc
close all

%% Read in measurments and plot for reference

fileID = fopen('magnets-data.txt','r');
measurements = fscanf(fileID,'%f %f %f',[3,Inf]);
measurements = measurements';
[r,c] = size(measurements);
t = linspace(1,r,r);
sensorReadings = measurements(:,3);

%% Plot the truth and measurments

figure('Color','w');
plot(t,measurements(:,1),'k-') %plotting the actual position
xlabel("Time [T]");
ylabel("Position [X(t)]");

figure('Color','w');
plot(t,sensorReadings,'k-') %plotting the sensor readings
xlabel("Time [T]");
ylabel("Total Magnetic Strength [Y(t)]");

%% Define Particle Filter Variables

M = 1000; %Number of particles
%sigma_a = 0.25; %variance of dynamic noise
sigma_a = 0.0625;
sigma_m = 4; 
sigma_n = 0.003906; %variance of measurment noise
Xm1 = -10;
Xm2 = 10;
CV = 0;
resampleCount = 1;

%for jj=1:1:20

for i = 1:1:M
    W(i,1)= 1/M;%Initialize the weights
    X{i} = [0;0];%Initialize the state variables for each particle
end

for tt=1:1:r
    
    E(tt) = 0;
    
    %calculate the new state for each particle
    for i = 1:1:M
        X_t1{i}(1) =  X{i}(1) + X{i}(2);
        
        if(X{i}(1) < -20)
            X_t1{i}(2) = 2;
        elseif(-20 <= X{i}(1) && X{i}(1) < 0)
            X_t1{i}(2) = X{i}(2)+ abs(normrnd(0,sigma_a));%abs(random('Normal',0,sigma_a));
        elseif(0 <= X{i}(1) && X{i}(1) < 20)
            X_t1{i}(2) = X{i}(2)- abs(normrnd(0,sigma_a));%abs(random('Normal',0,sigma_a));
        else
            X_t1{i}(2) = -2;
        end
    end
    
    % Obtain the new measurment reading for current time iteration
    Y_measurement = sensorReadings(tt);
    
    for i = 1:1:M
        % Calculate the ideal measurement of each particle (0 Noise)
        Y_ideal(i) = (1/(sqrt(2*pi())*sigma_m))*exp((-(X_t1{i}(1)-Xm1)^2)/(2*(sigma_m^2))) +...
            (1/(sqrt(2*pi())*sigma_m))*exp((-(X_t1{i}(1)-Xm2)^2)/(2*(sigma_m^2)));
        % Calculate the probability of the ideal measurement given the
        % current measurement for each particle
        P(i) = (1/(sqrt(2*pi())*sigma_n))*exp((-(Y_ideal(i)-Y_measurement)^2)/(2*(sigma_n^2)));
        % Calculate the weight updates
        W_t1(i) = W(i)*P(i);
        
    end
    
    for i = 1:1:M
        % Normalize the wieght updates
        W_t1_norm(i) = W_t1(i)/sum(W_t1);
        
        % Calculate the desired output (which is the mean)
        E(tt) = E(tt) + (X_t1{i}(1) * W_t1_norm(i));
        position(i) = X_t1{i}(1);
    end
    
    %Perform resampling
    for i = 1:1:M
        CV = CV + (M*W_t1_norm(i) - 1)^2;
    end
    
    % Calculate the coefficient of variation statistic 
    CV = CV/M;
    % Determine the effective sample size
    ESS = M/(1+CV);
    
       if(resampleCount == 50)
            figure('Color','w');
            plot(W_t1_norm,position,'ko') %plotting the actual position
            hold on
            plot(0.15,measurements(tt,1),'ro')
            xlabel("Weight");
            ylabel("Position [X(t)]");
            legend({("Particles"),("True Position")})
        end
    
    if(ESS < 0.1*M)
%         if(resampleCount == 40)
%             figure('Color','w');
%             plot(W_t1_norm,position,'ko') %plotting the actual position
%             hold on
%             plot(0.15,measurements(tt,1),'ro')
%             xlabel("Weight");
%             ylabel("Position [X(t)]");
%             legend({("Particles"),("True Position")})
%         end
         fprintf("Resample #%d\t\tIteration #%d\n",resampleCount,tt);
        resampleCount = resampleCount + 1;
        Q = cumsum(W_t1_norm); %The weights should sum to one
        trs = rand(M+1,1);
        T = sort(trs);
        T(M+1) = 1.0;
        i = 1;
        j = 1;
        Index = 0;
        while(i <= M)
            if(T(i) < Q(j))
                Index(i) = j;
                i = i+1;
            else
                j = j+1;
            end
        end
        i = 1;
        while(i <= M)
            X{i} = X_t1{Index(i)};
            position(i) = X_t1{Index(i)}(1);
            W(i) = 1/M;
            i = i+1;
        end
%         if(resampleCount == 41)
%             figure('Color','w');
%             plot(W,position,'ko') %plotting the actual position
%             hold on
%             plot(1/M,measurements(tt,1),'ro')
%             xlabel("Weight");
%             ylabel("Position [X(t)]");
%             legend({("Particles"),("True Position")})
%         end
    else
       W = W_t1_norm;
       X = X_t1;
    end
    
    
end

E = E';
figure('Color','w');
plot(t,measurements(:,1),'k-')
hold on 
plot(t,E,'r-') 
xlabel("Time [T]");
ylabel("Position [X(t)]");
legend({'True Position','Estimated Position'},'location','best');
%end



