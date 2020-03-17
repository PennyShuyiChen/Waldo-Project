% Created by Sholei Croom
% Updated by Woon Ju Park 03/0/2018 to add eye tracking 
% Modified by Penny Shuyi Chen 06/20/2019 for Posner Paradigm-proportion
% version 
        % With proportion: 40% invalid. 10% valid and 50% baseline 
        % Add baseline
      
clear all; close all;

%% --- basic settings 
 
rand('seed', sum(100 * clock));
  
plinearize      = 0; % 1 or 0. Doesn't matter for projector. 
blackout        = 0; % keep it to 0 
scalefactor     = 1.98; 
maxjitter       = 20;

Eye_Tracking    = 0; % 1: we will track the eyes / 0: no eye tracking
dummymode       = 0; % keep this to 0 the whole time 

%% save file parameters
 
subject_id = 'pftest';
 
data_file_name = strcat(subject_id,'_waldo_data.mat');
edfFile = strcat(subject_id,'.edf');
IsExist = exist(data_file_name, 'file');
 
if IsExist == 1
    error('data file name exists')
end
 
data_folder = strcat('Waldo_Posner_Data');
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
% screenWidth  = screen_size(3) - screen_size(1);
% screenHeight = screen_size(4) - screen_size(2);
% sr_hor = round(screen_size(3)/2); 
% sr_ver = round(screen_size(4)/2);
 
 
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
 
%% --- experiment design

stimgrid_col = 3;
stimgrid_row = 3;
id_col = 5; 
id_row = 5;
% conditions and trials

coherence = [0]; % posner coherence levels 
valid = [0,0,0,0,1,2,2,2,2,2];
if stimgrid_col == 3 && stimgrid_row == 3
    ndistractors = [ 8 ]; % posner distractor level 
else
    ndistractors = [ 4 8 16 ]; % what we had with the 5 x 7 - can also be changed manually
end
 
% conditions and trials
nrepeat = 1; % with the baseline is 13
                   
% make emat
emat = expmat(coherence,ndistractors,valid);
for e = 1:length(emat)
    if emat(e,3) ~= 2
    emat(e,1) = 1 
    end
end
emat = repmat(emat,nrepeat,1);
 
% randomize sequence
nblocks = 1; % complete experiment is 2
ntrialsblock = (nrepeat * 10)/nblocks; %65 trials/block
block_divider = ntrialsblock; % updated by WP

[eseq, emat] = randseq(emat, ntrialsblock);
 
[ex,ey] = size(emat); % * 4 [noTrial, coh, noD, valid]
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
 
screenYpixels = 600; % 800+530 | 798 | 600
pixelScale = screenYpixels / (dimy * 2 + 2);
gx = gx .* pixelScale + cx; %x coordinates of places on screen that coorespond to 5 x 7 grid
gy = gy .* pixelScale + cy; % same but for y
 
tgx = gx+4; % cartesian coordinates for x target position
tgy = gy+3; % cartesian coordinates for y target position
 
load('IdArray_small.mat'); %% IMPORTANT: loads data as cell array called IdArray
place_slots = 1:(stimgrid_col*stimgrid_row);
place_slots = reshape(place_slots, stimgrid_col,stimgrid_row);
 
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

%     eye_count_length = max_time_step;
%     eye_data(1).time_stamp = nan( eye_count_length, 1);
%     eye_data(1).eyeX = nan( eye_count_length, 2);
%     eye_data(1).eyeY = nan( eye_count_length, 2);
%     eye_data(1).pupil = nan( eye_count_length, 2);
%     eye_data(1:total_trials) = eye_data(1);
end

%% --- experiment 
 
textsize = 20;
Screen('TextSize',w,textsize);
welcometext = [int2str(total_trials),'  trials. Click mouse to start the experiment'];
tbound = Screen('TextBounds', w, welcometext);
[textx, texty] = RectCenter(tbound);
startx = cx - textx;
 
Screen('DrawText',w, welcometext,startx, cy);
Screen('Flip',w);
 
GetClicks;
 
ListenChar(2);
 
available_faces = 1:specs(3);
target_id = available_faces(randi(available_faces(end))); % select the real-Target for each subject
pt_select = 0;
 
trial = 0;
whichvalid = 3;
tic;
 
for seq = eseq
     
    trial = trial + 1;
    whichcoh = emat(seq,2); %0-baseline || 1-Posner
    whichndist = emat(seq,3); % always 8
    whichvalid = emat(seq,4); % 0-invalid || 1-valid || 2-baseline 
    if whichvalid == 0
        fprintf ('INVALID TRIAL');
    elseif whichvalid == 1 
        fprintf('valid');
    else
        fprintf('Baseline');
    end
    randomizer = [randi(stimgrid_col), randi(stimgrid_row)];
     
    block = ceil(trial/block_divider); % updated by WP
    
    % select the pseudo-target 
