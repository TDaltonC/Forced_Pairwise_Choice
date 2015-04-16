function [ output_args ] = runPrepedSubject( subjID, j, input)
%% Load Everything
recordfolder = 'records';
load([recordfolder '/' num2str(subjID) '_globalSettings' '.mat']);
items = settings.allItems;


controlConditionOrder1 = settings.controlConditionOrder1;
controlConditionOrder2 = settings.controlConditionOrder2;
scalingConditionOrder2 = settings.scalingConditionOrder2;
scalingConditionOrder3 = settings.scalingConditionOrder3;
scalingConditionOrder4 = settings.scalingConditionOrder4;
bundlingConditionOrder2 = settings.bundlingConditionOrder2;
bundlingConditionOrder3 = settings.bundlingConditionOrder3;
bundlingConditionOrder4 = settings.bundlingConditionOrder4;

Ncontrol1Set = settings.controlSet;
Ncontrol2Set = settings.control2Set;
Nscaling2Set = settings.scaling2Set;
Nscaling3Set = settings.scaling3Set;
Nscaling4Set = settings.scaling4Set;
Nbundling2Set = settings.bundling2Set;
Nbundling3Set = settings.bundling3Set; 
Nbundling4Set = settings.bundling4Set;

switch j
    case 1
        trialOrder = settings.trialOrder(1:88);
        settings.trialOrder = trialOrder;
    case 2
        trialOrder = settings.trialOrder(89:184);
        settings.trialOrder = trialOrder;
    case 3
        trialOrder = settings.trialOrder(185:279);
        settings.trialOrder = trialOrder;
    case 4
        trialOrder = settings.trialOrder(280:378);
        settings.trialOrder = trialOrder;
    case 5
        trialOrder = settings.trialOrder(379:474);
        settings.trialOrder = trialOrder;
end

%% Setting up the Run
load(strcat('Run',num2str(j),'.mat'));

%% Set up the screen
screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);

w = Screen('OpenWindow', screenNumber,[],[],[],[]);

% Display "Please wait. Do not touch anything"
drawStart(w);
Screen('Flip',w);
 
% James' code for scanner cue 
     key = 0;
while key ~= '5'
    [keyisdown, StartSecs, keycode] = KbCheck();
    if keyisdown
        key = KbName(keycode);  
    end
end 
UT = GetSecs;
settings.UT = UT;
% create the file name for this run of this subject
recordname = [settings.recordfolder '/' num2str(subjID) '_' num2str(j) '_' datestr(now,'yyyymmddTHHMMSS') '.mat'];
textFileName = [settings.recordfolder '/' num2str(subjID) '_' num2str(j) '_' datestr(now,'yyyymmddTHHMMSS') '.txt'];
% Save the settings (the results are saved later)
save (recordname, 'settings')
fileID = fopen(textFileName, 'w');


%%
long = length(trialOrder);

% Set all of the indeces equal to 1
i = 1;
controlIndex1 = 1;
controlIndex2 = 1;
scalingIndex2 = 1;
scalingIndex3 = 1;
scalingIndex4 = 1;
bundlingIndex2 = 1;
bundlingIndex3 = 1;
bundlingIndex4 = 1;

feedbackTime = 0.25;

whenTime = zeros(length(time),1);
for k = 1:(length(time))
    whenTime(k,1) = UT + 10 + time(k);
end

% whenTime(length(time)+1,1) = UT + j*10 + 324 + time(k);

RestrictKeysForKbCheck([30, 31, 32, 33]); % these are the keycodes for 1,2,3,4 on a Mac

