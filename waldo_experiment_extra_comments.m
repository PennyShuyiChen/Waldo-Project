
%% --- Waldo analysis code but with extra comments


% settings - don't worry about the stuff here
rand('seed', sum(100 * clock));

plinearize      = 1 o 1 if you want the screen running the experiment (not the projector) to be blacked out, change this to 1 (Not Reccomended)
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

% conditions and trials
coherence = [0 .5 1];
ndistractors = [4 8 16];
nrepeat = 30; 

% make emat
% emat is a matrix that contains all the information for each trial,
% eventually becomes the save file
emat = expmat(coherence,ndistractors);
emat = repmat(emat,nrepeat,1);

% randomize sequence + sets block information
nblocks = 6;
ntrialsblock = (nrepeat * length(coherence) * length(ndistractors))/nblocks;
[eseq, emat] = randseq(emat, ntrialsblock);

[ex,ey] = size(emat);
saveindex = ey + 1;

total_trials = length(emat);

data_cell = num2cell(emat); %converts emat to a cell array which updates with variables on the end of each trial

%% save file parameters

subject_id = 'naive_subject_7'; % come up with a naming convention that allows the subject info to stay confidential (i.e. don't use the name of the subject)

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
dur_target = 1; % this number doesn't affect the first 10 trials.
dur_blank = 0.5; 
dur_fix = 0.5;
breakdur = 45; % durations for the breaks between blocks

%% -- stimulus settings

imSize = 87; % pixels
scaledRect = [0 0 imSize imSize];

%% -- load images + coordinates + indices

% load 5x7 screen grid coordinates (pixels)
dimx = 3;
dimy = 2;
[gx, gy] = meshgrid(-dimx:1:dimx, -dimy:1:dimy);

screenYpixels = 798; % 800+530 | 798
pixelScale = screenYpixels / (dimy * 2 + 2);
gx = gx .* pixelScale + cx; %x coordinates of places on screen that coorespond to 5 x 7 grid
gy = gy .* pixelScale + cy; % same but for y

tgx = gx+4; % cartesian coordinates for x target position
tgy = gy+3; % cartesian coordinates for y target position

load('IdArray.mat'); % array that contains all the images for all identities- 9 x 13 x 20 grid
place_slots = 1:35;
place_slots = reshape(place_slots, 5,7); % linear coordinates for the 35 places on the screen an image can appear in

all_slots = 1:117;
all_slots = reshape(all_slots, 9,13); % linear  coordinates for all 117 possible head rotations an image could have

InitializePsychSound;
pahandle = PsychPortAudio('Open'); % initializes audio
load('chime.mat');
chime(:,2) = chime;


%% --- experiment 

%set up welcome text
textsize = 20;
Screen('TextSize',w,textsize);
welcometext = [int2str(total_trials),'  trials. Click mouse to start the experiment'];
tbound = Screen('TextBounds', w, welcometext);
[textx, texty] = RectCenter(tbound);
startx = cx - textx;

Screen('DrawText',w, welcometext,startx, cy);
Screen('Flip',w);

% waits for a mouse click
GetClicks;

%suppress input from keyboard
ListenChar(2);

%picks a target from available faces
available_faces = [ 1 2 3 5 6 7 9 13 14 15 16 17 18 19 ];
target_id = available_faces(randi(14));

% trial counter - initializes at zero
trial = 0;
tic;

% begin experimental loop
for seq = eseq
    
    trial = trial + 1;
    whichcoh = emat(seq,2);
    whichndist = emat(seq,3);
    randomizer = [randi(5), randi(7)];
    
    %identify block information
    if trial <= 45
        block = 1;
    elseif trial <= 90
        block = 2;
    elseif trial <= 135
        block = 3;
    elseif trial <= 180
        block = 4;
    elseif trial <= 225
        block = 5;
    elseif trial <= 270
        block = 6;
    end
 
    %Make Target Face Texture at 0,0 gaze direction
    Target = Screen('MakeTexture',w,IdArray{5,7,target_id}(115:868,:));
    
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
    
    % Show Target on screen
    
    scaledRect = CenterRectOnPoint(scaledRect,cx,cy);
    Screen('DrawTexture',w,Target,[],scaledRect);
    Screen('Flip',w);
    
    %for first 10 trials, Wait 5 seconds before removing the target from
    %screen, otherwise remove target after 5 seconds
    if trial <= 10
        WaitSecs(5);
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
    
    Target_Gaze = IdArray{randi(9),randi(13),target_id}(115:868,:);
    Target_Gaze = Screen('MakeTexture',w,Target_Gaze);
    
    
    %Pick random Target Location (anywhere in 5 x 7 grid)
    
    TL = [randi(5),randi(7)]; % Target Location (random coordinate (row, column) in a 5 x 7 matrix)
    TI = place_slots(TL(1),TL(2)); % Target INDEX (Number between 1 and 35
    
    % Build translation matrix, the 5 x 7 area of the 9 x 13 grid showing
    % all possible gaze directions for the target location
    helper = all_slots((TL(1) : TL(1) + 4), (TL(2) : TL(2) + 6 )); 
    
    helper = fliplr(helper);
    helper = flipud(helper);
    
    possible_loc = generate_spaces(35,TI); % generates 34 indicies for distractor locations in random order
    distractor_loc = possible_loc(1:whichndist); % this is a vector containing all the linear indicies of the distractor locations on the 5x7 grid
    distractor_ids = generate_spaces(20,target_id); % this is a vector containing all the available identities in random order excluding the target
    distractor_ids = distractor_ids(1:whichndist); %this is a vector containing all of the face identities to be used this trial
    
    % adds jitter to the target coordinates
    tempcoordid = randperm(numel(gx))';
    tempjitter = rand(numel(gx),2).*maxjitter - maxjitter/2;
    ggx = gx + reshape(tempjitter(:,1),size(gx,1),size(gx,2));
    ggy = gy + reshape(tempjitter(:,2),size(gy,1),size(gy,2));
    
    gx_t = ggx(distractor_loc)';
    gy_t = ggy(distractor_loc)';
    
    coordT = CenterRectOnPoint(scaledRect,ggx(TI), ggy(TI)); % Coordinate on Screen where Target will be located
    coordD = CenterRectOnPoint(scaledRect,gx_t,gy_t); % Coordinates on Screen where distractors will be located
    
    
    if whichcoh == 1 
        
        distractor_gaze = helper(distractor_loc); % At 100% coherence, all distractor gazes are defined by the translation matrix
        
    elseif (0 < whichcoh) && (whichcoh < 1) % At 50% coherence, 50% distractor gazes are defined by the translation matrix, the other 50% are defined randomly
        kk = (length(distractor_loc)*whichcoh);
        dd = (length(distractor_loc)) - kk;
        
        distractor_gaze = helper(distractor_loc(1:kk));
        
        if dd == 1
            distractor_gaze(kk + 1) = randi(117);
        else
            for ii = 1:dd
            distractor_gaze(kk + ii) = randi(117); 
            end
        end
        
    elseif whichcoh == 0
        
        distractor_gaze = zeros(1,whichndist);
        
        for ii = 1:whichndist
            distractor_gaze(ii) = randi(117); % at 0% coherence, all distracor gazes are defined randomly
        end 
    end
    
    [dx, dy] = ind2sub([9,13], distractor_gaze); % converts linear indicies into row + column indicies
        
    Distractors = [];
    %create Distractor Textures
    for ii = 1:whichndist
            Distractors(ii) = Screen('MakeTexture',w,IdArray{dx(ii),dy(ii),distractor_ids(ii)}(115:868,:));
    end
        
    %Draw Distractor Textures to screen
    for ii = 1:whichndist
            Screen('DrawTexture',w,Distractors(ii),[],coordD(ii,:));
    end
        
    %Draw Target on to the Screen
    Screen('DrawTexture',w, Target_Gaze,[],coordT);
    Screen('Flip',w);
    ShowCursor('Arrow',w)
    
%  Start recording the mouse here

    target_search = true; % target search begins
    stimonset = GetSecs; % Get the time
    target_found = false; 

    
    while target_search == true % continues loop until subject clicks on either a target or a distractor
        
        [clicks, mousex, mousey, whichButton] = GetClicks(w); % find mouse coordinates when clicked
        
        inside = IsInRect(mousex, mousey, coordT); % checks to see if mousex and mousey are in the target
        insideD = [];
        
        for ii = 1: whichndist
            insideD(ii) = IsInRect(mousex, mousey, coordD(ii,:)); % checks to see if mousex and mousey are in the distractors
           
        end
        
        %ends search if inside targets or distractors, continues search if
        %subject clicked on greay space. Records if the subject was able to
        %find the target
        
        if inside 
            target_found = true;
            responseT = GetSecs;
            clicked_id = target_id;
            PsychPortAudio('FillBuffer', pahandle, chime(1:18558,:)'); % play chime if target found
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
        
        % when target search ends update display to show location of Target
        for ii = 1:whichndist
            Screen('DrawTexture',w,Distractors(ii),[],coordD(ii,:));
        end
        Screen('DrawTexture',w, Target_Gaze,[],coordT);
        Screen('FrameRect', w, [1 0 0], solver, 6);
        Screen('Flip',w);
        WaitSecs(1);
    
        RT = responseT - stimonset; % gets reaction time
        MeanDistance = ComputeMeanDist2Target(coordD,coordT); % gets mean euclidean distance of distractors to target
        [target_x, target_y] = RectCenter(coordT);
        targDistancefromCenter = sqrt((cx-target_x)^2 +(cy-target_y)^2); % gets euclidean distance of target to center of screen
        
        
       % update data file with all relevant information
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
        
     
     % initiate a break if btwn blocks
        if trial == 45 || trial == 90 || trial == 135 || trial == 180 || trial == 225
            JustBreakMouse(w,breakdur);
            PsychPortAudio('FillBuffer', pahandle, chime(1:18558,:)');
            startTime = PsychPortAudio('Start', pahandle);
            
            breaktext = [int2str(trial),'  trials. Click mouse to continue the experiment'];
            Screen('DrawText',w, breaktext,startx, cy);
            Screen('Flip',w);
            GetClicks;
        end
end
ListenChar(1); % reenables keyboard input

toc;
%% --- save and close 

cd(data_folder)
save(data_file_name,'data_cell')
cd ..

Screen('CloseAll');