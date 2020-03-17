%% Waldo average code for Inverted Experiment 
% PSC summer 2019-Inverted | get individual avearages 

clc;clear all;close all;
% Choose avialable subject
whichsub = 38;
remove_outliers= 3; % 0: no / other numbers: criterion (remove_outliers*SD)

dataset = load(['In' num2str(whichsub) '_waldo_data.mat']);
dataset = dataset.data_cell;

% columns: [1trial 2coherence 3ndist 4RT 5meanD2target 6correct]
data = cell2mat(dataset(:,1:5));
data(:,6) = double(cell2mat(dataset(:,6)));

% column id - inverted
id_trial = 1;
id_coh = 2;
id_ndist = 3;
id_RT = 4;
id_meanD = 5;
id_correct = 6;
id_block = 7;

% conditions-inverted
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

% select blocks bigger than 1 
checkdata= data(data(:,id_block)==1,:);
data = data(data(:,id_block)>1,:);

p = 1;
for whichcoh = coherence
    
    % select data in a coherence condition 
    tempdata1 = data(data(:,id_coh)==whichcoh,:);

    q = 1;
    for whichndist = ndistractors
        
        % select data in an n distractor condition 
        tempdata2 = tempdata1(tempdata1(:,id_ndist)==whichndist,:);
        
        % select only the correct trials
        tempdata2 = tempdata2(tempdata2(:,id_correct)==1,:);
        
        meandata = mean(tempdata2);
        SDdata = std(tempdata2);
        
        tempmean = meandata(1,id_RT);
        tempSD = SDdata(1,id_RT);
        
        % outlier removal
        if remove_outliers > 0 
            tempdata3 = tempdata2(abs(tempdata2(:,id_RT)) < tempmean+remove_outliers*tempSD,:);
        end
        
        % recalculate the mean 
        meandata_removed = mean(tempdata3);
        
        % save
        meanRT(p,q) = meandata_removed(1,id_RT);
        
        q = q+1;

    end

    p = p+1;

end

%% check 
right_count=data(data(:,id_correct)==1,id_correct);
accuracy = sum(right_count)/length(data);

for i = 1:3
    plot(ndistractors,meanRT(i,:)); hold on;
end
legend('0','0.5','1');

result(1,:) = [meanRT(1,:) meanRT(2,:) meanRT(3,:)]
result = [accuracy, result];
    
