% Tim Driscoll
% Lab 7 - Viterbi Algorithm
% 11/23/21

clear
clc
close all

%Example input
Inputs = {'GGCACTGAA','TCAGCGGCT'};


P_start = [log2(0.5),log2(0.5)]; %From start to H/L
%Index 1 is stay index two is leave
P_TH = [log2(0.5),log2(0.5)]; %Transitions for state H
P_TL = [log2(0.6),log2(0.4)]; %Transitions for state L
P_ValH = [log2(0.2),log2(0.3),log2(0.3),log2(0.2)];
P_ValL = [log2(0.3),log2(0.2),log2(0.2),log2(0.3)];


for j = 1:1:length(Inputs)
    %Setup table to print out probabilities
    fprintf("Initial Sequence: %s\n",Inputs{j})
    fprintf("Letter\t\tH\t\t\tL\n")
    Input = Inputs{j};
    L_input = length(Input);
    %Caluclate the sum of the log2 probabilities
    for i = 1:1:L_input
        if(i == 1)%need to use start probabilities
            if(strcmpi(Input(i),'A'))
                P(i,1) = P_start(1) + P_ValH(1);
                P(i,2) = P_start(2) + P_ValL(1);
            elseif(strcmpi(Input(i),'C'))
                P(i,1) = P_start(1) + P_ValH(2);
                P(i,2) = P_start(2) + P_ValL(2);
            elseif(strcmpi(Input(i),'G'))
                P(i,1) = P_start(1) + P_ValH(3);
                P(i,2) = P_start(2) + P_ValL(3);
            else %If input letter is a T
                P(i,1) = P_start(1) + P_ValH(4);
                P(i,2) = P_start(2) + P_ValL(4);
            end
        else
            if(strcmpi(Input(i),'A'))
                P(i,1) = P_ValH(1) + max([(P(i-1,1)+P_TH(1)),(P(i-1,2)+P_TL(2))]);
                P(i,2) = P_ValL(1) + max([(P(i-1,1)+P_TH(2)),(P(i-1,2)+P_TL(1))]);
            elseif(strcmpi(Input(i),'C'))
                P(i,1) = P_ValH(2) + max([(P(i-1,1)+P_TH(1)),(P(i-1,2)+P_TL(2))]);
                P(i,2) = P_ValL(2) + max([(P(i-1,1)+P_TH(2)),(P(i-1,2)+P_TL(1))]);
            elseif(strcmpi(Input(i),'G'))
                P(i,1) = P_ValH(3) + max([(P(i-1,1)+P_TH(1)),(P(i-1,2)+P_TL(2))]);
                P(i,2) = P_ValL(3) + max([(P(i-1,1)+P_TH(2)),(P(i-1,2)+P_TL(1))]);
            else %If input letter is a T
                P(i,1) = P_ValH(4) + max([(P(i-1,1)+P_TH(1)),(P(i-1,2)+P_TL(2))]);
                P(i,2) = P_ValL(4) + max([(P(i-1,1)+P_TH(2)),(P(i-1,2)+P_TL(1))]);
            end
        end
       fprintf("%c\t\t\t%0.2f\t\t%0.2f\n",Input(i),P(i,1),P(i,2))
    end
    for i = 1:1:L_input
        Output(i) = 'L';
    end
    %Backtrack to determine the proper sequence
    for i = L_input:-1:1
        if(P(i,1) > P(i,2))
            Output(i) = 'H';
        end
    end
    fprintf("Final Output: %s\n\n",Output)
end