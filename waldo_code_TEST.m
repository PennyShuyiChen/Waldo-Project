%% Stroop effect task -> PennyShuyiChen03132020
% EXPERIMENT FILE 
% Check stroop data file - Waldo_Stroop_Data 
% neutral/baseline condition added 
        % EXPERIMENT CODE FILE 
        
clear all; close all;

%% --- basic settings 
 Screen('Preference', 'SkipSyncTests', 1);
rand('seed', sum(100 * clock));
  
plinearize      = 0; % 1 or 0. Doesn't matter for projector.  
blackout        = 0; % keep it to 0 
scalefactor     = 1.552; 
maxjitter       = 20;

Eye_Tracking    = 0; % 1: track the eyes / 0: no eye tracking
dummymode       = 0; % keep this to 0 the whole time 
keysetting      = -1; % -1 to query all keyboard devices 

%% save file parameters
 
subject_id = 'Stp'; % ID length < 8 Char; St0 and St1 data are already stored
 
data_file_name = strcat(subject_id,'_waldo_data.mat');
edfFile = strcat(subject_id,'.edf');
IsExist = exist(data_file_name, 'file');
 
if IsExist == 1
    error('data file name exists')
end
 
data_folder = strcat('Waldo_Stroop_Data');
if isdir(data_folder) == 0
    mkdir(data_folder);
end

 
%% --- screen settings
 
% detect screen & set which screen to draw
screens = Screen('Screens');
screenNumber = max(screens);
 
% define white, black, and gray indices
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
gray = white/2;
background = gray;
 
% open screen window 
screen_size = [];

Screen('Preference', 'SkipSyncTests', 1);
[w, rect] = Screen('OpenWindow',screenNumber,black,screen_size);

Screen('CloseAll');



rect





