function [ r,s ] = fourSquaresLogic(numberItems,r,s,itema,itemb,itemc,itemd, w)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

screenNumber = max(Screen('Screens'));
[width height] = Screen('WindowSize', screenNumber);

if r == 0;
    r = randperm(4);
end

if s == 0;
    s = randperm(2);
end

grey = imread('grey.jpg');
greyt = Screen('MakeTexture',w,grey);

itemat = Screen('MakeTexture',w,itema);
itembt = Screen('MakeTexture',w,itemb); 
itemct = Screen('MakeTexture',w,itemc); 
itemdt = Screen('MakeTexture',w,itemd); 

%% These are all of the position constants
centerw = width/2;  % This is the center width of the screen
centerh = height/2; % The center of the height of the screen
%eccen =   150;      % This is the eccentricity. Distance from the center to the right edge of the array
itemw =   70;       % The width of one item in the array
itemh =   70;       % The height of one item in the array
gutterw = 20;       % The height of the gutters between the items
gutterh = 20;       % The height of the gutters between the items

% item position coordinates
position1 = r(1);
position2 = r(2);
position3 = r(3);
position4 = r(4);

pwL1 = centerw - 0.5*gutterw - itemw;
pwL2 = centerw - 0.5*gutterw;
pwR1 = centerw + 0.5*gutterw;
pwR2 = centerw + 0.5*gutterw + itemw;

phD1 = centerh - 0.5*gutterh - itemh;
phD2 = centerh - 0.5*gutterh;
phU1 = centerh + 0.5*gutterh;
phU2 = centerh + 0.5*gutterh + itemh;

pw1 = [pwL1, pwL1, pwR1, pwR1];
pw2 = [pwL2, pwL2, pwR2, pwR2];
ph1 = [phU1, phD1, phU1, phD1];
ph2 = [phU2, phD2, phU2, phD2];


% response cue position coordinates
positionCue1 = s(1);
positionCue2 = s(2);

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

solidCircleRect = [pwCue1(positionCue1),phCue1(positionCue1),...
    pwCue2(positionCue1),phCue2(positionCue1)];

frameCircleRect = [pwCue1(positionCue2),phCue1(positionCue2),...
    pwCue2(positionCue2),phCue2(positionCue2)];

black = 0;
Screen('FillOval',w,black,solidCircleRect);

Screen('FrameOval',w,black,frameCircleRect,2); %pen width is 2

% These are here so that the cat()'s will have something to grab on to.

    draw = [];
    leftPositions = [];
    topPositions = [];
    rightPositions = [];
    bottomPositions = [];

if numberItems >= 1;
    draw = cat(1,draw,itemat);
    leftPositions = cat(2,leftPositions,    pw1(position1));
    topPositions = cat(2,topPositions,       ph1(position1)); 
    rightPositions = cat(2,rightPositions,  pw2(position1));
    bottomPositions = cat(2,bottomPositions, ph2(position1));
end

if numberItems >= 2;
    draw = cat(1,draw,itembt);
    leftPositions = cat(2,leftPositions,    pw1(position2));
    topPositions = cat(2,topPositions,       ph1(position2)); 
    rightPositions = cat(2,rightPositions,  pw2(position2));
    bottomPositions = cat(2,bottomPositions, ph2(position2));
end

if numberItems >= 3;
    draw = cat(1,draw,itemct);
    leftPositions = cat(2,leftPositions,    pw1(position3));
    topPositions = cat(2,topPositions,       ph1(position3)); 
    rightPositions = cat(2,rightPositions,  pw2(position3));
    bottomPositions = cat(2,bottomPositions, ph2(position3));
end

if numberItems == 4;
    draw = cat(1,draw,itemdt);
    leftPositions = cat(2,leftPositions,    pw1(position4));
    topPositions = cat(2,topPositions,       ph1(position4)); 
    rightPositions = cat(2,rightPositions,  pw2(position4));
    bottomPositions = cat(2,bottomPositions, ph2(position4));
end

%Greys
if numberItems < 2;  
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pw1(position2));
    topPositions = cat(2,topPositions,       ph1(position2)); 
    rightPositions = cat(2,rightPositions,  pw2(position2));
    bottomPositions = cat(2,bottomPositions, ph2(position2));
end

if numberItems < 3;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pw1(position3));
    topPositions = cat(2,topPositions,       ph1(position3)); 
    rightPositions = cat(2,rightPositions,  pw2(position3));
    bottomPositions = cat(2,bottomPositions, ph2(position3));
end

if numberItems < 4;
    draw = cat(1,draw,greyt);
    leftPositions = cat(2,leftPositions,    pw1(position4));
    topPositions = cat(2,topPositions,       ph1(position4)); 
    rightPositions = cat(2,rightPositions,  pw2(position4));
    bottomPositions = cat(2,bottomPositions, ph2(position4));
end
   

v = cat(1,leftPositions,topPositions,rightPositions,bottomPositions);
Screen('DrawTextures',w,draw,[],v);



end

