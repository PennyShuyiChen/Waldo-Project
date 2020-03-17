clear all;
close all;

%%

Data_waldo;
%Data_waldo_full;

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


%% conditions & parameters
coherence = [0 0.5 1];
ndistractors = [2 4 8];
nsub = 36;
whichGroup = id_noticeUsed;

% plot(data_full(1:36,1),data_full(1:36,2)) % accuracy check
aveAccuracy = mean(data_wo(1:nsub,id_accuracy));
%% --------------------------------------------------------------------------

co1 = 0;
co0 = 0;
co2 = 0;
for j=1:36
    if data_wo(j,whichGroup)==1
        co1 = co1 + 1;
        subMat1(co1, 1:9) = data_wo(j, 3:11);
    end 
    if data_wo(j,whichGroup)==0
        co0= co0+1;
        subMat0(co0, 1:9) = data_wo(j, 3:11);
    end
    if data_wo(j,whichGroup)==2 
        co2 = co2 + 1;
        subMat2(co2, 1:9) = data_wo(j, 3:11);
        
    end
    
end
%group average plots:


p = 1; q = 1;
for i = 1:9
    if (mod(i,3)==1 && i~=1)
        p = p+1;
        q = 1;
    end
    meanRT_sub0(p,q)= mean(subMat0(1:co0,i));
    condition_SEM_sub0(p,q) = std(subMat0(1:co0,i))/sqrt(co0);
    q = q+1;
end

c = 1; d = 1;
for i = 1:9
    if (mod(i,3)==1 && i~=1)
        c = c+1;
        d = 1;
    end
    meanRT_sub1(c,d)= mean(subMat1(1:co1,i));
    condition_SEM_sub1(c,d) = std(subMat1(1:co1,i))/sqrt(co1);
    d = d+1;
end

c = 1; d = 1;
for i = 1:9
    if (mod(i,3)==1 && i~=1)
        c = c+1;
        d = 1;
    end
    meanRT_sub2(c,d)= mean(subMat2(1:co2,i));
    condition_SEM_sub2(c,d) = std(subMat1(1:co2,i))/sqrt(co2);
    d = d+1;
end

figure(1);
subplot(3,1,1);
for j = 1:3
    errorbar(ndistractors,meanRT_sub0(j,:),condition_SEM_sub0(j,:));
    hold on;
    p1=plot(ndistractors,meanRT_sub0(j,:));
    hold on;
    grid on;
end
leg_1 = legend('0% errobar','0% coherence','50% errobar','50% coherence', '100% errorbar', '100% coherence');
title(leg_1, 'Coherence Levels');
title('Group Average: Not noticed & Not used');
xlabel('Number of Distractors');
ylabel('Average Response Time (sec)');

subplot(3,1,2);
for j = 1:3
    errorbar(ndistractors,meanRT_sub1(j,:),condition_SEM_sub1(j,:));
    hold on;
    p2=plot(ndistractors,meanRT_sub1(j,:));
    hold on;
    grid on;
end
leg_2 = legend('0% errobar','0% coherence','50% errobar','50% coherence', '100% errorbar', '100% coherence');
title(leg_2, 'Coherence Levels');
title('Group Average: Noticed & Used');
xlabel('Number of Distractors');
ylabel('Average Response Time (sec)');

subplot(3,1,3);
for j = 1:3
    errorbar(ndistractors,meanRT_sub2(j,:),condition_SEM_sub2(j,:));
    hold on;
    p3n=plot(ndistractors,meanRT_sub2(j,:));
    hold on;
    grid on;
end
leg_3n = legend('0% errobar','0% coherence','50% errobar','50% coherence', '100% errorbar', '100% coherence');
title(leg_3n, 'Coherence Levels');
title('Group Average: Noticed, Not used');
xlabel('Number of Distractors');
ylabel('Average Response Time (sec)');

%--------------------------------------------------------------------------

%% benefit index curves

co1 = 0;
co0 = 0;
co2 = 0;

for j=1:36
    if data_wo(j,whichGroup)==1
        co1 = co1 + 1;
        subMat_in1(co1, 1:6) = data_wo(j, 12:17);
    end 
    if data_wo(j,whichGroup)==0
        co0= co0+1;
        subMat_in0(co0, 1:6) = data_wo(j, 12:17);
    end 
    if data_wo(j,whichGroup)==2
        co2 = co2 + 1;
        subMat_in2(co2, 1:6) = data_wo(j, 12:17);
    end
    
end

e = 1; f = 1;
for i = 1:6
    if(mod(i,3)==1 && i~=1)
        e=e+1;
        f=1;
    end
    meanBenefit_sub0(e,f)= mean(subMat_in0(1:co0,i));
    benefit_SEM_sub0(e,f) = std(subMat_in0(1:co0,i))/sqrt(co0);
    f = f + 1;
end

figure(2);
subplot(3,1,1);
for j=1:2
    errorbar(ndistractors, meanBenefit_sub0(j,:), benefit_SEM_sub0(j,:));
    hold on;
    p3=plot(ndistractors,meanBenefit_sub0(j,:));
    hold on;
    grid on;
end
leg_3 = legend( '50% errorbar', '50% coherence benefit', '100% errorbar', '100% coherence benefit');

title(leg_3, 'Difference index');
title('Difference Index Curves: Not Noticed & Not Used');
xlabel('Number of Distractors');
ylabel('Average Response Time Difference (sec)');

a = 1; b = 1;
for i = 1:6
    if(mod(i,3)==1 && i~=1)
        a=a+1;
        b=1;
    end
    meanBenefit_sub1(a,b)= mean(subMat_in1(1:co1,i));
    benefit_SEM_sub1(a,b) = std(subMat_in1(1:co1,i))/sqrt(co1);
    b = b + 1;
