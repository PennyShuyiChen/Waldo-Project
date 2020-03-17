clear all;
close all;


%% data files 
%measure_all;
%measure_all2;
measure_all3;



whichfile = measureAll_3;


%% column ids
% RT ids:
id_subject = 1; id_co0b1 = 2; id_co0b2 = 3;  id_co0b3 = 4; id_co0b4 = 5;
id_co0b5 = 6;  id_co5b1 = 7;  id_co5b2 = 8;  id_co5b3 = 9; id_co5b4 = 10;
id_co5b5 = 11; id_co1b1 = 12; id_co1b2 = 13; id_co1b3 = 14;
id_co1b4 = 15; id_co1b5 = 16;
% Index ids:
id_bi5b1 = 17; id_bi5b2 = 18; id_bi5b3 = 19; id_bi5b4 = 20; id_bi5b5 = 21;
id_bi1b1 = 22; id_bi1b2 = 23; id_bi1b3 = 24; id_bi1b4 = 25; id_bi1b5 = 26;

%% conditions & parameters
coherence = [0 0.5 1];
nblock = [1 2 3 4 5];
ndistractors = [2 4 8];
nsub = 36;

%% the average plots

p=1;
q=1;
for i = id_co0b1:id_co1b5
    if (i~=id_co0b1 && mod(i,5)==2)
        p = p+1;
        q = 1;
    end
    meanRT(p,q)= mean(whichfile(1:nsub,i));
    condition_SEM(p,q) = std(whichfile(1:nsub,i))/sqrt(nsub);
    q = q+1;
end

figure(1);
for j = 1:3
    errorbar(nblock,meanRT(j,:),condition_SEM(j,:));
    hold on;
    p1=plot(nblock,meanRT(j,:)); 
    hold on;
    grid on;
end
leg_1 = legend('0% errobar','0% coherence','50% errobar','50% coherence', '100% errorbar', '100% coherence');
title(leg_1, 'Coherence Levels');
title('Group Average without Outliers: 8 distractors');
xlabel('Number of the Blocks');
ylabel('Average Response Time (sec)');


%% benefit index


a = 1; b = 1; 

for i = id_bi5b1:id_bi1b5
    if(i~=id_bi5b1 && mod(i,5)==2)
        a=a+1;
        b=1;
    end
    meanBenefit(a, b) = mean(whichfile(1:nsub,i));
    benefit_SEM(a, b) = std(whichfile(1:nsub, i))/sqrt(nsub);
    b = b + 1;
end

figure(2);
for j=1:2
   errorbar(nblock, meanBenefit(j,:), benefit_SEM(j,:));
   hold on;
   p2=plot(nblock,meanBenefit(j,:)); 
  % hold on;
   grid on;
end
leg_2 = legend( '50% errorbar', '50% coherence benefit', '100% errorbar', '100% coherence benefit');

title(leg_2, 'Difference index');
title('Difference Index Curves: 8 distractors');
xlabel('Number of the Blocks');
ylabel('Average Response Time Difference (sec)');








