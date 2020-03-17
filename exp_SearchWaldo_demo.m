clear all;
close all;

try
    %% --- basic settings 

    rand('seed', sum(100 * clock));

    plinearize      = 0;
    blackout        = 0;
    refreshHz       = 120;
    scalefactor     = 1.96; 
    maxjitter       = 0;

    %% --- screen settings

    % detect screen & set which screen to draw
    screens = Screen('Screens');
    screenNumber = max(screens);
    
    % define white, black, and gray indices
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);
    gray = white/2;
    background = 127;

    % open screen window 
    screen_size = [0 0 1280 720]; % pixels
    Screen('Preference', 'SkipSyncTests', 1);
    [w, rect] = Screen('OpenWindow',screenNumber,background,screen_size);
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
        if size(Screens,2) == 2
            w2 = Screen('OpenWindow',0,0,[],[],2);
            Screen('FillRect',w2, 0); 
            Screen('Flip', w2);
        end
    end

    %% --- exp design

    % conditions and trials
    coherence = [1 2]; % 1: 0% coh / 2: 100% coh
    nrepeat = 1;

    % make emat
    emat = expmat(coherence);
    emat = repmat(emat,nrepeat,1); % basically makes a trial list bc its coherence conditions *n repitiions

    % randomize sequence
    [eseq, emat] = randseq(emat); % spits out eseq which is the

    [ex,ey] = size(emat);
    saveindex = ey + 1;
    emat(seq, saveindex) = RT; %move to end of for loop
    emat(seq, saveindex +1) = MeanDist2target

    %% --- set durations (secs)
    dur_target = 1; 
    dur_blank = 0.5; 
    dur_fix = 0.5; 

    %% -- load images and coordinates 
%     load('ImArray.mat');
    load('ImArray_grid.mat');
    load('CoordMat_grid.mat');
%     load('CoordMat.mat');
    
    [ix,iy] = RectCenter([0 0 752 984]);
    showrect = CenterRectOnPoint([0 0 752 752],ix,iy);

    %% -- stimulus settings
    imSize = 87; % pixels 

    %% --- experiment 

    for seq = eseq

        whichcoh = emat(seq,2);
        ndist = 16;

        % make textures
        Target = Screen('MakeTexture',w,ImArray{3,end}(115:868,:));
        for i = 1:ndist
            Distractors(i) = Screen('MakeTexture',w,ImArray{whichcoh,i}(115:868,:));
        end
        Target2 = Screen('MakeTexture',w,ImArray{whichcoh,end}(115:868,:));

        % coordinates 
%         coordT = rects{whichcoh}(end,:);
%         coordD = rects{whichcoh}(1:ndist,:);
        scaledRect = [0 0 imSize imSize]; %size of stimulus NOT size of image
        gx = CoordMat{whichcoh}(:,1);
        gy = CoordMat{whichcoh}(:,2);
        tempjitter = rand(numel(gx),2).*maxjitter - maxjitter/2;
        tgx = gx + reshape(tempjitter(:,1),size(gx,1),size(gx,2));
        tgy = gy + reshape(tempjitter(:,2),size(gy,1),size(gy,2));
        coordT = CenterRectOnPoint(scaledRect,tgx(end,1),tgy(end,1));
        coordD = CenterRectOnPoint(scaledRect,tgx(1:ndist,1),tgy(1:ndist,1));

        % fixation 
        linelength = 20; % pixel
        linewidth = 2; % pixel 
        linecolor = [1 1 1] .* white; 

        Screen('DrawLine', w, linecolor, cx-linelength/2, cy, cx+linelength/2, cy, linewidth);
        Screen('DrawLine', w, linecolor, cx, cy-linelength/2, cx, cy+linelength/2, linewidth);
        Screen('Flip',w);
        WaitSecs(dur_fix);

        % blank 
        Screen('FillRect',w,background);
        Screen('Flip',w);
        WaitSecs(dur_blank);

        % target
        
        scaledRect = CenterRectOnPoint(scaledRect,cx,cy);
        Screen('DrawTexture',w,Target,[],scaledRect);
        Screen('Flip',w);
        WaitSecs(dur_target);
%         GetChar;

        % blank
        Screen('FillRect',w,background);
        Screen('Flip',w);
        WaitSecs(dur_blank);

        % stimulus 
        Screen('DrawTexture',w,Target2,[],coordT);
        for i = 1:ndist
            Screen('DrawTexture',w,Distractors(i),[],coordD(i,:));
%             Screen('DrawTexture',w,Distractors(ii),[],coordD(ii));
        end
        Screen('Flip',w);
        GetChar;

        % close screens
        Screen('Close',Target);
        Screen('Close',Target2);
        for i = 1:ndist
            Screen('Close',Distractors(i));
        end

    end
    %% --- save and close 

    Screen('CloseAll');
    
catch ME
    Screen('CloseAll');
    
end



