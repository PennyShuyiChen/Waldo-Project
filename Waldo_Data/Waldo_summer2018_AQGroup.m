clear all;
close all;

%% IDs:
Data_waldo;

% column_ids 1-24:
id_subject = 1;
id_accuracy = 2;
id_0cho2 = 3; id_0cho4 = 4; id_0cho8 = 5;
id_5cho2 = 6; id_5cho4 = 7; id_5cho8 = 8;
id_10cho2 = 9; id_10cho4 = 10; id_10cho8 = 11;
id_5bi2 = 12; id_5bi4 = 13; id_5bi8 = 14;
id_10bi2 = 15; id_10bi4 = 16; id_10bi8 = 17;
id_AQ = 18;

id_notice = 19; id_use = 20;
id_eye = 21;
id_featureFind = 22; id_positionMemo = 23; id_serialSear = 24;
id_noticeUsed = 25;
id_AQGrouping = 26;

%% conditions and parameters 
coherence = [0 0.5 1];
ndistractors = [2 4 8];
nsub = 36;
whichGroup = id_AQGrouping;

%% AQ grpahs:

% Grouping:
    % 0: Caucassions 
    % 1: Asians
    % 2: Black or African Americans 
    % 3: Hispanic or Latino
    % 4: No answer
count0 = 0;
count1 = 0;
count2 = 0;
count3 = 0;
count4 = 0;
countG = 0;

for i = 1:36
    if data_wo(i, whichGroup) == 0
        count0 = count0 + 1;
        subMat0(count0, 1:2) = data_wo(i, id_10bi8:id_AQ);
    end
    if data_wo(i, whichGroup) ~= 0 && data_wo(i, whichGroup)~= 4
        countG = countG + 1;
        subMatG(countG, 1:2) = data_wo(i, id_10bi8:id_AQ);
    end
    if data_wo(i, whichGroup) == 1
        count1 = count1 + 1;
        subMat1(count1, 1:2) = data_wo(i, id_10bi8:id_AQ);
    end
    if data_wo(i, whichGroup) == 2
        count2 = count2 + 1;
    end
    if data_wo(i, whichGroup) == 3
        count3 = count3 + 1;
    end
    if data_wo(i, whichGroup) == 4
        count4 = count4 + 1;
    end
end        
    
% x-AQ score, y-benedit index at 100%-8
figure(1);

subplot(3,1,1);
poly = polyfit(subMat0(1:count0,2),subMat0(1:count0,1),1);
yfit = poly(1)*subMat0(1:count0,2)+poly(2);
plot(subMat0(1:count0,2), yfit,'m:');

title('Correlation with AQ caucasian');
xlabel('AQ Score');
ylabel('RT difference (0-100% coherence) at 8 distractors');
hold on;
scatter(subMat0(1:count0,2),subMat0(1:count0,1));

ax = gca; % use current axes
color = 'k'; % black
linestyle = '-'; % solid lines
grid on;
line(get(ax,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
legend('trendline', 'individual AQ-benefit index', 'x');


subplot(3,1,2);
polyG = polyfit(subMatG(1:countG,2),subMatG(1:countG,1),1);
yfitG = polyG(1)*subMatG(1:countG,2)+polyG(2);
plot(subMatG(1:countG,2), yfitG,'m:');

title('Correlation with AQ OtherAll');
xlabel('AQ Score');
ylabel('RT difference (0-100% coherence) at 8 distractors');
hold on;
scatter(subMatG(1:countG,2),subMatG(1:countG,1));

ax = gca; % use current axes
color = 'k'; % black
linestyle = '-'; % solid lines
grid on;
line(get(ax,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
legend('trendline', 'individual AQ-benefit index', 'x');


subplot(3,1,3);
poly1 = polyfit(subMat1(1:count1,2),subMat1(1:count1,1),1);
yfit1 = poly1(1)*subMat1(1:count1,2)+poly1(2);
plot(subMat1(1:count1,2), yfit1,'m:');

title('Correlation with AQ Asian only');
xlabel('AQ Score');
ylabel('RT difference (0-100% coherence) at 8 distractors');
hold on;
scatter(subMat1(1:count1,2),subMat1(1:count1,1));

ax = gca; % use current axes
color = 'k'; % black
linestyle = '-'; % solid lines
grid on;
line(get(ax,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
legend('trendline', 'individual AQ-benefit index', 'x');