if whichvalid == 0
    while pt_select == 0
        pseudo_target_id = available_faces(randi(available_faces(end)));
        if pseudo_target_id ~= target_id
            pt_select = 1;
        end
    end
end
  pt_select = 0;
    %Make Target Face Texture at 0,0 gaze direction
    Target = Screen('MakeTexture',w,IdArray{stimgrid_row,stimgrid_col,target_id}(115:868,:));
     
    HideCursor;
     
    %Show Fixation Cross + Wait
    linelength = 20; % pixel
    linewidth = 2; % pixel
    linecolor = [1 1 1] .* white;
     
    Screen('DrawLine', w, linecolor, cx-linelength/2, cy, cx+linelength/2, cy, linewidth);
    Screen('DrawLine', w, linecolor, cx, cy-linelength/2, cx, cy+linelength/2, linewidth);
    Screen('Flip',w);
    
    if Eye_Tracking == 1 %start eye-tracking 
        Eyelink('StartRecording')
        Eyelink('Message',strcat('TRIAL_',num2str(trial)));
        Eyelink('Message',strcat('FIXATION'));
    end
        
    WaitSecs(dur_fix);
     
    Screen('FillRect',w,background);
    Screen('Flip',w);
    WaitSecs(dur_blank);
     
    % Show Texture on screen
     
    scaledRect = CenterRectOnPoint(scaledRect,cx,cy);
    Screen('DrawTexture',w,Target,[],scaledRect);
    Screen('Flip',w);
    
    if Eye_Tracking == 1
        Eyelink('Message',strcat('TARGET'));
    end
     
    if trial <= 10
        WaitSecs(2);
    else
        WaitSecs(dur_target);
    end
     
    %Show Fixation Cross
     
    linelength = 20; % pixel
    linewidth = 2; % pixel
    linecolor = [1 1 1] .* white;
     
    Screen('DrawLine', w, linecolor, cx-linelength/2, cy, cx+linelength/2, cy, linewidth);
    Screen('DrawLine', w, linecolor, cx, cy-linelength/2, cx, cy+linelength/2, linewidth);
    Screen('Flip',w);
    
    if Eye_Tracking == 1
        Eyelink('Message',strcat('FIXATION'));
    end
    
    WaitSecs(dur_fix);
     
    Screen('FillRect',w,background);
    Screen('Flip',w);
    
    if Eye_Tracking == 1
        Eyelink('Message',strcat('BLANK'));
    end
    
    WaitSecs(dur_blank);
   
    %% || EXPERIMENT TRIALS || 
    % Pick random gaze direction for Target || Pseudo-Target Image
     if whichvalid == 1 || whichvalid == 2
        Target_Gaze = IdArray{exclude_middle_randi(stimgrid_row,id_row),exclude_middle_randi(stimgrid_row,id_col),target_id}(115:868,:);
        Target_Gaze = Screen('MakeTexture',w,Target_Gaze);
        TargetScreen = Target_Gaze;
     
     elseif whichvalid == 0
            PTarget_Gaze = IdArray{exclude_middle_randi(stimgrid_row,id_row),exclude_middle_randi(stimgrid_row,id_col),pseudo_target_id}(115:868,:);
            PTarget_Gaze = Screen('MakeTexture',w,PTarget_Gaze);
     end 
            
            % The target should gaze towards the PT Target_Gaze = Screen('MakeTexture',w,Target_Gaze);   
    %Pick random Target Location (anywhere in stimgrid_row x stimgrid_col grid)
     
    TL = [randi(stimgrid_row),randi(stimgrid_col)]; % Target Location (random coordinate (row, column) in a matrix)
    TI = place_slots(TL(1),TL(2)); % Target INDEX (Number between 1 and stimgrid_row*stimgrid_col)
    select = 0;
    if whichvalid == 0
        while select == 0
        PL = [randi(stimgrid_row),randi(stimgrid_col)];
        PI = place_slots(PL(1),PL(2));
        if PI~= TI
            select = 1;
        end 
        end    
    end 
    
    if whichvalid == 1 || whichvalid == 2
        helper = all_slots((TL(1) : TL(1) + (stimgrid_row-1)), (TL(2) : TL(2) + (stimgrid_col-1) ));
    end
     if whichvalid == 0
         helper = all_slots((PL(1) : PL(1) + (stimgrid_row-1)), (PL(2) : PL(2) + (stimgrid_col-1) ));
     end
    helper = fliplr(helper);
    helper = flipud(helper);
    
    if whichvalid == 1 || whichvalid == 2
    possible_loc = generate_spaces((stimgrid_row*stimgrid_col),TI); % generates 34 indicies for distractor locations in random order
    distractor_loc = possible_loc(1:whichndist); % this is a vector containing all the linear indicies of the distractor locations on the 5x7 grid
    distractor_ids = generate_spaces(specs(3),target_id);
    distractor_ids = distractor_ids(1:whichndist); %this is a vector containing all of the face identities to be used this trial
    end 
    if whichvalid == 0 % the location of the distractors 
    possible_loc = generate_spaces((stimgrid_row*stimgrid_col),[TI,PI]);
    possible_T = generate_spaces((stimgrid_row*stimgrid_col),PI);
    possible_gaze_loc = generate_spaces((stimgrid_row*stimgrid_col),[PI, possible_loc]);
    distractor_loc = possible_loc(1:whichndist-1); 
    distractor_gaze_loc = possible_loc(1:whichndist-1);
    target_gaze_loc = possible_gaze_loc(1);
    
    Target_Gaze = helper(target_gaze_loc);
    [tx, ty] = ind2sub([id_row, id_col], Target_Gaze);
    
    fprintf(int2str(Target_Gaze));
    
    TargetScreen = Screen('MakeTexture',w,IdArray{tx,ty,target_id}(115:868,:));
    
    fprintf(int2str(Target_Gaze));
        
    distractor_ids = generate_spaces(specs(3),[target_id, pseudo_target_id]);
    distractor_ids = distractor_ids(1:whichndist-1); 
   end 
            
    tempcoordid = randperm(numel(gx))';
    tempjitter = rand(numel(gx),2).*maxjitter - maxjitter/2;
    ggx = gx + reshape(tempjitter(:,1),size(gx,1),size(gx,2));
    ggy = gy + reshape(tempjitter(:,2),size(gy,1),size(gy,2));
     
    gx_t = ggx(distractor_loc)';
    gy_t = ggy(distractor_loc)';
     
    coordT = CenterRectOnPoint(scaledRect,ggx(TI), ggy(TI)); % maybe check that its going over rows and columns instead of x and y
    coordD = CenterRectOnPoint(scaledRect,gx_t,gy_t);
    
    if whichvalid == 0
        coordPT = CenterRectOnPoint(scaledRect,ggx(PI), ggy(PI));
        coordD = CenterRectOnPoint(scaledRect,gx_t,gy_t);
    end
    
    front_view = ceil((id_col*id_row)/2);
     
    if whichvalid == 1 || whichvalid == 0
        if whichvalid == 1
        distractor_gaze = helper(distractor_loc);
        end 
        if whichvalid == 0
        distractor_gaze = helper(distractor_gaze_loc);
        
        %%%%%%%
        end 
    elseif whichvalid == 2
        distractor_gaze = zeros(1,whichndist);
        for ii = 1:whichndist
            distractor_gaze(ii) = exclude_middle_randi(front_view,(id_col*id_row));
            % not picking the fron loc (a vector excluding the middle one)  
        end
    end 
   
    [dx, dy] = ind2sub([id_row,id_col], distractor_gaze);
    if whichvalid == 0
    [px, py] = ind2sub([id_row,id_col], PTarget_Gaze);
    end
         
    Distractors = [];
    %create Distractor Textures
    if whichvalid ==1 || whichvalid ==2
    for ii = 1:whichndist
        Distractors(ii) = Screen('MakeTexture',w,IdArray{dx(ii),dy(ii),distractor_ids(ii)}(115:868,:));
    end
         
    %Draw Distractor Images to screen
        for ii = 1:whichndist
            Screen('DrawTexture',w,Distractors(ii),[],coordD(ii,:));
        end
    end
    
   if whichvalid ==0
      for ii = 1:whichndist-1
        Distractors(ii) = Screen('MakeTexture',w,IdArray{dx(ii),dy(ii),distractor_ids(ii)}(115:868,:));
      end
         
        %Draw Distractor Images to screen
        for ii = 1:whichndist-1
        Screen('DrawTexture',w,Distractors(ii),[],coordD(ii,:));
        end
   end 
   
    %Draw Pseudo-Target 
    if whichvalid ==0
        %Pseudo = Screen('MakeTexture',w,IdArray{px,py,pseudo_target_id}(115:868,:));
        Screen('DrawTexture',w, PTarget_Gaze,[],coordPT);
       % Screen('Flip',w);
    end 
    
    %Draw Target on to the Screen
    Screen('DrawTexture',w, TargetScreen,[],coordT);
    Screen('Flip',w);
    ShowCursor('Arrow',w)
    
    if Eye_Tracking == 1
        Eyelink('Message',strcat('STIMULUS'));
    end
     
    % Start recording the mouses coordinates here
    target_search = true;
    stimonset = GetSecs;
    target_found = false;
