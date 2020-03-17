function [ spaces ] = not_frontview( stim_x, id_x )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
spaces = [];
vector = randperm(id_x);

for ii = 1:length(vector)
    if vector(ii) ~= stim_x
       spaces = [spaces, vector(ii)];
    end
end