function [ spaces ] = generate_spaces( grid, target )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
spaces = [];
vector = randperm(grid);

for ii = 1:length(vector)
    if vector(ii) ~= target
       spaces = [spaces, vector(ii)];
    end
end

