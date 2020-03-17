%Better analysis code for waldo experiment

%This code is meant to be run multiple times from the run button with
%options for specific plots available via responses in the command window

dataset = load('naive_subject_7_waldo_data.mat');
dataset = dataset.data_cell;

data_a = dataset(:,2:5); % columsn: coherence, # distractors, RT(s), MeanDist2Target (pixels)
data_a = cell2mat(data_a);
data_b = cell2mat(dataset(:,6));% this column contains whether or not the participant reached the target
data_c = cell2mat(dataset(:,13:14)); % this column contains the block information + how far the target was from the center

data_d = [data_a,data_b,data_c]; %puts all relevant info for analysis in a convenient matrix

% remove mistrials
mistrials = find(data_d(:,5) == 0);
data_d(mistrials,:) = [];

%find the indicies of all of the data organized by block
block1_ind = find(data_d(:,6) == 1);
block2_ind = find(data_d(:,6) == 2);
block3_ind = find(data_d(:,6) == 3);
block4_ind = find(data_d(:,6) == 4);
block5_ind = find(data_d(:,6) == 5);
block6_ind = find(data_d(:,6) == 6);

%put all the blocks you want to analyze in order (i.e. option to leave out
%blocks if desired)

block_ind_total = [ block2_ind; block3_ind; block4_ind; block5_ind; block6_ind];
block_ind_total2 = {block2_ind, block3_ind, block4_ind, block5_ind, block6_ind};

data = data_d(block_ind_total,:);


% overall subject data

[avRT_4_100,avRT_8_100,avRT_16_100,med_4_100,med_8_100,med_16_100,ste_4_100,ste_8_100,ste_16_100] = RunCoherenceAnalysis(1,data);
[avRT_4_50,avRT_8_50,avRT_16_50,med_4_50,med_8_50,med_16_50,ste_4_50,ste_8_50,ste_16_50] = RunCoherenceAnalysis(.5,data);
[avRT_4_0,avRT_8_0,avRT_16_0,med_4_0,med_8_0,med_16_0,ste_4_0,ste_8_0,ste_16_0] = RunCoherenceAnalysis(0,data);

avg_coh_plot_100 = [avRT_4_100, avRT_8_100, avRT_16_100];
avg_coh_plot_50 = [avRT_4_50, avRT_8_50, avRT_16_50];
avg_coh_plot_0 = [avRT_4_0, avRT_8_0, avRT_16_0];

error_bar_100 = [ste_4_100, ste_8_100, ste_16_100];
error_bar_50 = [ste_4_50, ste_8_50, ste_16_50];
error_bar_0 = [ste_4_0, ste_8_0, ste_16_0];

