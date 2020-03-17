%% Waldo code
% no eye-tracking, raw version


%% --- basic settings 
 
rand('seed', sum(100 * clock));
 
plinearize      = 0;
blackout        = 0;
scalefactor     = 2.2; 
maxjitter       = 20;
 
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
 
%% --- exp design

stimgrid_col = 3;
stimgrid_row = 3;
id_col = 5;
id_row = 5;
% conditions and trials

coherence = [0 .5 1];
% ndistractors- not sure whether this should stay constant or vary but this
% can just be adjusted manually
if stimgrid_col == 3 && stimgrid_row == 3
    ndistractors = [ 2 4 8 ];
else
    ndistractors = [ 4 8 16 ]; % what we had with the 5 x 7 - can also be changed manually
end
 
% conditions and trials
nrepeat = 50;
 
% make emat
emat = expmat(coherence,ndistractors);
emat = repmat(emat,nrepeat,1);
 
% randomize sequence
nblocks = 5;
ntrialsblock = (nrepeat * length(coherence) * length(ndistractors))/nblocks;
block_divider = ntrialsblock; % updated by WP

[eseq, emat] = randseq(emat, ntrialsblock);
 
[ex,ey] = size(emat);
saveindex = ey + 1;
 
total_trials = length(emat);
 
data_cell = num2cell(emat);
 
%% save file parameters
 
subject_id = 'ttttt';
 
data_file_name = strcat(subject_id,'_waldo_data.mat');
IsExist = exist(data_file_name, 'file');
 
if IsExist == 1
    error('data file name exists')
end
 
data_folder = strcat('Waldo_Data');
if isdir(data_folder) == 0
    mkdir(data_folder);
end
 
 
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
 
 
%% --- experiment 
 
%maybe add a while loop on outside that waits for esc key to close exp if
%necessary
 
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
target_id = available_faces(randi(available_faces(end)));
 
trial = 0;
tic;
 
for seq = eseq
     
    trial = trial + 1;
    whichcoh = emat(seq,2);
    whichndist = emat(seq,3);
    randomizer = [randi(stimgrid_col), randi(stimgrid_row)];
     
    block = ceil(trial/block_divider); % updated by WP
  
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
    WaitSecs(dur_fix);
     
    Screen('FillRect',w,background);
    Screen('Flip',w);
    WaitSecs(dur_blank);
     
    % Show Texture on screen
     
    scaledRect = CenterRectOnPoint(scaledRect,cx,cy);
    Screen('DrawTexture',w,Target,[],scaledRect);
    Screen('Flip',w);
     
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
    WaitSecs(dur_fix);
     
    Screen('FillRect',w,background);
    Screen('Flip',w);
    WaitSecs(dur_blank);
     
    % Pick random gaze direction for Target Image
     
    Target_Gaze = IdArray{exclude_middle_randi(stimgrid_row,id_row),exclude_middle_randi(stimgrid_row,id_col),target_id}(115:868,:);
    Target_Gaze = Screen('MakeTexture',w,Target_Gaze);
     
    
     
    %Pick random Target Location (anywhere in stimgrid_row x stimgrid_col grid)
     
    TL = [randi(stimgrid_row),randi(stimgrid_col)]; % Target Location (random coordinate (row, column) in a matrix)
    TI = place_slots(TL(1),TL(2)); % Target INDEX (Number between 1 and stimgrid_row*stimgrid_col)
     
    helper = all_slots((TL(1) : TL(1) + (stimgrid_row-1)), (TL(2) : TL(2) + (stimgrid_col-1) ));
     
    helper = fliplr(helper);
    helper = flipud(helper);
     
    possible_loc = generate_spaces((stimgrid_row*stimgrid_col),TI); % generates 34 indicies for distractor locations in random order
    distractor_loc = possible_loc(1:whichndist); % this is a vector containing all the linear indicies of the distractor locations on the 5x7 grid
    distractor_ids = generate_spaces(specs(3),target_id);
    distractor_ids = distractor_ids(1:whichndist); %this is a vector containing all of the face identities to be used this trial
     
    tempcoordid = randperm(numel(gx))';
    tempjitter = rand(numel(gx),2).*maxjitter - maxjitter/2;
    ggx = gx + reshape(tempjitter(:,1),size(gx,1),size(gx,2));
    ggy = gy + reshape(tempjitter(:,2),size(gy,1),size(gy,2));
     
    gx_t = ggx(distractor_loc)';
    gy_t = ggy(distractor_loc)';
     
    coordT = CenterRectOnPoint(scaledRect,ggx(TI), ggy(TI)); % maybe check that its going over rows and columns instead of x and y
    coordD = CenterRectOnPoint(scaledRect,gx_t,gy_t);
    
    front_view = ceil((id_col*id_row)/2);
     
    if whichcoh == 1
         
        distractor_gaze = helper(distractor_loc);
         
    elseif (0 < whichcoh) && (whichcoh < 1)
        kk = (length(distractor_loc)*whichcoh);
        dd = (length(distractor_loc)) - kk;
         
        distractor_gaze = helper(distractor_loc(1:kk));
         
        if dd == 1
            distractor_gaze(kk + 1) = exclude_middle_randi(front_view,(id_col*id_row)); %% make this not pick front location
        else
            for ii = 1:dd
            distractor_gaze(kk + ii) = exclude_middle_randi(front_view,(id_col*id_row)); %% make thsi not pick front location (make function that does this)
            end
        end
         
    elseif whichcoh == 0
         
        distractor_gaze = zeros(1,whichndist);
         
        for ii = 1:whichndist
            distractor_gaze(ii) = exclude_middle_randi(front_view,(id_col*id_row)); %% make this not pick front location %make a vector of all numbers 1-25 excluding the middle one
        end 
    end
     
    [dx, dy] = ind2sub([id_row,id_col], distractor_gaze);
         
    Distractors = [];
    %create Distractor Textures
    for ii = 1:whichndist
            Distractors(ii) = Screen('MakeTexture',w,IdArray{dx(ii),dy(ii),distractor_ids(ii)}(115:868,:));
    end
         
    %Draw Distractor Images to screen
    for ii = 1:whichndist
            Screen('DrawTexture',w,Distractors(ii),[],coordD(ii,:));
    end
         
    %Draw Target on to the Screen
    Screen('DrawTexture',w, Target_Gaze,[],coordT);
    Screen('Flip',w);
    ShowCursor('Arrow',w)
     
