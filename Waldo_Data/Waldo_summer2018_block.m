clear all;
close all;
whichsub = 37;
remove_outliers = 3; % 0: no / other numbers: criterion (remove_outliers*SD)

dataset = load(['waldo_' num2str(whichsub) '_waldo_data.mat']);
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

block_row1 = 1;
block_row2 = 1;
block_row3 = 1;
block_row4 = 1;
block_row5 = 1;

for j = 1: ntrials
    if data(j, 7) == 1
       data_block1(block_row1, 1:7) = data(j, 1:7);
       block_row1 =  block_row1 + 1;
    end
    
    if data(j, 7) == 2
       data_block2(block_row2, 1:7) = data(j, 1:7);
       block_row2 =  block_row2 + 1;
    end
    
    if data(j, 7) == 3
       data_block3(block_row3, 1:7) = data(j, 1:7);
       block_row3 =  block_row3 + 1;
    end
    
    if data(j, 7) == 4
       data_block4(block_row4, 1:7) = data(j, 1:7);
       block_row4 =  block_row4 + 1;
    end
    
    if data(j, 7) == 5
       data_block5(block_row5, 1:7) = data(j, 1:7);
       block_row5 =  block_row5 + 1;
    end
end


whichblock = data_block1; %**
%p = 1;
%for whichcoh = coherence
    
    % select data in a coherence condition 
    tempdata1 = whichblock;

    %q = 1;
   % for whichndist = ndistractors
        
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
            tempdata3 = tempdata2(abs(tempdata2(:,id_RT)) < tempmean+remove_outliers*tempSD,:);
        end
        
        % calculate mean again 
        meandata_removed = mean(tempdata3);
        
        % store
        meanRT = meandata_removed(1,id_RT);
        
        %q = q+1;

    %end

    %p = p+1;

%end

right_count=whichblock(:,6);
count=0;
for a=1:length(right_count);
    if right_count(a)==1
        count = count+1;
    end
end
accuracy = count/length(right_count);

%copythese(whichsub,:) = [meanRT(1,:) meanRT(2,:) meanRT(3,:)];
    
    
