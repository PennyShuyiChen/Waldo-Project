%% Waldo Stroop effect Group aves - PSc 2020 
% Get group aves 
% Conditions: 0-> incongruent; 1-> congruent; 2-> front-view (baseline)
clc;clear all;close all;


%% load data
nsub = 39; % Posner and inverted data check 
Data_pos;
Data_accin;

%% Posner data column_ids 1-9
accuracy_all =1; accuracy_in = 2; accuracy_v =3; accuracy_n = 4;
RT_in = 5; RT_v = 6; RT_n = 7;
index_in = 8; index_v = 9;

% conditions & parameters
coherence = [0 1];
ndistractors =  [8];
valid = [0 1 2];    
valid_index = [0 1];

%group average plots:
for i = 1:length(valid)
    meanRT(1,i)= mean(data_pos(1:nsub,i+4));
    condition_SEM(1,i) = std(data_pos(1:nsub,i+4))/sqrt(nsub);
    meanAccuracy(1,i)= mean(data_pos(1:nsub,i+1));
    accuracy_SEM(1,i) = std(data_pos(1:nsub,i+1))/sqrt(nsub);
end
figure(1);
subplot(2,3,1);
errorbar(valid(1,:),meanRT(1,:),condition_SEM(1,:));hold on;
plot(valid(1,:),meanRT(1,:));
title('RT');
ylabel('Average Response Time (sec)');xlabel('Validity');
hold on; grid on;
%bar(valid,meanRT);

subplot(2,3,4);
for j = 1:nsub
    plot(valid(1,:),data_pos(j,5:7)); hold on;grid on;
    title('individual RT curve');
end
ylabel('Average Response Time (sec)');xlabel('Validity');


subplot(2,3,2);
errorbar(valid(1,:),meanAccuracy(1,:),accuracy_SEM(1,:));hold on;
plot(valid(1,:),meanAccuracy(1,:));
hold on; grid on; title('Accuracy');
ylabel('Average Accuracy %');xlabel('Validity');

subplot(2,3,5);
for j = 1:nsub
    plot(valid(1,:),data_pos(j,2:4)); hold on;grid on;
    title('individual Accuracy curve');
end 
ylabel('Average Accuracy %');xlabel('Validity');



% benefit index curves
for i = 1:length(valid_index)
    meanIndex(1,i)= mean(data_pos(1:nsub,i+7));
    index_SEM(1,i)= std(data_pos(1:nsub,i+7))/sqrt(nsub);
end
subplot(2,3,3);
errorbar(valid_index(1,:),meanIndex(1,:),index_SEM(1,:));hold on;
plot(valid_index(1,:),meanIndex(1,:));
title('BI');
ylabel('Average Benefit Index (sec)');xlabel('Validity');
hold on; grid on;

subplot(2,3,6);
for j = 1:nsub
    plot(valid_index(1,:),data_pos(j,8:9)); hold on;grid on;
    title('individual Benifit Index curve');
end
ylabel('Average Benifit Index (sec)');xlabel('Validity');
result = [meanRT,meanAccuracy,meanIndex];


%% Other accuracies & incorrect analysis 
block = [1:5];
% block & cumulative accuracies column ids 
bl1 =1;bl2_1=2; bl2_2=3; bl3_1=4; bl3_2=5;
cum1_1=6; cum2_1=7; cum2_2=8;cum3_1=9; all = 10;

% incorrect trials column ids
in_m=11; inin_in=12; inv_m=13; inb_m=14; m=15;
in1_m1=16;	inin1_in1=17; inv1_m1=18; inb1_m1=19; m1 =20;


% block & cumulative accuracies 
figure(2);
for i = 1:length(block)
    meanBL(1,i)= mean(data_accin(1:nsub,i));
    BL_SEM(1,i) = std(data_accin(1:nsub,i))/sqrt(nsub);
    meanCM(1,i)= mean(data_accin(1:nsub,i+5));
    CM_SEM(1,i) = std(data_accin(1:nsub,i+5))/sqrt(nsub);
end
subplot(2,3,1);
errorbar(block(1,:),meanBL(1,:),BL_SEM(1,:));hold on;
plot(block(1,:),meanBL(1,:));
title('Block Accuracies');
ylabel('Accuracy by Block %');xlabel('Block');
hold on; grid on;

subplot(2,3,4);
for j = 1:nsub
    plot(block(1,:),data_accin(j,bl1:bl3_2)); hold on;grid on;
    title('Individual Block Accuracies');
end
ylabel('Accuracy by Block %');xlabel('Block');

subplot(2,3,2);
errorbar(block(1,:),meanCM(1,:),CM_SEM(1,:));hold on;
plot(block(1,:),meanCM(1,:));
title('Cumulative Accuracies');
ylabel('Accuracy by Block %');xlabel('Block');
hold on; grid on;

subplot(2,3,5);
for j = 1:nsub
    plot(block(1,:),data_accin(j,cum1_1:all)); hold on;grid on;
    title('Individual Block Accuracies');
end
ylabel('Accuracy by Block %');xlabel('Block');

%% Incorrect trails 
Incorrect = [0, 0.5, 1, 2];
data_in1 = data_accin(data_accin(:,m1)~=0,:);
 for i = 1:length(Incorrect)
    meanIn1(1,i)= mean(data_accin(1:nsub,i+15));
    In1_SEM(1,i) = std(data_accin(1:nsub,i+15))/sqrt(nsub);
end
subplot(2,3,3);
errorbar(Incorrect(1,:),meanIn1(1,:),In1_SEM(1,:));hold on;
plot(Incorrect(1,:),meanIn1(1,:));
title('Incorrect trails with BL1');
ylabel('Proportion %');xlabel('Validity');
hold on; grid on;

data_in = data_accin(data_accin(:,m)~=0,:);
 for i = 1:length(Incorrect)
    meanIn(1,i)= mean(data_accin(1:nsub,i+10));
    In_SEM(1,i) = std(data_accin(1:nsub,i+10))/sqrt(nsub);
end
subplot(2,3,6);
errorbar(Incorrect(1,:),meanIn(1,:),In_SEM(1,:));hold on;
plot(Incorrect(1,:),meanIn(1,:));
title('Incorrect trails wo BL1');
ylabel('Proportion %');xlabel('Validity');
hold on; grid on;








