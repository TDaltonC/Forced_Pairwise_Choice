function [ output_args ] = feedbackLogic( key,numberItems,r,s,v1,v2,v3,v4,w)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
 
screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);

%% These are all of the position constants
centerw = width/2;  % This is the center width of the screen
centerh = height/2; % The center of the height of the screen
%eccen =   150;      % This is the eccentricity. Distance from the center to the right edge of the array
itemw =   70;       % The width of one item in the array
itemh =   70;       % The height of one item in the array
gutterw = 20;       % The height of the gutters between the items
gutterh = 20;       % The height of the gutters between the items


if key == '1'
    feedbackPosition = 1;
elseif key == '3'
    feedbackPosition = 2;
end

pwCueL1 = centerw - 3*gutterw;
pwCueL2 = centerw - 1*gutterw;
pwCueR1 = centerw + 1*gutterw;
pwCueR2 = centerw + 3*gutterw;

phCue1 = centerh + 3*itemh;
phCue2 = phCue1 + 2*gutterw;

pwCue1 = [pwCueL1, pwCueR1];
pwCue2 = [pwCueL2, pwCueR2];
phCue1 = [phCue1, phCue1];
phCue2 = [phCue2, phCue2];

feedbackRect = [pwCue1(feedbackPosition),phCue1(feedbackPosition),...
    pwCue2(feedbackPosition),phCue2(feedbackPosition)];

Screen('FrameRect', w,0,feedbackRect,2);

fourSquaresLogic(numberItems,r,s,v1,v2,v3,v4,w);


end

