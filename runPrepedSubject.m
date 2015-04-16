function [ output_args ] = runPrepedSubject( subjID, j, input)
%% Load Everything

if exist('subjID','var') == 0;
    subjID = 1;
end

if exist('j','var') == 0;
    j = 1;
end

recordfolder = 'records';
load([recordfolder '/' num2str(subjID) '_globalSettings' '.mat']);
itemImages = settings.images;

switch j
    case 1
        trialOrder = settings.orderedOptions{1:88};
        settings.trialOrder = trialOrder;
    case 2
        trialOrder = settings.orderedOptions{89:184};
        settings.trialOrder = trialOrder;
    case 3
        trialOrder = settings.orderedOptions{185:279};
        settings.trialOrder = trialOrder;
    case 4
        trialOrder = settings.orderedOptions{280:378};
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


%%Run Trials
trialLength = length(trialOrder);


% Set all of the indeces equal to 1
i = 1;

feedbackTime = 0.25;

whenTime = zeros(length(time),1);
for k = 1:(length(time))
    whenTime(k,1) = UT + 10 + time(k);
end

% whenTime(length(time)+1,1) = UT + j*10 + 324 + time(k);

RestrictKeysForKbCheck([30, 31, 32, 33]); % these are the keycodes for 1,2,3,4 on a Mac

while i <= trialLength;
    top = trialOrder{i}(1);
    bottom = trialOrder{i}(2);
    fourSquaresLogic(top,bottom,0, w);

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
            feedbackLogic('1',top, bottom, 0,w);
            Screen('Flip',w);
            drawFixation(w);
            Screen('Flip',w,behavioral.secs(i)+feedbackTime);
        elseif (strcmp(KbName(keyCode),'3#') || strcmp(KbName(keyCode),'4$')) && (s(1)==1);
            behavioral.key(i,1) = '3';
            behavioral.choice(i,1) = 'v';
            feedbackLogic('3',top, bottom, 0,w);            
            Screen('Flip',w);
            drawFixation(w);
            Screen('Flip',w,behavioral.secs(i)+feedbackTime);
        elseif (strcmp(KbName(keyCode),'1!') || strcmp(KbName(keyCode),'2@')) && (s(1)==2);
            behavioral.key(i,1) = '1';
            behavioral.choice(i,1) = 'v';
            feedbackLogic('1',top, bottom, 0,w);
            Screen('Flip',w);
            drawFixation(w);
            Screen('Flip',w,behavioral.secs(i)+feedbackTime);
        elseif (strcmp(KbName(keyCode),'3#') || strcmp(KbName(keyCode),'4$')) && (s(1)==2);
            behavioral.key(i,1) = '3';
            behavioral.choice(i,1) = 'r';
            feedbackLogic('3',top, bottom, 0,w);
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