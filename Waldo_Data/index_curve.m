close all;
clear all;


%% data files:
block_index; % mat name = index


%% column ids:


%% parameters & conditions:

coherence = [0 0.5 1];
ndistractors = [2 4 8];
nsub = 36;


%% graphs:

figure(1); % index curves
a = 1; b = 1; 

for i = 1:15
    if(i~=1 && mod(i,3)==1)
        a=a+1;
        b=1;
    end
    meanBenefit(a, b) = mean(index(1:nsub,i));
    benefit_SEM(a, b) = std(index(1:nsub, i))/sqrt(nsub);
    b = b + 1;
end

for j=1:5
   errorbar(ndistractors, meanBenefit(j,:), benefit_SEM(j,:));
   hold on;
   p2=plot(ndistractors,meanBenefit(j,:)); 
   grid on;
end

leg_2 = legend( 'block1 error', 'block1','block2 error','block2','block3 error','block3','block4 error','block4','block5 error','block5' );
title(leg_2, 'Difference index');
title('Difference Index 100 % Curves: 5 blocks in absolute change');
xlabel('Number of Distractors');
ylabel('Average Response Time Difference (sec)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

