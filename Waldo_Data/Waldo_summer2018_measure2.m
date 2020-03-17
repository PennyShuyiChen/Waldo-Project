close all;
clear all;


%% data files:
%measure2rt;
%measure2bi;
%measure2sd;
%measure2sdbi;
%measure3rt;
%measure3bi;
%measure3sd;
%measure3sdbi;
measure_percentage;
measure_percentage_sd;

%whichfile = measure2_RT; 
whichfiel_bi = measure_per;
%whichsd = measure2SD;
whichsd_bi = measure_persd;

%% conditions & parameters:
coherence = [0 0.5 1];
nblock = [1 2 3 4 5];
ndistractors = [2 4 8];
nrow = 3;
%% graphs:

p = 1;
q = 1;

%for i = 1:15
   % if (i~=1 && mod(i,5)==1)
     %   p = p+1;
     %   q = 1;
   % end
   
   % condition_SEM(p,q) =(whichsd(p,q)/sqrt(36));
    %q = q+1;
%end

%figure(1);
%subplot(2,1,1);
%for j = 1:3
    %errorbar(nblock,whichfile(j,:),condition_SEM(j,:));
    %hold on;
   % p1=plot(nblock,whichfile(j,:)); 
    %hold on;
    %grid on;
%end
%leg_1 = legend('2 dstractor errobar','2 distractor','4 distractor errobar','4 distractor', '8 distractor errorbar', '8 distractor');
%title(leg_1, 'distractor');
%title('Group Average without Outliers: ');
%xlabel('Number of the Blocks');
%ylabel('Average Response Time (sec)');



%subplot(2,1,2);
figure(1);
w = 1;
o = 1;

for i = 1:10
    if (i~=1 && mod(i,5)==1)
        w = w+1;
        o = 1;
      
    end
    
    
    
    %meanRT(p,q)= mean(whichfile(1:nsub,i));
    condition_SEM1(w,o) = whichsd_bi(w,o)/sqrt(36);
    o = o+1;
end


for j = 1:2
    errorbar(nblock,whichfiel_bi(j,:),condition_SEM1(j,:));
    hold on;
    p1=plot(nblock,whichfiel_bi(j,:)); 
    hold on;
    grid on;
end
leg_2 = legend('50% errobar','50% benefit index','100% errobar','100% benefit index');
title(leg_2, 'Coherence Levels');
title(' Benifit Index without Outliers: percentage');
xlabel('Number of the Blocks');
ylabel('Average Response Time (sec)');





