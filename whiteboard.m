% all of the different possible angles that a face can be looking at
all_slots = [1:117];
all_slots = reshape(all_slots, 9,13);

%all of the different possible placements on a screen
place_slots = 1:35;
place_slots = reshape(place_slots, 5,7);

%creating stimulus arrays for each identity- organized according to the
%coordinates specified by all_slots- should be 9 x 13 array

img_path = './StimulusGrid'; % path to folder containing all the images
test = imread(fullfile(img_path,'filename.jpg'));

%filename = identity_column_row_.jpg
%filename = strcat(num2str(ii),'_', num2str(jj), '_', num2str(kk), '.jpg');


testArray = cell(9,13,5); %rows, column, identity

%this code below here works but I'd reccomend doing just one image at a
%time lest your computer get scrombled
for ii = 3:4
    for jj = -6:6
        for kk = -4:4
            filename = strcat('5','_', num2str(jj), '_', num2str(kk), '.jpg');   
            imagel = imread(filename);
            imagel = rgb2gray(imagel);
            imagel = double(imagel);
            
            
            testArray{(kk+5),(jj+7),(5)} = imagel;
        end
    end
end

%% Experimental Loop Steps

%Make sure IdArray and the Coordinate Matrix (5 x 7 grid)have been
%pre-loaded

load('IdArray_grid.mat');
place_slots = 1:35;
place_slots = reshape(place_slots, 5,7);

all_slots = 1:117;
all_slots = reshape(all_slots, 9,13);

dimx = 6;
dimy = 4;
[cart_x, cart_y] = meshgrid(-dimx:1:dimx, -dimy:1:dimy);

 for seq = eseq

        whichcoh = emat(seq,2);
        whichndist = emat(seq,3);

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

        %Pick from 1 of the ?? Target Images at 0,0 gaze direction- Show Texture on
        %screen- store Target Identity in Memory

        Target = Screen('MakeTexture',w,IdArray{5,7,1}(115:868,:));
        Screen('Flip',w);
        WaitSecs(dur_target);

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


        % Pick random gaze direction for Target Image

        Target_Gaze = IdArray{randi(5),randi(7),1}(115:868,:);

        %Pick random Target Location (anywhere in 5 x 7 grid)

        TL = [randi(5),randi(7)]; % Target Location (random coordinate in a 5 x 7 matrix)
        TI = place_slots(TL(1),TL(2)); % Target INDEX (Number between 1 and 35

        %Generate array of all possible gaze directions for target location:
        % Another 5 x 7 grid that corresponds to a subsection of IdArray

        helper = all_slots((TL(1):(TL(1)+4)),(TL(2):(TL(2)+6)));

        helper = fliplr(helper);
        helper = flipud(helper);

        %Pick Distractor Locations - (specified by the trial number)
        %Distractors can be anywhere in 5 x 7 grid but not where the target is
        
        possible_loc = generate_spaces(35,TI);
        distractor_loc = possible_loc(1:whichndist); % this is a vector containing all the indicies of the distractor locations on the 5x7 grid
        distractor_ids = randperm(19,whichndist); %this is a vector containing all of the face identities to be used this trial

        %Fill in distractor locations w/ face textures from IdArray that correspond
        %to the gaze angle appropriate for that location - maybe just run as
        %function?
        for bb = 1:length(distractor_loc)
            
            


        %Flip Screen


        %Start tracking the mouse location + display mouse + Start Timer


        %End Timer when mouse is clicked + If location is correct play noise!



        %Go into the next iteration of the loop






     % TBT when MATLAB had a stroke and output: A bald and smart and not very rich and smart and smart and not very young and not very young and young and tall and terrified and not very smart hamster obeyed the kid.
