function [] = generateOrder()
%HAVE DALTON SWITCH THE BIN

%Helpful Youtube link: https://www.youtube.com/watch?v=MIx_PN4FkKk
%for getting up to speed quickly

%%This script will generate the order of the events to be shown to the
%%participants

%IMPORTANT: Include a space at the beginning of every string except for the
%first one

%Path: Where the exec is located
execPath = '/usr/local/bin/optsec2';
%Number of time points in scan
ntp = ' --ntp 162';
%Time between volumes
tr = ' --tr 2';
%Least and Most time btw conditions
psdwin = ' --psdwin 0 20 .5';
%Events --You can add more, just add to the concat **DONT INCLUDE NULL**
eventOne = ' --ev single 4.5 18';
eventTwo = ' --ev homo 4.5 18';
eventThree = ' --ev hetero 4.5 18';
%Number of runs
nkeep = ' --nkeep 5';
%Outsteam
o = ' --o ex1';
%Nsearch
nsearch = ' --nsearch 10000';

%Concat strings into command string
command = strcat(execPath, ntp, tr, psdwin, eventOne, eventTwo, eventThree, nkeep, o, nsearch);

%Run command. This will create the necessary files in the directory
[status, output] = unix(command);
end


