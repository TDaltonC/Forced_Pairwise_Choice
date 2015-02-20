function [ output_args ] = prepSubject( subjID, item1c, item2c, item3c,...
    item4c, item5c, item6c, item7c, item8c, item9c, item10c, item11c, item12c, ...
    item13c, item14c, item15c, item16c, item17c, item18c, item19c, item20c, ...
    item21c,input)
%% If not running on actual subject, use the following to test out script
% item1c = 1; item2c = 2; item3c = 3;
% item4c = 4; item5c = 5; item6c = 6;
% item7c = 7; item8c = 8; item9c = 9;
% item10c = 10; item11c = 11; item12c = 12;
% item13c = 13; item14c = 14; item15c= 15;
% item16c = 16; item17c= 17; item18c = 18;
% item19c = 19; item20c = 20; item21c = 21;
%% Settings
runs = 5;
trialsPerRun = 72; %Including Nulls
% Default for subjID is 1. This only kicks in iff no subject ID is given.
if exist('subjID','var') == 0;
    subjID = 1;
end
if exist('input','var') == 0;
    input = 'k';
end

%% Items

items = [item1c item2c item3c item4c item5c item6c item7c item8c item9c item10c ...
    item11c item12c item13c item14c item15c item16c item17c item18c item19c ...
    item20c item21c];

for i = 1:21;
    v = genvarname(strcat('item', num2str(i)));
    eval([v '= imread(strcat(''Image'', num2str(items(i)), ''.jpg''));']);
end

items = {item1 item2 item3 item4 item5 item6 item7 item8 item9 item10 ...
    item11 item12 item13 item14 item15 item16 item17 item18 item19 ...
    item20 item21};


%% Load all of the task lists
load('Ncontrol1Set.mat');
load('Ncontrol2Set.mat');
load('Nscaling2Set.mat');
load('Nscaling3Set.mat'); 
load('Nscaling4Set.mat'); 
load('Nbundling2Set.mat'); 
load('Nbundling3Set.mat'); 
load('Nbundling4Set.mat'); 

%% **Design the task orders**
% numberRuns = 5; %we will be doing 5 unique runs, totalling 270 trials of three different conditions: CONTROL, SCALING, and BUNDLING (as well as NULL)
cIndex = 1;
sIndex = 1;
bIndex = 1;


%%
control1 = 2*(ones(1,50));  % later referred to as "case 2"
control2 = 3*(ones(1,40));  % later referred to as "case 3"
control1and2 = cat(2,control1, control2); 
controlConditionOrder = Shuffle(control1and2); 

scaling2 = 4*(ones(1,30));  % later referred to as "case 4"
scaling3 = 5*(ones(1,30));  % later referred to as "case 5"
scaling4 = 6*(ones(1,30));  % later referred to as "case 6"
scaling2and3and4 = cat(2,scaling2,scaling3,scaling4);
scalingConditionOrder = Shuffle(scaling2and3and4);

bundling2 = 7*ones(1,30);   % later referred to as "case 7"
bundling3 = 8*(ones(1,30)); % later referred to as "case 8"
bundling4 = 9*(ones(1,30)); % later referred to as "case 9"
bundling2and3and4 = cat(2,bundling2,bundling3,bundling4);
bundlingConditionOrder = Shuffle(bundling2and3and4);


controlConditionOrder1 = [];
i = 1;
while i < 6;
    controlConditionOrder1 = cat(2,controlConditionOrder1,randperm(length(Ncontrol1Set)));
    i = i + 1;
end

controlConditionOrder2 = [];
i = 1;
while i < 5; 
    controlConditionOrder2 = cat(2,controlConditionOrder2,randperm(length(Ncontrol2Set)));
    i = i + 1;
end

scalingConditionOrder2 = [];
i = 1;
while i < 4;
    scalingConditionOrder2 = cat(2,scalingConditionOrder2,randperm(length(Nscaling2Set)));
    i = i + 1;
end

