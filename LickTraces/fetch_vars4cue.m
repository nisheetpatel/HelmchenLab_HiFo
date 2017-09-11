
%% Fetching presentation, stimulus and delay time from txt log file
% Author: Unknown (adapted and commented by Nisheet)

% Dependencies: This script calls one or more of the TDMS sub-functions, & 
% also the scripts 'calc_time.m' and 'get_time.m'. Make sure that those are 
% added to the path in order for this script to run without errors.

% Returns: This script returns the time up to presentation, duration of the
% stimulus and the delay time.

% CAUTION! This script may fail if there are text files in the behavior 
% folder other than the one with the trial logs. Please either remove all 
% other unnecessary text files from the folder, or create an exception in
% the first section of the code where the 'filename' is assigned.

%% Begin
%% Keeping track of variables created by this script to delete them later
vars_before = who;

%% Changing to directory with the TXT and TDMS files
% cd behavior/          Not needed

%% Fetching name of the txt file
currentDir = dir(pwd);
for j=3:length(currentDir)
    if strfind(currentDir(j).name,'.txt') > 2  % 1-character filenames disallowed
        filename = currentDir(j).name;
        break;
    end
end

%% Reading the text file; separated by columns
contents = tdfread([filename]); %#ok<NBRAK>
Event = cellstr(contents.Event);
Time = cellstr(contents.Time);
Trial = contents.Trial;
Date = contents.Date;

a = size(Event);
a = a(1);
id = 1;
trials = [];

for i = 1:a
    % Beginning of the trial
    if strcmp(Event(i),'Begin Trial / Recording') 
        trial.id        = id;
        trial.no        = Trial(i);
        trial.texture   = '';       % initializing for trial
        trial.decision  = '';       % initializing for trial
        time = Time{i};
        start_time = get_time(time);

    % Stimulus
    elseif strfind(Event{i},'Stimulus') == 1
        time = Time{i};
        stimulus_time = get_time(time);

    % Delay
    elseif strfind(Event{i},'Delay') == 1 
        time = Time{i};
        delay_time = get_time(time);
        %trial.delay_time = calc_time(delay_time, start_time);

    % Report
    elseif strfind(Event{i},'Report') == 1 
        time = Time{i};
        report_time = get_time(time);
        
    % Marking the type of trial: Go, No Go, Inapt. Resp. or Early
    elseif strfind(Event{i},'Go') == 1
        trial.decision = Event{i};
    elseif strfind(Event{i}, 'No Go') == 1
        trial.decision = Event{i};
    elseif strfind(Event{i}, 'Inappropriate Response') == 1
        trial.decision = Event{i};
    elseif strfind(Event{i},'Early') == 1
        trial.decision = Event{i};
    elseif strfind(Event{i}, 'No Response') == 1
        trial.decision = Event{i};
        
    % Getting texture type
    elseif strfind(Event{i}, 'Texture')
        trial.texture = Event{i};
        
    % Calculating the relative times:
    elseif strcmp(Event(i),'End Trial')
        trial.begin     = calc_time(stimulus_time, start_time);
        trial.stimulus  = calc_time(delay_time, stimulus_time); 
        trial.delay     = calc_time(report_time, delay_time);   % If there is no delay, change this to (report_time - stimulus_time)
        id = id + 1;
        if (trial.delay<0)
            try 
                trial.delay = trials(length(trials)).delay;
            catch
                trial.delay = NaN;
            end
        elseif (trial.delay > 5e3)
            trial.delay = inf;  % Trial did not end
        end
        if ~isfield(trial,'decision')
            trial.decision = '';
        end
        trials = [trials; trial]; %#ok<AGROW>
    end
end

%% Back to parent directory
% cd ..         Not needed

%% Deleting unwanted variables created by the script
vars_after  = [];
vars_new    = [];
vars_after  = who;
masterMat   = trials;
cues        = (([masterMat.begin]+[masterMat.stimulus]+[masterMat.delay])/1000)';
vars_new    = setdiff(vars_after,vars_before);
clear(vars_new{:})

%% Saving variables
save('trials_data')

%% How to use the mean values of begin/stimulus/delay for a day, if need be
% First, check if the standard deviation is relatively small.
% average_time_till_cueToLickForReward = ...
% mean([cue_parts.begin]+[cue_parts.stimulus]+[cue_parts.delay])
% Average delay time: mean([cue_parts.delay])
% Std dev. for delay times: std([cue_parts.delay])