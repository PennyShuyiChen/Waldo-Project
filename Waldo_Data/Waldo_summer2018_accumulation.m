close all;
clear all;


%% data files:
block_accumulation; % file name: accumulation 


%% column ids:


%% parameters & conditions:

coherence = [0 0.5 1];
ndistractors = [2 4 8];
nsub = 36;
whichblock = 1;


%% graphs:

figure(1); % block accumulation graphs
subplot(2,1,1);
p=1;
q=1;
for i = 61:69
    if (i~=61 && mod(i,3)==1)
        p = p+1;
        q = 1;
    end
    meanRT(p,q)= mean(accumulation(1:nsub,i));
    condition_SEM(p,q) = std(accumulation(1:nsub,i))/sqrt(nsub);
    q = q+1;
end

for j = 1:3
    errorbar(ndistractors,meanRT(j,:),condition_SEM(j,:));
    hold on;
    p1=plot(ndistractors,meanRT(j,:)); 
    axis([2 8 1.5 4.5]);
    hold on;
    grid on;
end
leg_1 = legend('0% errobar','0% coherence','50% errobar','50% coherence', '100% errorbar', '100% coherence');
title(leg_1, 'Coherence Levels');
title('Group Average without Outliers: block accumulation 5');
xlabel('Number of Distractors');
ylabel('Average Response Time (sec)');
           

subplot(2,1,2);
a = 1; b = 1; 

for i = 70:75
    if(i~=70 && mod(i,3)==1)
        a=a+1;
        b=1;
    end
    meanBenefit(a, b) = mean(accumulation(1:nsub,i));
    benefit_SEM(a, b) = std(accumulation(1:nsub, i))/sqrt(nsub);
    b = b + 1;
end

for j=1:2
   errorbar(ndistractors, meanBenefit(j,:), benefit_SEM(j,:));
   hold on;
   p2=plot(ndistractors,meanBenefit(j,:)); 
  axis([2 8 -0.1 0.6]);
   grid on;
end

leg_2 = legend( '50% errorbar', '50% coherence benefit', '100% errorbar', '100% coherence benefit');
title(leg_2, 'Difference index');
title('Difference Index Curves: block accumulation 5');
xlabel('Number of Distractors');
ylabel('Average Response Time Difference (sec)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

