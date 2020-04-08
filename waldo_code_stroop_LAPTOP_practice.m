%% Stroop effect task -> PennyShuyiChen03252020
% EXPERIMENT FILE 
% Check stroop data file - Waldo_Stroop_Data 
% Only 30 trials 
        % PRACTICE CODE FILE 
        
clear all; close all;

%% --- basic settings 
 
rand('seed', sum(100 * clock));
  
plinearize      = 0; % 1 or 0. Doesn't matter for projector.  
blackout        = 0; % keep it to 0 
scalefactor     = 1.4214; % for a LAPTOP at 18in viewing distance. This is 2x the keyboard section of the laptop
maxjitter       = 20;

Eye_Tracking    = 0; % 1: track the eyes / 0: no eye tracking
dummymode       = 0; % keep this to 0 the whole time 
keysetting      = -1; % -1 to query all keyboard devices 

%% save file parameters
 
subject_id = 'shu'; % ID length < 8 Char; St0 and St1 data are already stored 
 
data_file_name = strcat(subject_id,'_practice_data.mat');
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
oldVisualDebugLevel = Screen('Preference', 'VisualDebugLevel', 3);
oldSupressAllWarnings = Screen('Preference', 'SuppressAllWarnings', 1);
 

% linearize
if plinearize
    screen_clut = [linspace(0,1,256)' linspace(0,1,256)' linspace(0,1,256)'];
    Screen('LoadNormalizedGammaTable',ScreenNumber,screen_clut);
end

 
% find center of the screen 
[cx,cy] = RectCenter(rect);
 
% fill screens 
Screen('FillRect',w, background); 
Screen('Flip', w);
 
% black out the control screen 
if blackout 
    if size(screens,2) == 2
        w2=Screen('OpenWindow',0,0,[],[],2);
        Screen('FillRect',w2, 0); 
        Screen('Flip', w2);
    end
end
    
%% The Experiment Design
% inside the 5x5 grid, the nine faces are arranged into an arrow pointing
% towards L/R; condition congruent, incongruent -> congruence 

% stimulus grid:
% The arrow is taken from a 5*5 grid; row (all) = 3; col = 1/2-L, 4/5-R 
stimgrid_row = 5; % the arrow is taken from a 5*5 grid
stimgrid_col = 5; % PSC  

id_col = 5; 
id_row = 5;

%congruency
congruence  = [0 1 2]; % PSC congruence: 0-> incongruent, 1-> congruent, 2-> baseline neutral

% global direction 
g_pattern = [1 5]; % PSC 1-> L; 5->R; 

% faces on the screen                          
nFaces = 9; % -> nfaces -> change after testing PSC 
 
% conditions and trials
nrepeat = 5; % PSC -> even number   
 
% make emat ->PSC add local direction 
emat = expmat(congruence, g_pattern);
for i = 1:length(emat)
    if emat(i,1)==0
        if emat(i,2)==1
            emat(i,3)=5;
        else 
            emat(i,3)=1;
        end
    elseif emat(i,1)==1
        emat(i,3)=emat(i,2);
    elseif emat(i,1)==2
        emat(i,3) = 3;
    end
end

emat = repmat(emat,nrepeat,1);
 
% randomize sequence & saveindex-> from the emat 
nblocks = 1; % PSC   
ntrialsblock = (nrepeat * length(congruence) * length(g_pattern))/nblocks; % PSC
block_divider = ntrialsblock; % updated by WP

[eseq, emat] = randseq(emat, ntrialsblock);
 
[ex,ey] = size(emat);
saveindex = ey + 1;
 
total_trials = length(emat);
 
data_cell = num2cell(emat);
 

%% --- set durations (secs)
dur_target = 1; 
dur_blank = 0.5; 
dur_fix = 0.5;
breakdur = 30;

%% -- stimulus settings
 
imSize = 120; % pixels
scaledRect = [0 0 imSize imSize];

%% -- load images + coordinates + indices
 
dimx = (stimgrid_col - 1)/2 ;
dimy = (stimgrid_row - 1)/2 ;
[gx, gy] = meshgrid(-dimx:1:dimx, -dimy:1:dimy);
 
screenYpixels = 600; % 
pixelScale = screenYpixels / (dimy * 2 + 2);
gx = gx .* pixelScale + cx; %x coordinates of places on screen
gy = gy .* pixelScale + cy; % same but for y
 
tgx = gx+4; % cartesian coordinates for x target position
tgy = gy+3; % cartesian coordinates for y target position

load('IdArray_small.mat'); %% IMPORTANT: loads data as cell array called IdArray
place_L_slots = [3,7,8,9,11,13,15,18,23]; % create the 5*5 grid 
place_L(:,1) = [3,2,3,4,1,3,5,3,3];
place_L(:,2) = [1,2,2,2,3,3,3,4,5];

place_R_slots = [3,8,11,13,15,17,18,19,23];
place_R(:,1) = [3,3,1,3,5,2,3,4,3];
place_R(:,2) = [1,2,3,3,3,4,4,4,5];
 
all_slots = 1:(id_col*id_row);
all_slots = reshape(all_slots, id_col,id_row);
 
specs = size(IdArray);
InitializePsychSound;
pahandle = PsychPortAudio('Open');
load('chime.mat');
chime(:,2) = chime;

%% --- initialize eye tracking

max_duration = 20;
max_time_step = round(250*max_duration);

if Eye_Tracking == 1
    el = EyelinkInitDefaults(w);
    if ~EyelinkInit(dummymode, 1)
        fprintf('Eyelink Init aborted.\n');
        cleanup;  % cleanup function
        return;
    end
    % open file
    Eyelink('Openfile',edfFile);
    % make sure that we get gaze data from the Eyelink
    Eyelink('command', 'link_sample_data = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS');
    % calibrate
    EyelinkDoTrackerSetup(el);
    % get eye that's tracked
    eye_used = Eyelink('EyeAvailable'); % get eye that's tracked

end

%% --- experiment 
 
textsize = 20;
Screen('TextSize',w,textsize);
welcometext = [int2str(total_trials),'  trials. PRACTICE: wait 3secs to start'];
tbound = Screen('TextBounds', w, welcometext);
[textx, texty] = RectCenter(tbound);
startx = cx - textx;
 
Screen('DrawText',w, welcometext,startx, cy);
Screen('Flip',w);

WaitSecs(3);

%GetClicks; % click the mouse to start the experiment 
%ListenChar(2); % 2
 
available_faces = 1:specs(3);
 
trial = 0;
tic; % start the timer 
  
% trials loop

for seq = eseq
     
    trial = trial + 1;
    whichcong = emat(seq,2); % PSC ->which congruency 
    whichGdir = emat(seq,3); % PSC -> which global direction
    whichlocal =emat(seq,4); % PSC -> local face direction 
    
    if whichGdir==1
        correct = 'LeftArrow';
        incorrect = 'RightArrow';
        whichslot = place_L_slots;
        whichplace = place_L;
    elseif whichGdir ==5
        correct = 'RightArrow';
        incorrect = 'LeftArrow';
        whichslot = place_R_slots;
        whichplace = place_R;
    end 
         
    block = ceil(trial/block_divider); % updated by WP
    HideCursor;
     
    %Show Fixation Cross + Wait
    linelength = 20; % pixel
    linewidth = 2; % pixel
    linecolor = [1 1 1] .* white;
     
    Screen('DrawLine', w, linecolor, cx-linelength/2, cy, cx+linelength/2, cy, linewidth);
    Screen('DrawLine', w, linecolor, cx, cy-linelength/2, cx, cy+linelength/2, linewidth);
    Screen('Flip',w);
    
    if Eye_Tracking == 1
        Eyelink('StartRecording')
        Eyelink('Message',strcat('TRIAL_',num2str(trial)));
        Eyelink('Message',strcat('FIXATION'));
    end
        
    WaitSecs(dur_fix);
     
    Screen('FillRect',w,background);
    Screen('Flip',w);
    WaitSecs(dur_blank);
     
    % after the fixation 
    Screen('FillRect',w,background);
    Screen('Flip',w);
   
    % Get the face gaze 
    Face_Gaze = whichlocal;
    FI = whichslot; % the slot_index (single number) in the grid PSC
    FL = whichplace; % the slot position in the matrix PSC 
    Face_id(1:9,1) = 0;
    Face_id = randseq(Face_id,9);
    
    % No jitter added -> only for Stroop task 
    ggx = gx; 
    ggy = gy; 
    
    for i=1:9
        ggy_F(i) = ggy(whichslot(i));
        ggx_F(i) = ggx(whichslot(i));
    end
    
    % The coordinate of the faces 
    coordF = CenterRectOnPoint(scaledRect,ggx_F',ggy_F'); 
         
    Faces = []; % Faces PSC 
    %create Faces texture
    Face_row = 3;
    for ii = 1:9
        Faces(ii) = Screen('MakeTexture',w,IdArray{Face_row,Face_Gaze,Face_id(ii)}(115:868,:));
    end
         
    %Draw Face Images to screen
    for ii = 1:9
        Screen('DrawTexture',w,Faces(ii),[],coordF(ii,:));
    end
        
    Screen('Flip',w);
    
    if Eye_Tracking == 1
        Eyelink('Message',strcat('STIMULUS'));
    end

     
    % Start recording the Kb reponse 
    
    stimonset = GetSecs;
    validKey = 0;
    response = 3; % in the data response should be either 1 or 0
    
    while response==3
        while ~validKey
            [keyIsDown, secs, keyCode] = KbCheck(keysetting);
            
            if keyIsDown
                if keyCode(KbName(incorrect))
                    response = 0;
                    responseT = GetSecs;
                    validKey = 1;
                elseif keyCode(KbName(correct))
                    response = 1;
                    responseT = GetSecs;
                    validKey = 1;
                    PsychPortAudio('FillBuffer', pahandle, chime(1:18558,:)');
                    startTime = PsychPortAudio('Start', pahandle);
                    
                end
            end
        end
    end
    
    
    if Eye_Tracking == 1
        Eyelink('Message',strcat('RESPONSE_',num2str(response)));
        Eyelink('StopRecording');
    end
    
    Response = response; % correct/incorrect 
    RT = responseT - stimonset;
    
    data_cell{seq, saveindex} = RT; % col 5
    data_cell{seq, saveindex +1} = Response;% col 6
    data_cell{seq, saveindex +2} = block; % col 7
    data_cell{seq, saveindex +3} = stimonset; % col 8
    data_cell{seq, saveindex +4} = responseT; % col 9

    % close Face images 
    Screen('Close',Faces);
    
    % break btw the blocks
    if mod(trial,block_divider) == 0 && trial ~= length(emat) % updated by WP
        JustBreakMouse(w,breakdur);
        ShowCursor;
        PsychPortAudio('FillBuffer', pahandle, chime(1:18558,:)');
        startTime = PsychPortAudio('Start', pahandle);
        
        if Eye_Tracking == 1
            % calibrate
            EyelinkDoTrackerSetup(el);
        end
    
        breaktext = [int2str(trial),'  trials. Click mouse to continue the experiment'];
        Screen('DrawText',w, breaktext,startx, cy);
        Screen('Flip',w);
        GetClicks;
    end

end


if Eye_Tracking == 1
    Eyelink('closefile');                                                       
    fprintf('Receiving data file ''%s''\n',edfFile);
    status = Eyelink('ReceiveFile');
    if status > 0
        fprintf('ReceiveFile status %d\n',status);
        movefile(fullfile('.', edfFile), fullfile('.', 'Waldo_Data', edfFile));
    end
    if 2 == exist(edfFile,'file')
        fprintf('Data file ''%s'' can be found in ''%s''\n',edfFile,pwd);
    end
end
            
%ListenChar(1);
toc;


%% Save data & Close 

cd(data_folder)
save(data_file_name,'data_cell')
cd ..
 ShowCursor;
Screen('CloseAll');



