
clc;clear all;close all;
% column id - inverted
    id_trial = 1;id_coh = 2;id_ndist = 3;id_RT = 4;id_meanD = 5;id_correct = 6;id_block = 7;
    
    % conditions-inverted
    coherence = [0 0.5 1];
    ndistractors = [2 4 8];
% Choose avialable subject
for whichsub = 1:39
    remove_outliers= 3; % 0: no / other numbers: criterion (remove_outliers*SD)
    if whichsub ~= 13
    dataset = load(['In' num2str(whichsub) '_waldo_data.mat']);
    dataset = dataset.data_cell;
    
    % columns: [1trial 2coherence 3ndist 4RT 5meanD2target 6correct]
    data = cell2mat(dataset(:,1:5));
    data(:,6) = double(cell2mat(dataset(:,6)));
    
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
    data = data(data(:,id_block)>1,:);
    
    q = 1;
    for whichcoh = coherence
        
        tempdata1 = data(data(:,id_coh)==whichcoh,:);
        
        for whichndist = ndistractors
            
            % select data in an n distractor condition
            tempdata2 = tempdata1(tempdata1(:,id_ndist)==whichndist,:);
            
            % select only the correct trials
            tempdata2 = tempdata2(tempdata2(:,id_correct)==1,:);
            tempacc = length(tempdata2)/40;
            if whichsub >13
            acc(whichsub-1,q) = tempacc;
            elseif whichsub <13
                acc(whichsub,q) = tempacc;
            end
            
            q = q+1;
            
        end
        
        right_count=data(data(:,id_correct)==1,id_correct);
        if whichsub>13
        acc_all(whichsub-1,1) = sum(right_count)/length(data);
        elseif whichsub<13
            acc_all(whichsub,1) = sum(right_count)/length(data);
        end 
        
        
        
    end
    end 
    
end

accuracy_invert = [acc_all,acc];
%%
figure(1); hist(accuracy_invert(:,1));
aveline = mean(accuracy_invert(:,1))-3*std(accuracy_invert(:,1));
aveline_mu = mean(accuracy_invert(:,1));
line([aveline,aveline], ylim, 'LineWidth', 2, 'Color', 'r');
line([aveline_mu,aveline_mu], ylim, 'LineWidth', 2, 'Color', 'b');
xlabel('averaged Invert task accuracy');
ylabel('counts');

figure(2);  

for i = 2:10
    dline(i-1,1) = mean(accuracy_invert(:,i))-3*std(accuracy_invert(:,i));
    dline_mu(i-1,1) = mean(accuracy_invert(:,i));
    
    subplot(3,3,i-1);
    hist(accuracy_invert(:,i));
    line([dline(i-1),dline(i-1)], ylim, 'LineWidth', 2, 'Color', 'r');
    line([dline_mu(i-1),dline_mu(i-1)], ylim, 'LineWidth', 2, 'Color', 'b');
end

xlabel('number of ditractors');
ylabel('coherence level');



