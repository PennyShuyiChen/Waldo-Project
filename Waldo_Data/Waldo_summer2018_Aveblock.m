clear all;
close all;

%% Data_waldo;
block1_data;
%block2_data;
%block3_data;
%block4_data;
%block5_data;

%% column_ids 1-16:
id_subject = 1;

id_0cho2 = 2; id_0cho4 = 3; id_0cho8 = 4; % conditions 
id_5cho2 = 5; id_5cho4 = 6; id_5cho8 = 7;
id_10cho2 = 8; id_10cho4 = 9; id_10cho8 = 10; 

id_5bi2 = 11; id_5bi4 = 12; id_5bi8 = 13; % benefit 
id_10bi2 = 14; id_10bi4 = 15; id_10bi8 = 16;

%% conditions & parameters
coherence = [0 0.5 1];
ndistractors = [2 4 8];
nsub = 36;
whichblock = block1; 

%% group average plots:
p=1;
q=1;
for i = id_0cho2:id_10cho8
    if (i~=id_0cho2 && mod(i,3)==2)
        p = p+1;
        q = 1;
    end
    meanRT(p,q)= mean(whichblock(1:nsub,i));
    condition_SEM(p,q) = std(whichblock(1:nsub,i))/sqrt(nsub);
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
title('Group Average without Outliers: Block 1');
xlabel('Number of Distractors');
ylabel('Average Response Time (sec)');


%% benefit index curves
a = 1; b = 1; 

for i = id_5bi2:id_10bi8
    if(i~=id_5bi2 && mod(i,3)==2)
        a=a+1;
        b=1;
    end
    meanBenefit(a, b) = mean(whichblock(1:nsub,i));
    benefit_SEM(a, b) = std(whichblock(1:nsub, i))/sqrt(nsub);
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
title('Difference Index Curves: Block 1');
xlabel('Number of Distractors');
ylabel('Average Response Time Difference (sec)');

