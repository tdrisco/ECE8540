% Tim Driscoll 
% Lab 2 - Nonlinear Regression
% 8/31/21

clear
clc
close all

%% Read in the three data sets
fileID = fopen('log-data-A.txt','r');
dataA = fscanf(fileID,'%f %f',[2,Inf]);
dataA = dataA';

fileID = fopen('log-data-B.txt','r');
dataB = fscanf(fileID,'%f %f',[2,Inf]);
dataB = dataB';

fileID = fopen('log-data-C.txt','r');
dataC = fscanf(fileID,'%f %f',[2,Inf]);
dataC = dataC';

allData{1} = dataA;
allData{2} = dataB;
allData{3} = dataC;

%% User input
index = listdlg('liststring',{'log-data-A.txt','log-data-B.txt','log-data-C.txt'});
in = inputdlg('Please enter an intial guess','Initial Guess');
an = str2num(in{1});


x = allData{index}(:,1);
y = allData{index}(:,2);

%% Plot the data
figure('Color','w');
plot(x,y,'ro', 'markerfacecolor','r');
grid on

if(index == 1)
    titleName = sprintf('Log Data Set A');
elseif(index == 2)
    titleName = sprintf('Log Data Set B');
else
    titleName = sprintf('Log Data Set C');
end

title(titleName);
hold on

%% Nonlinear Regression

for j=1:1:50000
    fan = 0;
    fpan = 0;
    for i = 1:1:length(x)
        fan = fan + ((y(i)/an) - (log(x(i)*an)/an));
        fpan = fpan + ((-y(i)/(an^2)) - ((1-log(an*x(i)))/(an^2)));
    end
    an1 = an-(fan/fpan);
    fprintf('%0.6f\t%0.6f\n',an,an1);
    if(abs(an-an1) < 0.0000001)
        break;
    end
    an=an1;
end
fprintf('%d interations',j);

%% Plot the fitted model

xplot = min(x):0.001:max(x);
yplot = log(an1.*xplot);
plot(xplot,yplot,'k-','linewidth',2);