clear all;
close all;

whichsub = 1;
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

p = 1;

% select blocks bigger than 1 
data = data(data(:,id_block)>1,:);

tempdata1 = data(data(:,id_correct)==1,:);
meandata = mean(tempdata1);
SDdata = std(tempdata1);
tempmean = meandata(1, id_RT);
tempSD = SDdata(1, id_RT);


% outlier removal
if remove_outliers>0
    tempdata2 = tempdata1(abs(tempdata1(:, id_RT))<tempmean + remove_outliers * tempSD,:);
end 
meandata_removed = mean(tempdata2);
  

    
    
