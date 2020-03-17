function [av4,av8,av16,med4,med8,med16,ste4,ste8,ste16] = RunCoherenceAnalysis(coherence,data)
%Takes as input a coherence level (0,.5 or 1) and a *cleaned data set and
%runs a set of analyses. It will output average RTs, median RTs and
%Standard errors for every level of distractor in that order. When using
%this function it is recomended to assign names to all six output variables
%to keep track of. 
% 
index = find(data(:,1) == coherence); %should be 90 numbers
coh = data(index,:);

dist4_x = coh((find(coh(:,2) == 4)),:);
dist8_x = coh((find(coh(:,2) == 8)),:);
dist16_x= coh((find(coh(:,2) == 16)),:);

dist4 = RemoveOutliers(dist4_x(:,3));
dist8 = RemoveOutliers(dist8_x(:,3));
dist16 = RemoveOutliers(dist16_x(:,3));

av4 = mean(dist4);
av8 = mean(dist8);
av16 = mean(dist16);

med4 = median(dist4);
med8 = median(dist8);
med16 = median(dist16);

ste4 = std(dist4) / sqrt(length(dist4));
ste8 = std(dist8) / sqrt(length(dist8));
ste16 = std(dist16) / sqrt(length(dist16));

end

