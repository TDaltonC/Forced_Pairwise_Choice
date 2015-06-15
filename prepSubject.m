function [] = prepSubject( subjID,runs,trialsPerRun,input,options)
%% If not running on actual subject, use the following to test out script
% item1c = 1; item2c = 2; item3c = 3;
% item4c = 4; item5c = 5; item6c = 6;
% item7c = 7; item8c = 8; item9c = 9;
% item10c = 10; item11c = 11; item12c = 12;
% item13c = 13; item14c = 14; item15c= 15;
% item16c = 16; item17c= 17; item18c = 18;
% item19c = 19; item20c = 20; item21c = 21;
%% Settings
%Default for runs
if exist('runs', 'var') == 0;
    runs = 5;
end
%Default for trials
if exist('trialsPerRun', 'var') ==0;
    trialsPerRun = 75;
end
% Default for subjID is 1. This only kicks in iff no subject ID is given.
if exist('subjID','var') == 0;
    subjID = 1;
end
if exist('input','var') == 0;
    input = 'k';
end

%% Items
if exist('options', 'var') == 0;
    options = {[1,0],[0,0],[4,1],[3,4],[5,3],[7,6],[1,3],[4,2],[7,1],[4,3],[2,1],[5,6],[7,7],[1,2],[5,6],[8,7]};
end

optionsImages = cell(21,1);
for i = 1:21;
    optionsImages{i} = imread(strcat('Image', num2str(i), '.jpg'));
end

grey = imread('grey.jpg');

%% **Design the task orders**

%%Break the options into arrays based on other characteristsc
%Each of these arrays is a different type: NULL, SINGLE, HETERO, HOMO
nullOptions = {};
singleOptions = {};
heteroOptions = {};
homoOptions = {};

%Go through the existing options and break them into their respective
%groups
for i=1:length(options);
    if (options{i}(1) == 0 && options{i}(2) == 0)
        nullOptions = cat(1, nullOptions, options{i});
    elseif (options{i}(1) == 0 || options{i}(2) == 0)
        singleOptions = cat(1, singleOptions, options{i});
    else
        if options{i}(1) == options{i}(2)
            homoOptions = cat(1, homoOptions, options{i});
        else
            heteroOptions = cat(1, heteroOptions, options{i});
        end
    end
end

%Randomize arrays
rand = randperm(length(singleOptions));
singleOptions = singleOptions(rand);
rand = randperm(length(heteroOptions));
heteroOptions = heteroOptions(rand);
rand = randperm(length(homoOptions));
homoOptions = homoOptions(rand);

%THIS WILL USE THE WEIGHTING FUNCTION
totalTrials = runs * trialsPerRun;
[weightedArray, inputString] = repeatedhistory(4, 3, 2);

orderedOptions = {};
nullIndex = 1;
singleIndex = 1;
heteroIndex = 1;
homoIndex = 1; 

%Go through the weightArray and determine the options order
for i=1:length(weightedArray);
    switch weightedArray(i)
        case 1 %NULL
            orderedOptions = cat(1, orderedOptions, nullOptions{nullIndex});
            nullIndex = nullIndex + 1;
            if (nullIndex > length(nullOptions))
                nullIndex = 1;
            end
        case 2 %Single
            orderedOptions = cat(1, orderedOptions, singleOptions{singleIndex});
            singleIndex = singleIndex + 1;
            if (singleIndex > length(singleOptions))
                singleIndex = 1;
            end
        case 3 %Hetero
            orderedOptions = cat(1, orderedOptions, heteroOptions{heteroIndex});
            heteroIndex = heteroIndex + 1;
            if (heteroIndex > length(heteroOptions))
                heteroIndex = 1;
            end
        case 4 %Homo
            orderedOptions = cat(1, orderedOptions, heteroOptions{1});
            homoIndex = homoIndex + 1;
            if (homoIndex > length(homoOptions))
                homoIndex = 1;
            end
    end
end

%% Random Switching
    %Randomized sideswitching of the buttons to improve. Ints of 1 or 2. 1 is dont switch, 2 is switch.
    %Randomized for each options - Hetero, Homo, Single.
    %Note: Not truely random. Counterbalanced by splitting the switching
    %exactly in half for each set of options, then randperming.
    
    %Function to make these arrays
    function array = randSwitch(weightedArray, numb)
        switchLength = nnz(weightedArray==numb);
        %Make Even
        if mod(switchLength,2) == 1
          switchLength = switchLength + 1;
        end;
        %Fill Array
        switchFill(1:switchLength/2,1) = 0;
        switchFill(switchLength/2+1:switchLength,1) = 1;
        %Random Perm
        randOrder = randperm(switchLength);
        array = switchFill(randOrder,1);   
    end

    switchSingle = randSwitch(weightedArray, 2);
    switchHetero = randSwitch(weightedArray, 3);
    switchHomo = randSwitch(weightedArray, 4);

%% Saving the settings

% these are the same across all runs, so no need to save them under that run's name in the settings file
settings.recordfolder = 'records';
settings.subjID = subjID;
%options
settings.allOptions = options;
settings.orderedOptions = orderedOptions;
%arrays
settings.weightedArray = weightedArray;
settings.nullOptions = nullOptions;
settings.singleOptions = singleOptions;
settings.heteroOptions = heteroOptions;
settings.homoOptions = homoOptions;
settings.images = optionsImages;
settings.nullImage = grey;
%Randomized switching
settings.switchSingle = switchSingle;
settings.switchHetero = switchHetero;
settings.switchHomo = switchHomo;
settings.switchSingleCount = 1;
settings.switchHeteroCount = 1;
settings.switchHomoCount = 1;
% if the records folder doesn't exist, create it.
if settings.recordfolder
    mkdir(settings.recordfolder);
end
recordname = [settings.recordfolder '/' num2str(subjID) '_globalSettings' '.mat'];
% Save the settings (the results are saved later)
save (recordname, 'settings')
end