%     Start recording the mouses coordinates here
 
    target_search = true;
    stimonset = GetSecs;
    target_found = false;
 
     
    while target_search == true
         
        [clicks, mousex, mousey, whichButton] = GetClicks(w);
         
        inside = IsInRect(mousex, mousey, coordT);
        insideD = [];
         
        for ii = 1: whichndist
            insideD(ii) = IsInRect(mousex, mousey, coordD(ii,:));
            
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
            clicked_id = distractor_ids(idd);
            target_search = false;
             
        end
 
           
    end
     
        solver = coordT;
         
        for ii = 1:whichndist
            Screen('DrawTexture',w,Distractors(ii),[],coordD(ii,:));
        end
        Screen('DrawTexture',w, Target_Gaze,[],coordT);
        Screen('FrameRect', w, [1 0 0], solver, 6);
        Screen('Flip',w);
        WaitSecs(1);
     
        RT = responseT - stimonset;
        MeanDistance = ComputeMeanDist2Target(coordD,coordT);
        [target_x, target_y] = RectCenter(coordT);
        targDistancefromCenter = sqrt((cx-target_x)^2 +(cy-target_y)^2);
         
         
        data_cell{seq, saveindex} = RT;
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
 
     % close screens
        Screen('Close',Target);
        Screen('Close',Target_Gaze);
        for i = 1:whichndist
            Screen('Close',Distractors(i));
        end
         
%         if trial == 45 || trial == 90 || trial == 135 || trial == 180 || trial == 225
        if mod(trial,block_divider) == 0 && trial ~= length(emat) % updated by WP
            JustBreakMouse(w,breakdur);
            PsychPortAudio('FillBuffer', pahandle, chime(1:18558,:)');
            startTime = PsychPortAudio('Start', pahandle);
             
            breaktext = [int2str(trial),'  trials. Click mouse to continue the experiment'];
            Screen('DrawText',w, breaktext,startx, cy);
            Screen('Flip',w);
            GetClicks;
        end
end
ListenChar(1);
 
toc;
%% --- save and close 
 
cd(data_folder)
save(data_file_name,'data_cell')
cd ..
 
Screen('CloseAll');