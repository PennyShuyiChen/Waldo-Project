close all; clear all;

MDE_Analysis;

l = length(MDE_data);
q = [0.25 0.5 0.75]; % for quantile calculation

x = sort(MDE_data(:,4));
Y1 = quantile(x, q);

c1 = 1; c2 = 1; c3 = 1; c4=1;
for i = 1:l
    if MDE_data(i,4)< Y1(1)
       d1(c1,1:2) = MDE_data(i,3:4);
       c1 = c1 +1;
    end 
    if MDE_data(i,4)>= Y1(1)&& MDE_data(i,4)<Y1(2)
       d2(c2,1:2) = MDE_data(i,3:4);
       c2 = c2+1;
    end
    if MDE_data(i,4)>= Y1(2) && MDE_data(i,4)<Y1(3)
       d3(c3,1:2) = MDE_data(i,3:4);
       c3 = c3+1;
    end
    if MDE_data(i,4)>= Y1(3)
       d4(c4,1:2) = MDE_data(i,3:4);
       c4 = c4+1;
    end
end

mean1 = mean(d1);
mean2 = mean(d2);
mean3 = mean(d3);
mean4 = mean(d4);


%figure(1);
%poly = polyfit(d4(:,2),d4(:,1),1); %x and y
%yfit = poly(1)*d4(:,2)+poly(2);
%plot(d4(:,2), yfit,'m:');

%title('scatter plot for MDE');
%xlabel('Mean Distance');
%ylabel('RT');
%hold on;
%scatter(d4(:,2),d4(:,1));%

%ax = gca; % use current axes
%color = 'k'; % black
%linestyle = '-'; % solid lines
%grid on;
%line(get(ax,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);


        


        
        
        
%dis = MDE_data(:,1:4);
%figure(1);
%h = histogram(x);

% coherence conditions 
%count1 = 1;
%count2 = 1;
%count3 = 1;
%for i = 1:length(MDE_data)
   % if dis(i,1)== 0
      %  co0(count1,1) = x(i,1);
        
       % count1 = count1 + 1;
   % end
    %if dis(i,1)== 0.5
       % co5(count2,1) = x(i,1);
        
       % count2 = count2 + 1;
   % end
   % if dis(i,1)== 1
       % co10(count3,1) = x(i,1);
       % MDE_data1(count3,1)=MDE_data(i,4);
       % MDE_data2(count3,1)=MDE_data(i,3);
       % count3 = count3 + 1;
   % end
%end
%figure(2);
%h2 = histogram(co0);
%figure(3);
%h3 = histogram(co5);
%figure(4);
%h4 = histogram(co10);


% the scatter plot 
%figure(5);
%poly = polyfit(MDE_data1(:,1),MDE_data2(:,1),1); %x and y
%yfit = poly(1)*MDE_data1(:,1)+poly(2);
%plot(MDE_data1(:,1), yfit,'m:');

%title('scatter plot for MDE');
%xlabel('Mean Distance');
%ylabel('RT');
%hold on;
%scatter(MDE_data1(:,1),MDE_data2(:,1));

%ax = gca; % use current axes
%color = 'k'; % black
%linestyle = '-'; % solid lines
%grid on;
%line(get(ax,'XLim'), [0 0], 'Color', color, 'LineStyle', linestyle);
%legend('trendline', ' indivisual RT', 'x');




        
    