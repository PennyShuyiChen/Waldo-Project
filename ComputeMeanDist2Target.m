function [ dist ] = ComputeMeanDist2Target(coordD,coordT )
%Takes the rect coordinates of distractors (coorD) and averages their
%euclidean distance to the target coordT
%   Detailed explanation goes here
midpointsx = [];
midpointsy = [];
[target_x, target_y] = RectCenter(coordT); 

for ii = 1:size(coordD,1)
    [midpointsx(ii), midpointsy(ii)] = RectCenter(coordD(ii,:));
end

distances = [];

for jj = 1:size(coordD,1)
    distances(jj) = sqrt((midpointsx(jj)-target_x)^2 +(midpointsy(jj)-target_y)^2);
end

dist = mean(distances);

end

