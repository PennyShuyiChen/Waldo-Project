%% Waldo Stroop effect analysis code - PSC 2020 
% Get individual avearages
% Conditions: 
% 
clear all; close all; clc;

%% Choose avialable subject
whichsub = 1;
remove_outliers= 3; % 0: no / other numbers: criterion (remove_outliers*SD)

%dataset = load(['St' num2str(whichsub) '_waldo_data.mat']);
dataset = load(['St0_waldo_data.mat']);
dataset = dataset.data_cell;

% columns: [1trial 2coherence 3ndist 4RT 5meanD2target 6correct]
data = cell2mat(dataset(:,1:7));

% column id - Stroop effect
id_trial = 1;
id_cong = 2;

% id_dirG = 3;
id_ndist = 3;
% id_dirL = 4;
id_RT = 5;
id_correct = 6;
id_block = 7;

% conditions- Stroop 

congruence = [0 1 2];

% add block info
%nblock = 5;
%ntrials = size(data,1);
%ntrblock = ntrials/nblock;
%temp = [];
%for i = 1:nblock
%    temp = [temp; ones(ntrblock,1)*i];
%end
%data(:,7) = temp;

% select blocks bigger than 1 
%checkdata= data(data(:,id_block)==1,:);
%data = data(data(:,id_block)>1,:);

q = 1;
for whichcong = congruence
    
    % select data in a coherence condition 
    tempdata1 = data(data(:,id_cong)==whichcong,:);

        % select data in an n distractor condition 
        %tempdata2 = tempdata1(tempdata1(:,id_ndist)==whichndist,:);
        
        % select only the correct trials
        tempdata2 = tempdata1(tempdata1(:,id_correct)==1,:);
        
        meandata = mean(tempdata2);
        SDdata = std(tempdata2);
        
        tempmean = meandata(1,id_RT);
        tempSD = SDdata(1,id_RT);
        
        % outlier removal
        if remove_outliers > 0 
            %tempdata4 = tempdata2(abs(tempdata2(:,id_RT)) >= tempmean+remove_outliers*tempSD,:);
            tempdata3 = tempdata2(abs(tempdata2(:,id_RT)) < tempmean+remove_outliers*tempSD,:);
        end
        
        % recalculate the mean 
        meandata_removed = mean(tempdata3);
        
        % save
        meanRT(1,q) = meandata_removed(1,id_RT);
        meanAccuracy(1,q) = length(tempdata2)/100;
        q = q+1;

    %end



end 

%% check 
%right_count=data(data(:,id_correct)==1,id_correct);
%accuracy = sum(right_count)/length(data);
figure(1);
%for i = 1:3
subplot(2,1,1);
plot(congruence,meanRT(1,:)); hold on;

subplot(2,1,2);
plot(congruence,meanAccuracy(1,:)); hold on;

result = [meanRT, meanAccuracy]
%result = [accuracy, result];

