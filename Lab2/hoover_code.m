% Tim Driscoll 
% Lab 2 - Hoover Code
% 8/31/21

clear
clc
close all


truea = 2.3;

for i=1:1:110
    x(i)= (i)/100.0;
    y(i) = exp(truea*x(i));
end

an = 4;

for j=1:1:50000
    fan = 0;
    fpan = 0;
    for i = 1:1:110
        fan = fan + ((y(i)*exp(x(i)*an)) - (exp(2.0*x(i)*an)));
        fpan = fpan + ((x(i)*y(i)*exp(x(i)*an)) - (2.0*x(i)*exp(2.0*x(i)*an)));
    end
    an1 = an-(fan/fpan);
    fprintf('%0.3f\t%0.3f\n',an,an1);
    if(abs(an-an1) < 0.0000001)
        break;
    end
    an=an1;
end
fprintf('%d interations',j);