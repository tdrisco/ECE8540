% Tim Driscoll 
% Lab 1 - Model Fitting
% 8/31/21

clear
clc
close all

%% Part 1 fitting a 2D line

xpoints = [5,6,7,8,9];
ypoints = [1,1,2,3,5];

A = [5,1;6,1;7,1;8,1;9,1]; %basis functions (xi,1)
b =[1;1;2;3;5];            %yi values

%calculate for unknows (x) which represents m and b in the model y = mx + b
x = ((A'*A)^-1)*A'*b;
fprintf("For part one the calculated values for the line model are as follows\n");
fprintf("Slope: %0.3f\nb: %0.3f\n\n",x(1),x(2));
%Calculate y values for fitted model
xfitted = 5:0.01:9;
yfitted = x(1)*xfitted + x(2);

%Plot the raw data aswell as a fitted line.
figure('Color','w');
subplot(1,2,1)
plot(xpoints,ypoints,'ko', 'markerfacecolor','k','markersize',3);
axis([4.5 9.5 -0.5 15])
hold on
plot(xfitted,yfitted,'k-');
xlabel('x')
ylabel('y')
title('Straight Line Model - Data Set 1');
legend('Data','Model','Location','NorthEast')
%equation = sprintf("y = %0.3fx + %0.03f",x(1),x(2));
%text(4.5,4,equation,"EdgeColor","k");

%% Part 2 fitting a 2D line (additional point)

xpoints = [5,6,7,8,8,9];
ypoints = [1,1,2,3,14,5];

A = [5,1;6,1;7,1;8,1;8,1;9,1]; %basis functions (xi,1)
b =[1;1;2;3;14;5];            %yi values

%calculate for unknows (x) which represents m and b in the model y = mx + b
x = ((A'*A)^-1)*A'*b;
fprintf("For part two the calculated values for the line model are as follows\n");
fprintf("Slope: %0.3f\nb: %0.3f\n\n",x(1),x(2));

%Calculate y values for fitted model
xfitted2 = 5:0.01:9;
yfitted2 = x(1)*xfitted + x(2);

%Plot the raw data aswell as a fitted line.
%figure('Color','w');
subplot(1,2,2)
plot(xpoints,ypoints,'ko', 'markerfacecolor','k','markersize',3);
axis([4.5 9.5 -0.5 15])
hold on
plot(xfitted2,yfitted2,'k-');
xlabel('x')
ylabel('y')
title('Straight Line Model - Data Set 2');
legend('Data','Model','Location','NorthWest')
%equation = sprintf("y = %0.3fx + %0.03f",x(1),x(2));
%text(4.5,4,equation,"EdgeColor","k");

%Expalnation of difference between the models in part 1 and 2 when the point
%(8,14) is added.
% This point is an outlier relative to the typical why positions in the
% data set. The typical why values ranged from 1-5 so a value of 14 rotated
% the modeled line towards teh left (positive yaxis). From part 1 to part 2
% the slope changed from 1.000 to 1.815 and the yintercept changed from
% -4.600 to -8.677. Both values almost doubled from part 1 to part 2.
% Overall the addition of the outlier point in part 2 negatively impacted
% the accuracy of the model and largely increased the value of the
% residual.

%% Part 3 Designing a model for "83people-all-meals.txt"

%read in all the data
%Data format: Employee ID, Meal ID, # of Bites, # of kilocalories
fileID = fopen('83people-all-meals.txt','r');
data = fscanf(fileID,'%f %f %f %f',[4,Inf]);
data = data';

xpoints = data(:,3);
ypoints = data(:,4)./data(:,3);

A = 1./xpoints;
A(:,2) = 1;
b = ypoints;
x = ((A'*A)^-1)*A'*b;

A2 = 1./(xpoints.^(1/2));
A2(:,2) = 1;
b2 = ypoints;
x2 = ((A2'*A2)^-1)*A2'*b2;

A3 = exp(-xpoints);
A3(:,2) = 1;
b3 = ypoints;
x3 = ((A3'*A3)^-1)*A3'*b3;

A4 = -log(xpoints);
b4 = ypoints;
x4 = ((A4'*A4)^-1)*A4'*b4;

xfitted = 1:0.01:max(xpoints);
yfitted = x(1)*(1./xfitted) + x(2);

xfitted2 = 0:0.0001:max(xpoints);
yfitted2 = x2(1)*(1./(xfitted2.^(1/2))) + x2(2);

xfitted3 = 0:0.0001:max(xpoints);
yfitted3 = x3(1)*exp(-xfitted3) + x3(2);

xfitted4 = 0:0.0001:max(xpoints);
yfitted4 = x4*-log(xfitted3);

index = find(xpoints <100.0);
index2 = find(xpoints >= 100.0);
count = 1;
for i =1:3:length(index)
    xpoints2(count) = xpoints(index(i));
    ypoints2(count) = ypoints(index(i));
    count = count +1;
end
for i =1:1:length(index2)
    xpoints2(count) = xpoints(index2(i));
    ypoints2(count) = ypoints(index2(i));
    count = count +1;
end
%Plot the raw data aswell as a fitted line.
figure('Color','w');
plot(xpoints2,ypoints2,'ko', 'markerfacecolor','k','markersize',1);
axis([0 350 0 300])
xlabel("Number of Bites");
ylabel("Kilocalories per Bite");
hold on
%plot(xfitted,yfitted,'b-');
plot(xfitted2,yfitted2,'k-', 'lineWidth',2);
%plot(xfitted3,yfitted3,'k-');
%plot(xfitted4,yfitted4,'y-');
title('Inverse Power Model - Part 3');
legend('Data','Model','Location','NorthEast')
%equation = sprintf("y = %0.3f(1/x)^{1/2} + %0.03f",x2(1),x2(2));
%text(150,150,equation,"EdgeColor","k");