%     eye_count = 0;
    
    while target_search == true
         
        [clicks, mousex, mousey, whichButton] = GetClicks(w);
        inside = IsInRect(mousex, mousey, coordT);
        insideD = [];
        
        if whichvalid == 1 || whichvalid == 2
            for ii = 1: whichndist
                insideD(ii) = IsInRect(mousex, mousey, coordD(ii,:));
            end
        end
        if whichvalid == 0 
        for ii = 1: whichndist-1
            insideD(ii) = IsInRect(mousex, mousey, coordD(ii,:));   
        end
            insideD(ii+1) = IsInRect(mousex, mousey, coordPT);
        end
         
        if inside 
            target_found = true;
            responseT = GetSecs;
            clicked_id = target_id;
            PsychPortAudio('FillBuffer', pahandle, chime(1:18558,:)');
            startTime = PsychPortAudio('Start', pahandle);
            target_search = false;
             
        elseif any(insideD)
            responseT = GetSecs;
            idd = find(insideD == 1);
            if idd<8
            clicked_id = distractor_ids(idd); 
            else clicked_id = pseudo_target_id;
            end
            
            target_search = false;
             
        end 
    end
    
    if Eye_Tracking == 1
        Eyelink('Message',strcat('RESPONSE_',num2str(target_found)));
        Eyelink('StopRecording');
    end
     
    solver = coordT;
    if whichvalid == 1 || whichvalid == 2
    for ii = 1:whichndist
        Screen('DrawTexture',w,Distractors(ii),[],coordD(ii,:));
    end
    end
    if whichvalid == 0
       for ii = 1:whichndist-1
        Screen('DrawTexture',w,Distractors(ii),[],coordD(ii,:));
        Screen('DrawTexture',w,PTarget_Gaze,[],coordPT);
       end 
    end

    Screen('DrawTexture',w, TargetScreen,[],coordT);
    Screen('FrameRect', w, [1 0 0], solver, 6);
    Screen('Flip',w);
    WaitSecs(1);

    RT = responseT - stimonset;
    MeanDistance = ComputeMeanDist2Target(coordD,coordT);
    [target_x, target_y] = RectCenter(coordT);
    targDistancefromCenter = sqrt((cx-target_x)^2 +(cy-target_y)^2);


    data_cell{seq, saveindex} = RT; %column 5
    data_cell{seq, saveindex +1} = MeanDistance;
    data_cell{seq, saveindex +2} = target_found;
    data_cell{seq, saveindex +3} = clicked_id;
    data_cell{seq, saveindex +4} = TI;
    data_cell{seq, saveindex +5} = Target_Gaze;
    data_cell{seq, saveindex +6} = distractor_ids;
    data_cell{seq, saveindex +7} = distractor_loc;
    data_cell{seq, saveindex +8} = distractor_gaze;
    data_cell{seq, saveindex +9} = block;
    data_cell{seq, saveindex +10} = targDistancefromCenter;
    if whichvalid == 0
    data_cell{seq, saveindex +11} = pseudo_target_id;
    data_cell{seq, saveindex +12} = PTarget_Gaze;
    data_cell{seq, saveindex +13} = PI;
    elseif whichvalid == 1 || whichvalid == 2
        data_cell{seq, saveindex +11} = 0;
        data_cell{seq, saveindex +12} = 0;
        data_cell{seq, saveindex +13} = 0;
    end

    % close screens
    Screen('Close',Target);
    Screen('Close',TargetScreen);
    for i = 1:whichndist-1
        Screen('Close',Distractors(i));   
    end

%         if trial == 45 || trial == 90 || trial == 135 || trial == 180 || trial == 225
    if mod(trial,block_divider) == 0 && trial ~= length(emat) % updated by WP
        JustBreakMouse(w,breakdur);
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
%         movefile(fullfile('.', [edfFile '.edf']), fullfile('.', 'EDF Data', [edfFile '.edf']));
        movefile(fullfile('.', edfFile), fullfile('.', 'Waldo_Posner_Data', edfFile)); % 'EDF Data' is replaced by 'Waldo_Inverted_Data'
    end
    if 2 == exist(edfFile,'file')
        fprintf('Data file ''%s'' can be found in ''%s''\n',edfFile,pwd);
    end
end
            
ListenChar(1);
 
toc;
%% --- save and close 
 
cd(data_folder)
save(data_file_name,'data_cell')
cd ..
 
Eyelink('Shutdown');
Screen('CloseAll');