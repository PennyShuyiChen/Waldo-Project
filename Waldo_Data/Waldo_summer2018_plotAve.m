%%
clear all;
close all;
% Created by PSC 2018 summer 
whichsub = 37;
remove_outliers = 3; % 0: no / other numbers: criterion (remove_outliers*SD)

dataset = load(['waldo_' num2str(whichsub) '_waldo_data.mat']);
%dataset = load(['waldo_spring19_pilot_1_waldo_data.mat']);
%dataset = load(['test_spring19_full_waldo_data.mat']);
dataset = dataset.data_cell;

% columns: [1trial 2coherence 3ndist 4RT 5meanD2target 6correct]
data = cell2mat(dataset(:,1:5));
data(:,6) = double(cell2mat(dataset(:,6)));

% column id
id_trial = 1;
id_coh = 2;
id_ndist = 3;
id_RT = 4;
id_correct = 6;
id_meanD = 5;
id_block = 7;

% conditions
coherence = [0 0.5 1];
ndistractors = [2 4 8];

% add block info
nblock = 5;
ntrials = size(data,1);
ntrblock = ntrials/nblock;
temp = [];
for i = 1:nblock
    temp = [temp; ones(ntrblock,1)*i];
end
data(:,7) = temp;

p = 1;

%% select blocks bigger than 1 
checkdata= data(data(:,id_block)==1,:);
data = data(data(:,id_block)>1,:);

%% Data calculation 
for whichcoh = coherence
    
    % select data in a coherence condition 
    tempdata1 = data(data(:,id_coh)==whichcoh,:);
    accuracy_level = 0;
    q = 1;
    for whichndist = ndistractors
        
        % select data in an n distractor condition 
        tempdata2 = tempdata1(tempdata1(:,id_ndist)==whichndist,:);
        
        % select only the correct trials
        tempdata2 = tempdata2(tempdata2(:,id_correct)==1,:);
        accuracy_level = length(tempdata2)/40;
        meandata = mean(tempdata2);
        SDdata = std(tempdata2);
        
        tempmean = meandata(1,id_RT);
        tempSD = SDdata(1,id_RT);
        
        % outlier removal
        if remove_outliers > 0 
            tempdata3 = tempdata2(abs(tempdata2(:,id_RT)) < tempmean+remove_outliers*tempSD,:);
        end
        
        % calculate mean again 
        meandata_removed = mean(tempdata3);
        
        % store
        meanRT(p,q) = meandata_removed(1,id_RT);
        meanAccuracy(p,q) = accuracy_level;
        q = q+1;

    end

    p = p+1;

end

right_count=data(:,6);
count=0;
for a=1:length(right_count);
    if right_count(a)==1
        count = count+1;
    end
end
accuracy = count/length(right_count);

for i = 1:3
    plot(ndistractors,meanRT(i,:)); hold on;
end
legend('0','0.5','1');

%copythese(whichsub,:) = [meanD2T(1,:) meanD2T(2,:) meanD2T(3,:)];
  sc = 0; 
  for i=1:360 
      if data(i,2) == 1 && data(i,6)==1
          sc = sc+1; 
      end 
  end 
    
%% Accuracy Histoograms
%% Posener Accuracy:
load('Original_acc.mat');
acc_ave = Original_acc(:,1); sd_ave = mean(acc_ave)-3*std(acc_ave);

figure(1);
hist(acc_ave); title('Original Task - Averaged accuracy');
line([mean(acc_ave), mean(acc_ave)], ylim, 'LineWidth', 2, 'Color', 'b');
line([sd_ave, sd_ave], ylim, 'LineWidth', 2, 'Color', 'r');


figure(2);
title('Accuracy across Conditions');
for i = 1:9
    acc_con_ave = Original_acc(:,i+1); sd_con_ave = mean(acc_con_ave)-3*std(acc_con_ave);
    subplot(3,3,i); hist(acc_con_ave); 
    line([mean(acc_con_ave), mean(acc_con_ave)], ylim, 'LineWidth', 2, 'Color', 'b');
    line([sd_con_ave, sd_con_ave], ylim, 'LineWidth', 2, 'Color', 'r');
    hold on;
end 