avg_coh_plot_combined =[avg_coh_plot_100', avg_coh_plot_50', avg_coh_plot_0'];
error_bar_combined = [error_bar_100',error_bar_50',error_bar_0'];
x2 = [ 2 2 2; 3 3 3; 4 4 4];

%uncomment the next four lines to output a plot:
figure
errorbar(x2,avg_coh_plot_combined,error_bar_combined);
legend('100','50','0');
pause

%cumulative data plots or seperate block data

whichplots1 = input('Would you like to plot cumulative block data (1) or seperate block data(2)');

x2 = [ 2 2 2; 3 3 3; 4 4 4];


if whichplots1 == 1% cumulative block plots
    
    cum_plot_ind = [];
    
    whichplots2 = input('Would you like to plot cumulative averages(1) or medians(2)?');
    
    figure;
    
    for ii = 1:6 % remember to adujst depending on how many blocks you actually want to test. if you're only testing  blocks 2-5, adjust ii params
        
        cum_plot_ind = [cum_plot_ind, block_ind_total2{ii}']; %cumulative indicies
        
        c_data = data_d(cum_plot_ind,:);
        
        [cavRT_4_100,cavRT_8_100,cavRT_16_100,cmed_4_100,cmed_8_100,cmed_16_100,cste_4_100,cste_8_100,cste_16_100] = RunCoherenceAnalysis(1,c_data);
        [cavRT_4_50,cavRT_8_50,cavRT_16_50,cmed_4_50,cmed_8_50,cmed_16_50,cste_4_50,cste_8_50,cste_16_50] = RunCoherenceAnalysis(.5,c_data);
        [cavRT_4_0,cavRT_8_0,cavRT_16_0,cmed_4_0,cmed_8_0,cmed_16_0,cste_4_0,cste_8_0,cste_16_0] = RunCoherenceAnalysis(0,c_data);
        
        cerror_bar_100 = [cste_4_100, cste_8_100, cste_16_100];
        cerror_bar_50 = [cste_4_50, cste_8_50, cste_16_50];
        cerror_bar_0 = [cste_4_0, cste_8_0, cste_16_0];
        
        cerror_bar_combined = [cerror_bar_100',cerror_bar_50',cerror_bar_0'];
        
        if whichplots2 == 1
            
            cavg_coh_plot_100 = [cavRT_4_100, cavRT_8_100, cavRT_16_100];
            cavg_coh_plot_50 = [cavRT_4_50, cavRT_8_50, cavRT_16_50];
            cavg_coh_plot_0 = [cavRT_4_0, cavRT_8_0, cavRT_16_0];
            
            cavg_coh_plot_combined =[cavg_coh_plot_100', cavg_coh_plot_50', cavg_coh_plot_0'];
            
            subplot(2,3,ii)
            errorbar(x2,cavg_coh_plot_combined,cerror_bar_combined);
            legend('100','50','0');
            title(strcat('block:',num2str(ii)));
            
            
        elseif whichplots2 == 2
            
            cmed_coh_plot_100 = [cmedRT_4_100, cmedRT_8_100, cmedRT_16_100];
            cmed_coh_plot_50 = [cmed_4_50, cmed_8_50, cmedRT_16_50];
            cmed_coh_plot_0 = [cmed_4_0, cmedRT_8_0, cmedRT_16_0];
            
            cmed_coh_plot_combined =[ cmed_coh_plot_100', cmed_coh_plot_50', cmed_coh_plot_0'];
            
            subplot(2,3,ii)
            errorbar(x2,cmed_coh_plot_combined,cerror_bar_combined);
            legend('100','50','0');
            title(strcat('block:',num2str(ii)));
        end
    end
elseif whichplots1 == 2
    
    sep_plot_ind = [];
    
    whichplots2 = input('Would you like to plot block averages(1) or medians(2)');
    
    figure;
    
    for ii = 1:5 % remember to adujst depending on how many blocks you actually want to test
        sep_plot_ind = [block_ind_total2{ii}'];
        
        s_data = data_d(sep_plot_ind,:);
        
        [savRT_4_100,savRT_8_100,savRT_16_100,smed_4_100,smed_8_100,smed_16_100,sste_4_100,sste_8_100,sste_16_100] = RunCoherenceAnalysis(1,s_data);
        [savRT_4_50,savRT_8_50,savRT_16_50,smed_4_50,smed_8_50,smed_16_50,sste_4_50,sste_8_50,sste_16_50] = RunCoherenceAnalysis(.5,s_data);
        [savRT_4_0,savRT_8_0,savRT_16_0,smed_4_0,smed_8_0,smed_16_0,sste_4_0,sste_8_0,sste_16_0] = RunCoherenceAnalysis(0,s_data);
        
        serror_bar_100 = [sste_4_100, sste_8_100, sste_16_100];
        serror_bar_50 = [sste_4_50, sste_8_50, sste_16_50];
        serror_bar_0 = [sste_4_0, sste_8_0, sste_16_0];
        
        serror_bar_combined = [serror_bar_100',serror_bar_50',serror_bar_0'];
        
        if whichplots2 == 1
            
            savg_coh_plot_100 = [savRT_4_100, savRT_8_100, savRT_16_100];
            savg_coh_plot_50 = [savRT_4_50, savRT_8_50, savRT_16_50];
            savg_coh_plot_0 = [savRT_4_0, savRT_8_0, savRT_16_0];
            
            savg_coh_plot_combined =[savg_coh_plot_100', savg_coh_plot_50', savg_coh_plot_0'];
            
            subplot(2,3,ii)
            errorbar(x2,savg_coh_plot_combined,serror_bar_combined);
            legend('100','50','0');
            title(strcat('block:',num2str(ii)));
            
            
        elseif whichplots2 == 2
            
            smed_coh_plot_100 = [smedRT_4_100, smedRT_8_100, smedRT_16_100];
            smed_coh_plot_50 = [smed_4_50, smed_8_50, smedRT_16_50];
            smed_coh_plot_0 = [smed_4_0, smedRT_8_0, smedRT_16_0];
            
            smed_coh_plot_combined =[ smed_coh_plot_100', smed_coh_plot_50', smed_coh_plot_0'];
            
            subplot(2,3,ii)
            errorbar(x2,smed_coh_plot_combined,serror_bar_combined);
            legend('100','50','0');
            title(strcat('block:',num2str(ii)));
        end
    end
    
    
end

whichplots3 = input('Would you like to see plots on distance to target (for 100% coherence)? (1) yes (2) no');

if whichplots3 == 1
    dist_ind = find(data(:,1) == 1); %finds all 100% coherence data
    rel_data = data(dist_ind,:); %excludes all other coherence data from set
    
    dist4_info = rel_data((find(rel_data(:,2) == 4)),:);
    dist8_info = rel_data((find(rel_data(:,2) == 8)),:);
    dist16_info = rel_data((find(rel_data(:,2) == 16)),:);
    
    %organize x and y data for scatter plot
    dist4RT = dist4_info(:,3);
    dist4MD = dist4_info(:,4);
    
    dist8RT = dist8_info(:,3);
    dist8MD = dist8_info(:,4);
    
    dist16RT = dist16_info(:,3);
    dist16MD = dist16_info(:,4);
    
    figure;
    scatter(dist4MD,dist4RT,'r','filled');
    hold on
    scatter(dist8MD,dist8RT,'g','filled');
    hold on
    scatter(dist16MD,dist16RT,'b','filled');
    
    legend('4','8','16');
    xlabel('Mean Distance from Target (pixels)')
    ylabel('Reaction Time (s)')
    
    pause;
end

whichplots4 = input('Would you like to see plots on distance from center to target? (1) yes (2) no');

if whichplots4 == 1
    whichplots5 = input('Which coherence level? (1) 100% (2) 50% (3) 0 %');
    if whichplots5 == 1
        dist_ind = find(data(:,1) == 1); %finds all 100% coherence data
        rel_data = data(dist_ind,:); %excludes all other coherence data from set
        
        dist4_info = rel_data((find(rel_data(:,2) == 4)),:);
        dist8_info = rel_data((find(rel_data(:,2) == 8)),:);
        dist16_info = rel_data((find(rel_data(:,2) == 16)),:);
        
        %organize x and y data for scatter plot
        dist4RT = dist4_info(:,3);
        dist4MD = dist4_info(:,7);
        
        dist8RT = dist8_info(:,3);
        dist8MD = dist8_info(:,7);
        
        dist16RT = dist16_info(:,3);
        dist16MD = dist16_info(:,7);
        
        figure;
        scatter(dist4MD,dist4RT,'r','filled');
        hold on
        scatter(dist8MD,dist8RT,'g','filled');
        hold on
        scatter(dist16MD,dist16RT,'b','filled');
        
        legend('4','8','16');
        xlabel('Mean Distance of Target from Center (pixels)')
        ylabel('Reaction Time (s)')
        
    elseif whichplots5 == 2
        dist_ind = find(data(:,1) == .5); %finds all 50% coherence data
        rel_data = data(dist_ind,:); %excludes all other coherence data from set
        
        dist4_info = rel_data((find(rel_data(:,2) == 4)),:);
        dist8_info = rel_data((find(rel_data(:,2) == 8)),:);
        dist16_info = rel_data((find(rel_data(:,2) == 16)),:);
        
        %organize x and y data for scatter plot
        dist4RT = dist4_info(:,3);
        dist4MD = dist4_info(:,7);
        
        dist8RT = dist8_info(:,3);
        dist8MD = dist8_info(:,7);
        
        dist16RT = dist16_info(:,3);
        dist16MD = dist16_info(:,7);
        
        figure;
        scatter(dist4MD,dist4RT,'r','filled');
        hold on
        scatter(dist8MD,dist8RT,'g','filled');
        hold on
        scatter(dist16MD,dist16RT,'b','filled');
        
        legend('4','8','16');
        xlabel('Mean Distance of Target from Center (pixels)')
        ylabel('Reaction Time (s)')
        
    elseif whichplots5 == 3 % gathers data for 0% coherence across distractors
        
        dist_ind = find(data(:,1) == 0); %finds all 100% coherence data
        rel_data = data(dist_ind,:); %excludes all other coherence data from set
        
        dist4_info = rel_data((find(rel_data(:,2) == 4)),:);
        dist8_info = rel_data((find(rel_data(:,2) == 8)),:);
        dist16_info = rel_data((find(rel_data(:,2) == 16)),:);
        
        %organize x and y data for scatter plot
        dist4RT = dist4_info(:,3);
        dist4MD = dist4_info(:,7);
        
        dist8RT = dist8_info(:,3);
        dist8MD = dist8_info(:,7);
        
        dist16RT = dist16_info(:,3);
        dist16MD = dist16_info(:,7);
        
        figure;
        scatter(dist4MD,dist4RT,'r','filled');
        hold on
        scatter(dist8MD,dist8RT,'g','filled');
        hold on
        scatter(dist16MD,dist16RT,'b','filled');
        
        legend('4','8','16');
        xlabel('Mean Distance of Target from Center (pixels)')
        ylabel('Reaction Time (s)')
    end          
end

    
    
    

    
    



