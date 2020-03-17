% created by PSC: 2018 summer for original exp
clear all;
close all;

%Data_waldo;
%Data_waldo_full;
Data_pilot;
Data_in_pilot;

% column_ids 1-24:
id_subject = 1;
id_accuracy = 2;

id_0cho2 = 3; id_0cho4 = 4; id_0cho8 = 5; % conditions 
id_5cho2 = 6; id_5cho4 = 7; id_5cho8 = 8;
id_10cho2 = 9; id_10cho4 = 10; id_10cho8 = 11; 

id_5bi2 = 12; id_5bi4 = 13; id_5bi8 = 14; % benefit 
id_10bi2 = 15; id_10bi4 = 16; id_10bi8 = 17;

id_AQ = 18;
id_notice = 19; id_use = 20; % sub-groups
id_eye = 21;
id_featureFind = 22; id_positionMemo = 23; id_serialSear = 24;

% conditions & parameters
coherence = [0 0.5 1];
ndistractors = [2 4 8];
nsub = 3;

 %plot(data_full(1:36,1),data_full(1:36,2)) % accuracy check 
%aveAccuracy = mean(data_wo(1:nsub,id_accuracy));


%group average plots:
p=1;
q=1;
for i = 1:9
    if (i~=1 && mod(i,3)==1)
        p = p+1;
        q = 1;
    end
    meanRT(p,q)= mean(data_p(1:nsub,i));
    condition_SEM(p,q) = std(data_p(1:nsub,i))/sqrt(nsub);
    q = q+1;
end

figure(1);
for j = 1:3
    errorbar(ndistractors,meanRT(j,:),condition_SEM(j,:));
    hold on;
    p1=plot(ndistractors,meanRT(j,:)); 
    hold on;
    grid on;
end
leg_1 = legend('0% errobar','0% coherence','50% errobar','50% coherence', '100% errorbar', '100% coherence');
title(leg_1, 'Coherence Levels');
title('Group Average without Outliers');
xlabel('Number of Distractors');
ylabel('Average Response Time (sec)');


% benefit index curves
a = 1; b = 1; 

% for i = id_5bi2:id_10bi8
%     if(i~=id_5bi2 && mod(i,3)==0)
%         a=a+1;
%         b=1;
%     end
%     meanBenefit(a, b) = mean(data_p(1:nsub,i));
%     benefit_SEM(a, b) = std(data_p(1:nsub, i))/sqrt(nsub);
%     b = b + 1;
% end

for i = 1:6
    if(i~=1 && mod(i,3)==1)
        a=a+1;
        b=1;
    end
    meanBenefit(a, b) = mean(index_p(1:nsub,i));
    benefit_SEM(a, b) = std(index_p(1:nsub, i))/sqrt(nsub);
    b = b + 1;
end

figure(2);
for j=1:2
   errorbar(ndistractors, meanBenefit(j,:), benefit_SEM(j,:));
   hold on;
   p2=plot(ndistractors,meanBenefit(j,:)); 
  % hold on;
   grid on;
end
leg_2 = legend( '50% errorbar', '50% coherence benefit', '100% errorbar', '100% coherence benefit');

title(leg_2, 'Difference index');
title('Difference Index Curves');
xlabel('Number of Distractors');
ylabel('Average Response Time Difference (sec)');




% x-AQ score, y-benedit index at 100%-8
% figure(4);
% poly = polyfit(data_full(1:nsub,id_AQ),data_full(1:nsub,id_10bi8),1);
% yfit = poly(1)*data_full(1:nsub,id_AQ)+poly(2);
% plot(data_full(1:nsub,id_AQ), yfit,'m:');

% title('Correlation with AQ');
% xlabel('AQ Score');
% ylabel('RT difference (0-100% coherence) at 8 distractors');
% hold on;
% scatter(data_full(1:nsub,id_AQ),data_full(1:nsub,id_10bi8));
% 
% ax = gca; % use current axes
% color = 'k'; % black
% linestyle = '-'; % solid lines
% grid on;
% line(get(ax,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
% legend('trendline', 'individual AQ-benefit index', 'x');
% 
% 
% 
% % Individual variability in benefits
% figure(3);
% 
% poly1 = polyfit(data_full(1:nsub,id_10bi8),data_full(1:nsub,id_5bi8),1);
% yyfit = poly1(1)*data_full(1:nsub,id_10bi8)+poly1(2);
% plot(data_full(1:nsub,id_10bi8),yyfit,'r:')
% title('Individual differences in benefit at 8 distractors 20 participants');
% xlabel('RT difference (0%-100% coherence) at 8 distractors');
% ylabel('RT difference (0%-50% coherence) at 8 distractors');
% hold on;
% scatter(data_full(1:nsub,id_10bi8),data_full(1:nsub,id_5bi8));
% 
% axh = gca; % use current axes
% color = 'k'; % black
% linestyleh = '-'; % solid lines 
% grid on;
% line(get(axh,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyleh);
% line([0 0], get(axh,'YLim'), 'Color', color, 'LineStyle', linestyleh);
% 
% legend('trendline', 'individual benefit index', 'x', 'y');

 




