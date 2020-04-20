%% Waldo Posner Pradigm individual analysis code
% cummulative | block accuracy 
clc;clear all;
close all;
%Choose available subject 
whichsub = 39;
remove_outliers = 9; % 0: no / other numbers: criterion (remove_outliers*SD)

dataset = load(['Pos' num2str(whichsub) '_waldo_data.mat']);
%dataset = load(['pf_p4_waldo_data.mat']);
dataset = dataset.data_cell;

% columns: [1trial 2coherence 3distractor 4validity 5RT 6MD 7Tfound 14bl]
data = cell2mat(dataset(:,1:6));
data(:,8) = cell2mat(dataset(:,14)); %block info 
data(:,7) = double(cell2mat(dataset(:,7))); %T found 
data(:,9) = double(cell2mat(dataset(:,8))); %clicked ID
data(:,10) = double(cell2mat(dataset(:,16))); % PT ID 

% column id
id_trial = 1;
id_coh = 2;
id_ndist = 3;
id_valid = 4;
id_RT = 5;
id_meanD = 6;
id_correct = 7;
id_block = 8;
id_clicked =9;
id_PT = 10;

data = sortrows(data,id_trial);

% conditions
coherence = [0 1];
ndistractors = [8];
valid = [0 1 2 ];
vtrials = [48 12 60]; 
%% Block & Cumulative accuracies
% block by block accuracies
bltrial = 30;
accuracy_block = [sum(data(1:30,id_correct))/bltrial,sum(data(31:60,id_correct))/bltrial,sum(data(61:90,id_correct))/bltrial,...
    sum(data(91:120,id_correct))/bltrial,sum(data(121:150,id_correct))/bltrial];

accuracy_cumulative = [sum(data(1:30,id_correct))/30,sum(data(1:60,id_correct))/60,sum(data(1:90,id_correct))/90,...
    sum(data(1:120,id_correct))/120,sum(data(1:150,id_correct))/150];

accuracy_posner = [accuracy_block,accuracy_cumulative];

%% Invalid & Incorrect trials
data_in1 = data(data(:,id_correct)==0,:);
[m1,n1] = size(data_in1);
in_countb1 =0; in_countv1 = 0; in_count1 = 0;in_count_in1 =0;

for i = 1:m1
    if data_in1(i,id_valid)==0
        in_count1 = in_count1+1;
        if data_in1(i,id_clicked)== data_in1(i,id_PT)
           in_count_in1 = in_count_in1+1;
        end
    elseif data_in1(i,id_valid)==1
        in_countv1 = in_countv1+1;
    else
        in_countb1 = in_countb1+1;
    end
end

Inin1 = [in_count1/m1,in_count_in1/in_count1,in_countv1/m1,in_countb1/m1,m1];

%% select blocks bigger than 1 (exp trails)
checkdata= data(data(:,id_block)==1,:);
data = data(data(:,id_block)>1,:);

%% Invalid & Incorrect trials > bl1
data_in = data(data(:,id_correct)==0,:);
[m,n] = size(data_in);
in_countb =0; in_countv = 0; in_count = 0;in_count_in =0;

for i = 1:m
    if data_in(i,id_valid)==0
        in_count = in_count+1;
        if data_in(i,id_clicked)== data_in(i,id_PT)
           in_count_in = in_count_in+1;
        end
    elseif data_in(i,id_valid)==1
        in_countv = in_countv+1;
    else
        in_countb = in_countb+1;
    end
end

Inin = [in_count/m,in_count_in/in_count,in_countv/m,in_countb/m,m];

%% Accuracies
count=0; count_in =0; count_v = 0; count_n =0; 

% select correctness info 
count = sum(data(:,id_correct));

for a=1:length(data);
    if data(a,id_correct)==1 && data(a,id_valid)==0
        count_in = count_in +1;
    elseif data(a,id_correct)==1 && data(a,id_valid)==1
        count_v = count_v +1;
    elseif data(a,id_correct)==1 && data(a,id_valid)==2
        count_n = count_n +1;
    end
end


% Accuracy: overall | invalid | valid | neutral 
accuracy = [count/sum(vtrials),count_in/vtrials(1),count_v/vtrials(2),count_n/vtrials(3)];
%accuracy(1,1) = count/sum(vtrials);
%accuracy(1,2) = count_in/vtrials(1);
%accuracy(1,3) = count_v/vtrials(2);
%accuracy(1,4) = count_n/vtrials(3);
acc_count = [count_in, count_v, count_n];   
    p = 1;q = 1;
    for whichvalid = valid
        tempdata2 = data(data(:,id_valid)==whichvalid,:);
        tempdatap2 = checkdata(checkdata(:,id_valid)==whichvalid,:);
        % select only the correct trials
        tempdata2 = tempdata2(tempdata2(:,id_correct)==1,:);
        tempdatap2 = tempdatap2(tempdatap2(:,id_correct)==1,:);
        
        meandata = mean(tempdata2);
        SDdata = std(tempdata2); 
        meanpdata = mean(tempdatap2);
        SDpdata = std(tempdatap2);
        
        tempmean = meandata(1,id_RT);
        tempSD = SDdata(1,id_RT);
       temppmean = meanpdata(1,id_RT);
       temppSD = SDpdata(1,id_RT);
        
        % outlier removal
        if remove_outliers > 0 
            tempdata3 = tempdata2(abs(tempdata2(:,id_RT)) < tempmean+remove_outliers*tempSD,:);
        end
        
        % calculate mean again 
        meandata_removed = mean(tempdata3);
        
        % store
        meanRT(p,q) = meandata_removed(1,id_RT);
        q = q+1;

    end
    
    check_acc = sum(acc_count);
    if count == check_acc
        %figure(1);
        
        %subplot(2,1,1);bar(valid,meanRT(1,:));title('mean RT'); hold on;
       % subplot(2,1,2);bar(valid,accuracy(1,2:4)); title('accuracy');
        meanRT
        accuracy
        result =[accuracy,meanRT ];   
    end

 