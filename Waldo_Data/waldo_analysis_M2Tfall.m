clear all;
close all;

M2T;


% conditions & parameters
coherence = [0 0.5 1];
ndistractors = [2 4 8];
nsub = 36;

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
    meanM2T(p,q)= mean(data_M2T(1:nsub,i));
    condition_SEM(p,q) = std(data_M2T(1:nsub,i))/sqrt(nsub);
    q = q+1;
end

figure(1);
for j = 1:3
    errorbar(ndistractors,meanM2T(j,:),condition_SEM(j,:));
    hold on;
    p1=plot(ndistractors,meanM2T(j,:)); 
    hold on;
    grid on;
end
leg_1 = legend('0% errobar','0% coherence','50% errobar','50% coherence', '100% errorbar', '100% coherence');
title(leg_1, 'Coherence Levels');
title('Group Average without Outliers');
xlabel('Number of Distractors');
ylabel('Mean Distance from Distractor to Target');