while i <= long;
    switch trialOrder(i);
        case 1 %is for the NULL condition
            caseNumber = 1;
            setNumber = 0;
            drawFixation(w);
            
        case 2 %is for the CONTROL condition (1st half: 5 reps)
            caseNumber = 2;
            setNumber = controlConditionOrder1(controlIndex1);
            itemCode = Ncontrol1Set(controlConditionOrder1(controlIndex1));
            v1 = items{itemCode};
            v2 = items{itemCode};
            v3 = items{itemCode};
            v4 = items{itemCode};
            numberItems = 1; r = 0; s = 0;
            [r,s] = fourSquaresLogic(numberItems,r,s, v1, v2, v3, v4, w);
            settings.itemLocation(i,1:4) = r;
            settings.cueLocation(i,1:2) = s;
            controlIndex1 = controlIndex1  + 1;
            
    fprintf(fileID,'%d\t%d\t',caseNumber,setNumber);

    [VBLTimestamp, StimulusOnsetTime, FlipTimestamp] = Screen('Flip', w, whenTime(i,1));
    settings.VBLTimestamp(i) = VBLTimestamp;
    settings.StimulusOnsetTime(i) = StimulusOnsetTime;
    settings.FlipTimestamp(i) = FlipTimestamp;
    
    if trialOrder(i) == 1  % if the condition is the NULL condition (i.e. fixation cross), then show keep the fixation cross displayed for the amount of time, specified by variable "isi" -- an optseq output
        WaitSecs(isi(i))
        behavioral.secs(i) = whenTime(i,1)+isi(i);
    elseif trialOrder(i) > 1 % for all conditions except for the NULL, 
                             % keep display on screen until subject presses
                             % button or 4 seconds is up (whichever happens 
                             % first) and record button press in the former case   
        [behavioral.secs(i), keyCode, behavioral.deltaSecs(i)] = KbWait(-1,0,(whenTime(i,1)+4));
        if(strcmp(KbName(keyCode),'1!') || strcmp(KbName(keyCode),'2@')) && (s(1)==1);
            behavioral.key(i,1) = '1';
            behavioral.choice(i,1) = 'r';
            feedbackLogic('1',numberItems,r,s,v1,v2,v3,v4,w);
            Screen('Flip',w);
            drawFixation(w);
            Screen('Flip',w,behavioral.secs(i)+feedbackTime);
        elseif (strcmp(KbName(keyCode),'3#') || strcmp(KbName(keyCode),'4$')) && (s(1)==1);
            behavioral.key(i,1) = '3';
            behavioral.choice(i,1) = 'v';
            feedbackLogic('3',numberItems,r,s,v1,v2,v3,v4,w);            
            Screen('Flip',w);
            drawFixation(w);
            Screen('Flip',w,behavioral.secs(i)+feedbackTime);
        elseif (strcmp(KbName(keyCode),'1!') || strcmp(KbName(keyCode),'2@')) && (s(1)==2);
            behavioral.key(i,1) = '1';
            behavioral.choice(i,1) = 'v';
            feedbackLogic('1',numberItems,r,s,v1,v2,v3,v4,w);
            Screen('Flip',w);
            drawFixation(w);
            Screen('Flip',w,behavioral.secs(i)+feedbackTime);
        elseif (strcmp(KbName(keyCode),'3#') || strcmp(KbName(keyCode),'4$')) && (s(1)==2);
            behavioral.key(i,1) = '3';
            behavioral.choice(i,1) = 'r';
            feedbackLogic('3',numberItems,r,s,v1,v2,v3,v4,w);
            Screen('Flip',w);
            drawFixation(w);
            Screen('Flip',w,behavioral.secs(i)+feedbackTime);
        else
            drawFixation(w);
            Screen('Flip',w);
            behavioral.key(i,1) = 0;
            behavioral.choice(i,1) = 'n';
        end
        
    end
    fprintf(fileID,'%f\t%f\n',StimulusOnsetTime-UT, behavioral.secs(i)-StimulusOnsetTime);
    
    i = i + 1;
    
end

%% at the end
drawStop(w);
Screen('Flip',w);
save (recordname, 'settings');
save (recordname, 'behavioral', '-append');
fclose(fileID);
Screen('CloseAll');
clear all;