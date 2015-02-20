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
            
        
        case 3 %is for the CONTROL condition (2nd half: 4 reps)
            caseNumber = 3;
            setNumber = controlConditionOrder2(controlIndex2);
            itemCode = Ncontrol2Set(controlConditionOrder2(controlIndex2));
            v1 = items{itemCode};
            v2 = items{itemCode};
            v3 = items{itemCode};
            v4 = items{itemCode};
            numberItems = 1; r = 0; s = 0;
            [r,s] = fourSquaresLogic(numberItems,r,s, v1, v2, v3, v4, w);
            settings.itemLocation(i,1:4) = r;
            settings.cueLocation(i,1:2) = s;
            controlIndex2 = controlIndex2  + 1;

        case 4 %is for the SCALING by 2 condition
            caseNumber = 4;
            setNumber = scalingConditionOrder2(scalingIndex2);
            itemCode = Nscaling2Set(scalingConditionOrder2(scalingIndex2),1);
            v1 = items{itemCode};
            v2 = items{itemCode};
            v3 = items{itemCode};
            v4 = items{itemCode};
            numberItems = 2; r = 0; s = 0;
            [r,s] = fourSquaresLogic(numberItems,r,s, v1, v2, v3, v4, w);
            settings.itemLocation(i,1:4) = r;
            settings.cueLocation(i,1:2) = s;
            scalingIndex2 = scalingIndex2  + 1;
        
        case 5 %is for the SCALING by 3 condition
            caseNumber = 5;
            setNumber = scalingConditionOrder3(scalingIndex3);
            itemCode = Nscaling3Set(scalingConditionOrder3(scalingIndex3),1);
            v1 = items{itemCode};
            v2 = items{itemCode};
            v3 = items{itemCode};
            v4 = items{itemCode};
            numberItems = 3; r = 0; s = 0;
            [r,s] = fourSquaresLogic(numberItems,r,s, v1, v2, v3, v4, w);
            settings.itemLocation(i,1:4) = r;
            settings.cueLocation(i,1:2) = s;
            scalingIndex3 = scalingIndex3 + 1;
        
        case 6 %is for the SCALING by 4 condition
            caseNumber = 6;
            setNumber = scalingConditionOrder4(scalingIndex4);
            itemCode = Nscaling4Set(scalingConditionOrder4(scalingIndex4),1);
            v1 = items{itemCode};
            v2 = items{itemCode};
            v3 = items{itemCode};
            v4 = items{itemCode};
            numberItems = 4; r = 0; s = 0;
            [r,s] =fourSquaresLogic(numberItems,r,s, v1, v2, v3, v4, w);
            settings.itemLocation(i,1:4) = r;
            settings.cueLocation(i,1:2) = s;
            scalingIndex4 = scalingIndex4  + 1;
        
        case 7 %is for the BUNDLING by 2 condition
            caseNumber = 7;
            setNumber = bundlingConditionOrder2(bundlingIndex2);
            itemCode1 = Nbundling2Set(bundlingConditionOrder2(bundlingIndex2),1);
            itemCode2 = Nbundling2Set(bundlingConditionOrder2(bundlingIndex2),2);
            v1 = items{itemCode1};
            v2 = items{itemCode2};
            v3 = items{itemCode1};
            v4 = items{itemCode2};
            numberItems = 2; r = 0; s = 0;
            [r,s] = fourSquaresLogic(numberItems,r,s, v1, v2, v3, v4, w);
            settings.itemLocation(i,1:4) = r;
            settings.cueLocation(i,1:2) = s;
            bundlingIndex2 = bundlingIndex2 + 1;
        
        case 8 %is for the BUNDLING by 3 condition
            caseNumber = 8;
            setNumber = bundlingConditionOrder3(bundlingIndex3);
            itemCode1 = Nbundling3Set(bundlingConditionOrder3(bundlingIndex3),1);
            itemCode2 = Nbundling3Set(bundlingConditionOrder3(bundlingIndex3),2);
            itemCode3 = Nbundling3Set(bundlingConditionOrder3(bundlingIndex3),3);
            v1 = items{itemCode1};
            v2 = items{itemCode2};
            v3 = items{itemCode3};
            v4 = items{itemCode1};
            numberItems = 3; r = 0; s = 0;
            [r,s] = fourSquaresLogic(numberItems,r,s, v1, v2, v3, v4, w);
            settings.itemLocation(i,1:4) = r;
            settings.cueLocation(i,1:2) = s;
            bundlingIndex3 = bundlingIndex3 + 1;
        
        case 9 %is for the BUNDLING by 4 condition
            caseNumber = 9;
            setNumber = bundlingConditionOrder4(bundlingIndex4);
            itemCode1 = Nbundling4Set(bundlingConditionOrder4(bundlingIndex4),1);
            itemCode2 = Nbundling4Set(bundlingConditionOrder4(bundlingIndex4),2);
            itemCode3 = Nbundling4Set(bundlingConditionOrder4(bundlingIndex4),3);
            itemCode4 = Nbundling4Set(bundlingConditionOrder4(bundlingIndex4),4);
            v1 = items{itemCode1};
            v2 = items{itemCode2};
            v3 = items{itemCode3};
            v4 = items{itemCode4};
            numberItems = 4; r = 0; s = 0;
            [r,s] = fourSquaresLogic(numberItems,r,s, v1, v2, v3, v4, w);
            settings.itemLocation(i,1:4) = r;
            settings.cueLocation(i,1:2) = s;
            bundlingIndex4 = bundlingIndex4 + 1;
    end
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