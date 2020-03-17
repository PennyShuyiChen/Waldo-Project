clear all;
close all;

%%

NOTICE3;
% column_ids 1-7:
id_subject = 1;
id_co0 = 2;
id_co5 = 3;
id_co1 = 4;
id_bi5 = 5;
id_bi1 = 6;
id_noticeUsed = 7;


%% conditions & parameters
coherence = [0 0.5 1];
bi_coherence = [0.5 1];
%ndistractors = [2 4 8];
nsub = 36;
whichGroup = id_noticeUsed;
dataFile = notice3;
%% --------------------------------------------------------------------------

co1 = 0;
co0 = 0;
co2 = 0;
for j=1:36
    if dataFile(j,whichGroup)==1
        co1 = co1 + 1;
        subMat1(co1, 1:3) = dataFile(j, 2:4);
    end 
    if dataFile(j,whichGroup)==0
        co0= co0+1;
        subMat0(co0, 1:3) = dataFile(j, 2:4);
    end
    if dataFile(j,whichGroup)==2 
        co1 = co1 + 1;
        subMat1(co1, 1:3) = dataFile(j, 2:4);
        
    end
    
end
%group average plots:


p = 1; q = 1;
for i = 1:3
    
    meanRT_sub0(p,q)= mean(subMat0(1:co0,i));
    condition_SEM_sub0(p,q) = std(subMat0(1:co0,i))/sqrt(co0);
    q = q+1;
end

c = 1; d = 1;
for i = 1:3
    
    meanRT_sub1(c,d)= mean(subMat1(1:co1,i));
    condition_SEM_sub1(c,d) = std(subMat1(1:co1,i))/sqrt(co1);
    d = d+1;
end

%c = 1; d = 1;
%for i = 1:3
    
    %meanRT_sub2(c,d)= mean(subMat2(1:co2,i));
    %condition_SEM_sub2(c,d) = std(subMat1(1:co2,i))/sqrt(co2);
    %d = d+1;
%end

for j = 1:3
    meanRT(1,j) = meanRT_sub0(1,j);
    meanSEM(1,j) = condition_SEM_sub0(1,j);
    meanRT(2,j) = meanRT_sub1(1,j);
    meanSEM(2,j) = condition_SEM_sub1(1,j);
    %meanRT(3,j) = meanRT_sub2(1,j);
    %meanSEM(3,j) = condition_SEM_sub2(1,j);
end



figure(1);

for j = 1:2
    errorbar(coherence,meanRT(j,:),meanSEM(j,:));
    hold on;
    p1=plot(coherence,meanRT(j,:));
    hold on;
    grid on;
end
leg_1 = legend('not noticed error bar','not noticed','noticed errobar','noticed');
title(leg_1, 'Notice / Not Noticed');
title('Group Average: Notice 2-group');
xlabel('Coherence Level');
ylabel('Average Response Time (sec)');
%--------------------------------------------------------------------------

%% benefit index curves
figure(2);
co1 = 0;
co0 = 0;
co2 = 0;

for j=1:36
    if dataFile(j,whichGroup)==1
        co1 = co1 + 1;
        subMat_in1(co1, 1:2) = dataFile(j, 5:6);
    end 
    if dataFile(j,whichGroup)==0
        co0= co0+1;
        subMat_in0(co0, 1:2) = dataFile(j, 5:6);
    end 
    if dataFile(j,whichGroup)==2
        co1 = co1 + 1;
        subMat_in2(co1, 1:2) = dataFile(j, 5:6);
    end
    
end

e = 1; f = 1;
for i = 1:2
    
    meanBenefit(e,f)= mean(subMat_in0(1:co0,i));
    benefit_SEM(e,f) = std(subMat_in0(1:co0,i))/sqrt(co0);
    f = f + 1;
end

a = 1; b = 1;
for i = 1:2
    
    meanBenefit(2,b)= mean(subMat_in1(1:co1,i));
    benefit_SEM(2,b) = std(subMat_in1(1:co1,i))/sqrt(co1);
    b = b + 1;
end

%n = 1; m = 1;
%for i = 1:2
   
    %meanBenefit(3,m)= mean(subMat_in2(1:co2,i));
    %benefit_SEM(3,m) = std(subMat_in2(1:co2,i))/sqrt(co2);
    %m = m + 1;
%end


for j=1:2
   errorbar(bi_coherence, meanBenefit(j,:), benefit_SEM(j,:));
   hold on;
   p4=plot(bi_coherence,meanBenefit(j,:));
   hold on;
   grid on;
end
leg_4n = legend('not noticed error bar','not noticed','noticed errobar','noticed');

title(leg_4n, 'Difference index');
title('Difference Index Curves: Notice / Not Noticed');
xlabel('Coherence Levels');
ylabel('Average Response Time Difference (sec)');