scalingConditionOrder3 = [];
i = 1;
while i < 4;
    scalingConditionOrder3 = cat(2,scalingConditionOrder3,randperm(length(Nscaling3Set)));
    i = i + 1;
end

scalingConditionOrder4 = [];
i = 1;
while i < 4;
    scalingConditionOrder4 = cat(2,scalingConditionOrder4,randperm(length(Nscaling4Set)));
    i = i + 1;
end

bundlingConditionOrder2 = [];
i = 1;
while i < 4;
    bundlingConditionOrder2 = cat(2,bundlingConditionOrder2,randperm(length(Nbundling2Set)));
    i = i + 1;
end

bundlingConditionOrder3 = [];
i = 1;
while i < 4;
    bundlingConditionOrder3 = cat(2,bundlingConditionOrder3,randperm(length(Nbundling3Set)));
    i = i + 1;
end

bundlingConditionOrder4 = [];
i = 1;
while i < 4;
    bundlingConditionOrder4 = cat(2,bundlingConditionOrder4,randperm(length(Nbundling4Set)));
    i = i + 1;
end
longCondition = [];
for j = 1:5
    load(strcat('Run',num2str(j),'.mat'));
    longCondition = cat(1,longCondition,condition);
end


trialOrder = zeros(1,length(longCondition));

for i = 1:length(trialOrder);
    if longCondition(i) == 0
            trialOrder(i) = 1;
    end
    if longCondition(i) == 1
            trialOrder(i) = controlConditionOrder(cIndex);
            cIndex = cIndex + 1;
    end
    if longCondition(i) == 2
            trialOrder(i) = scalingConditionOrder(sIndex);
            sIndex = sIndex + 1;
    end
    if longCondition(i) == 3
            trialOrder(i) = bundlingConditionOrder(bIndex);
            bIndex = bIndex + 1;
    end
end

%% Saving the settings

% these are the same across all runs, so no need to save them under that run's name in the settings file
settings.recordfolder = 'records';
settings.subjID = subjID;
settings.allItems = items;
settings.items.item1 = items{1}; settings.items.item2 = items{2};
settings.items.item3 = items{3}; settings.items.item4 = items{4};
settings.items.item5 = items{5}; settings.items.item6 = items{6};
settings.items.item7 = items{7}; settings.items.item8 = items{8};
settings.items.item9 = items{9}; settings.items.item10 = items{10};
settings.items.item11 = items{11}; settings.items.item12 = items{12};
settings.items.item13 = items{13}; settings.items.item14 = items{14};
settings.items.item15 = items{15}; settings.items.item16 = items{16};
settings.items.item17 = items{17}; settings.items.item18 = items{18};
settings.items.item19 = items{19}; settings.items.item20 = items{20};
settings.items.item21 = items{21};
settings.controlConditionOrder1 = controlConditionOrder1;
settings.controlConditionOrder2 = controlConditionOrder2;
settings.scalingConditionOrder2 = scalingConditionOrder2;
settings.scalingConditionOrder3 = scalingConditionOrder3;
settings.scalingConditionOrder4 = scalingConditionOrder4;
settings.bundlingConditionOrder2 = bundlingConditionOrder2;
settings.bundlingConditionOrder3 = bundlingConditionOrder3;
settings.bundlingConditionOrder4 = bundlingConditionOrder4;
settings.controlSet = Ncontrol1Set;
settings.control2Set = Ncontrol2Set;
settings.scaling2Set = Nscaling2Set;
settings.scaling3Set = Nscaling3Set;
settings.scaling4Set = Nscaling4Set;
settings.bundling2Set = Nbundling2Set;
settings.bundling3Set = Nbundling3Set; 
settings.bundling4Set = Nbundling4Set;
settings.trialOrder   = trialOrder;

recordname = [settings.recordfolder '/' num2str(subjID) '_globalSettings' '.mat'];
% Save the settings (the results are saved later)
save (recordname, 'settings')