end

subplot(3,1,2);
for j=1:2
    errorbar(ndistractors, meanBenefit_sub1(j,:), benefit_SEM_sub1(j,:));
    hold on;
    p4=plot(ndistractors,meanBenefit_sub1(j,:));
    hold on;
    grid on;
end
leg_4 = legend( '50% errorbar', '50% coherence benefit', '100% errorbar', '100% coherence benefit');

title(leg_4, 'Difference index');
title('Difference Index Curves: Noticed & Used');
xlabel('Number of Distractors');
ylabel('Average Response Time Difference (sec)');


n = 1; m = 1;
for i = 1:6
    if(mod(i,3)==1 && i~=1)
        n=n+1;
        m=1;
    end
    meanBenefit_sub2(n,m)= mean(subMat_in2(1:co2,i));
    benefit_SEM_sub2(n,m) = std(subMat_in2(1:co2,i))/sqrt(co2);
    m = m + 1;
end

subplot(3,1,3);
for j=1:2
   errorbar(ndistractors, meanBenefit_sub2(j,:), benefit_SEM_sub2(j,:));
   hold on;
   p4=plot(ndistractors,meanBenefit_sub2(j,:));
    hold on;
    grid on;
end
leg_4n = legend( '50% errorbar', '50% coherence benefit', '100% errorbar', '100% coherence benefit');

title(leg_4n, 'Difference index');
title('Difference Index Curves: Noticed, Not used');
xlabel('Number of Distractors');
ylabel('Average Response Time Difference (sec)');

%--------------------------------------------------------------------------


%% x-AQ score, y-benedit index at 100%-8
co1 = 0;
co00 = 0;
for j=1:36
    if data_wo(j,whichGroup)==1
        co1 = co1 + 1;
        subAQ1(co1, :) = data_wo(j, id_AQ);
        subBI1(co1, :) = data_wo(j, id_10bi8);
    else
        co00= co00+1;
        subAQ0(co00, :) = data_wo(j, id_AQ);
        subBI0(co00, :) = data_wo(j, id_10bi8);
    end
    
end
figure(4);
subplot(2,1,1);

poly = polyfit(subAQ0(1:co00, :),subBI0(1:co00, :),1);
yfit = poly(1)*subAQ0(1:co00 , :)+poly(2);
plot(subAQ0(1:co00, :), yfit,'m:');

title('Correlation with AQ: No Search Pattern');
xlabel('AQ Score');
ylabel('RT difference (0-100% coherence) at 8 distractors');
hold on;
scatter(subAQ0(1:co00, :),subBI0(1:co00, :));

ax = gca; % use current axes
color = 'k'; % black
linestyle = '-'; % solid lines
grid on;
line(get(ax,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
legend('trendline', 'individual AQ-benefit index', 'x');
subplot(2,1,2);
poly1 = polyfit(subAQ1(1:co1, :),subBI1(1:co1, :),1);
yfit1 = poly1(1)*subAQ1(1:co1, :)+poly1(2);
plot(subAQ1(1:co1, :), yfit1,'m:');

title('Correlation with AQ: Search Pattern');
xlabel('AQ Score');
ylabel('RT difference (0-100% coherence) at 8 distractors');
hold on;
scatter(subAQ1(1:co1, :),subBI1(1:co1, :));


ax = gca; % use current axes
color = 'k'; % black
linestyle = '-'; % solid lines
grid on;
line(get(ax,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
legend('trendline', 'individual AQ-benefit index', 'x');

%--------------------------------------------------------------------------
%% Individual variability in benefits
co1 = 0;
co00 = 0;
for j=1:36
    if data_wo(j,whichGroup)==1
        co1 = co1 + 1;
        
        subBeIn1(co1, :) = data_wo(j, id_5bi8);
    else
        co00= co00+1;
        
        subBeIn0(co00, :) = data_wo(j, id_5bi8);
    end
    
end

figure(3);
subplot(2,1,1);
poly2 = polyfit(subBI0(1:co00, :),subBeIn0(1:co00, :),1);
yyfit = poly2(1)*subBI0(1:co00, :)+poly2(2);
plot(subBI0(1:co00, :),yyfit,'r:');
title('Individual differences in benefit at 8 distractors: No Search Pattern');
xlabel('RT difference (0%-100% coherence) at 8 distractors');
ylabel('RT difference (0%-50% coherence) at 8 distractors');
hold on;
scatter(subBI0(1:co00, :),subBeIn0(1:co00, :));

axh = gca; % use current axes
color = 'k'; % black
linestyleh = '-'; % solid lines
grid on;
line(get(axh,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyleh);
line([0 0], get(axh,'YLim'), 'Color', color, 'LineStyle', linestyleh);

legend('trendline', 'individual benefit index', 'x', 'y');

subplot(2,1,2);
poly3 = polyfit(subBI1(1:co1, :),subBeIn1(1:co1, :),1);
yyfit1 = poly3(1)*subBI1(1:co1, :)+poly3(2);
plot(subBI1(1:co1, :),yyfit1,'r:');
title('Individual differences in benefit at 8 distractors: Search Pattern');
xlabel('RT difference (0%-100% coherence) at 8 distractors');
ylabel('RT difference (0%-50% coherence) at 8 distractors');
hold on;
scatter(subBI1(1:co1, :),subBeIn1(1:co1, :));

axh = gca; % use current axes
color = 'k'; % black
linestyleh = '-'; % solid lines
grid on;
line(get(axh,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyleh);
line([0 0], get(axh,'YLim'), 'Color', color, 'LineStyle', linestyleh);

legend('trendline', 'individual benefit index', 'x', 'y');



