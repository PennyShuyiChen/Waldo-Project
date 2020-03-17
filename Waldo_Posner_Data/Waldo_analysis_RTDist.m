%% Waldo Posner Pradigm individual analysis code

clc;clear all;
close all;
%Choose available subject

baseline = {}; validd = {}; invalidd = {}; endresult = {};
in_countbA =0; in_countA = 0;in_count_inA =0;
remove_outliers = 3; % 0: no / other numbers: criterion (remove_outliers*3SD)

%%
for whichsub = 1:39
    
    in_countb =0; in_count = 0;in_count_in =0;tempcount =0;
    
    
    dataset = load(['Pos' num2str(whichsub) '_waldo_data.mat']);
    
    dataset = dataset.data_cell;
    
    % columns: [1trial 2coherence 3distractor 4validity 5RT 6MD 7Tfound 14bl]
    data = cell2mat(dataset(:,1:6));
    data(:,8) = cell2mat(dataset(:,14)); %block info
    data(:,7) = double(cell2mat(dataset(:,7))); %T found
    data(:,9) = double(cell2mat(dataset(:,8))); %clicked ID
    data(:,10) = double(cell2mat(dataset(:,16))); % PT ID
    
    % column id
    id_trial = 1;id_coh = 2; id_ndist = 3;id_valid = 4;id_RT = 5;id_meanD = 6;id_correct = 7;id_block = 8;id_clicked =9;id_PT = 10;
    data = sortrows(data,id_trial);
    % conditions
    coherence = [0 1];
    valid = [0 1 2 ];
    vtrials = [48 12 60];
    
    %% select blocks bigger than 1 (exp trails)
    %checkdata= data(data(:,id_block)==1,:);
    data = data(data(:,id_block)>1,:);
    data = data(data(:,id_correct)==1,:);
    size(data)
    for ii = 1:length(data)
        if data(ii,id_valid) == 0
            in_countb = in_countb + 1;
            in_countbA = in_countbA + 1;
            baseline{whichsub}(in_countb,1) = data(ii,id_RT);
            baselineT{1,:}(in_countbA,1) = data(ii,id_RT);
            
        elseif data(ii,id_valid) ==1
            in_count = in_count + 1;
            in_countA = in_countA + 1;
            validd{whichsub}(in_count,1) = data(ii,id_RT);
            validdT{1,:}(in_countA,1) = data(ii,id_RT);
        elseif data(ii,id_valid) ==2
            in_count_in = in_count_in + 1;
            in_count_inA = in_count_inA + 1;
            invalidd{whichsub}(in_count_in,1) = data(ii,id_RT);
            invaliddT{1,:}(in_count_inA,1) = data(ii,id_RT);
        end
        
    end
    
    figure(whichsub);
    subplot(1,3,1)
    hist(baseline{whichsub});
    subplot(1,3,2);
    hist(validd{whichsub});
    subplot(1,3,3);
    hist(invalidd{whichsub});
    
    
    %% outliers check
    
    for whichvalid = valid
        tempdata2 = data(data(:,id_valid)==whichvalid,:);
        
        % select only the correct trials
        tempdata2 = tempdata2(tempdata2(:,id_correct)==1,:);
        meandata = mean(tempdata2);
        SDdata = std(tempdata2);
        tempmean = meandata(1,id_RT);
        tempSD = SDdata(1,id_RT);
        
        tempdata3 = tempdata2(abs(tempdata2(:,id_RT)) < tempmean+remove_outliers*tempSD,:);
        
        tempsize2 = size(tempdata2);tempsize3=size(tempdata3);
        tempcount = tempsize2(1)-tempsize3(1);
        % outlier removal
        
        
        endresult{whichsub}(whichvalid+1,1) = tempcount;
        
        
    end
    
end

figure(40);
subplot(1,3,1);
hist(baselineT{:}); hold on;
subplot(1,3,2);
hist(validdT{:});hold on;
subplot(1,3,3);
hist(invaliddT{:});hold on;

%% Posener Accuracy:
load('Posner_Acc_all.mat');
acc_ave = Posner_accuracy_all(:,1); sd_ave = mean(acc_ave)-3*std(acc_ave);
acc_inv = Posner_accuracy_all(:,2); sd_inv = mean(acc_inv)-3*std(acc_inv);
acc_v   = Posner_accuracy_all(:,3); sd_v   = mean(acc_v)-3*std(acc_v);
acc_neu = Posner_accuracy_all(:,4); sd_neu = mean(acc_neu)-3*std(acc_neu);

figure(1);
subplot(2,2,1); hist(acc_ave); title('Averaged accuracy');
line([sd_ave, sd_ave], ylim, 'LineWidth', 2, 'Color', 'r');
subplot(2,2,2); hist(acc_inv); title('Invalid accuracy');
line([sd_inv, sd_inv], ylim, 'LineWidth', 2, 'Color', 'r');
subplot(2,2,3); hist(acc_v);   title('Valid accuracy');
line([sd_v, sd_v], ylim, 'LineWidth', 2, 'Color', 'r');
subplot(2,2,4); hist(acc_neu); title('Baseline accuracy');
line([sd_neu, sd_neu], ylim, 'LineWidth', 2, 'Color', 'r');




