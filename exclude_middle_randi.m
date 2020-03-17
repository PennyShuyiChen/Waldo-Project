function [ rand_num ] = exclude_middle_randi( stim_param, face_param )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
num = randi(face_param);

while num == stim_param
    num = randi(face_param);
end

rand_num = num;
end

