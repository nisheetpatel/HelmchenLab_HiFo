%% This is the master function for getting all lick information
% Author: Nisheet   (npatel@student.ethz.ch or npatel@ini.uzh.ch)
%         Alternatively, contact Ariel Gilad (gilad@hifo.uzh.ch)

% Dependencies:
% Functions: TDMS (all), import_lick_data.m, licking_traces_per_condition.m
% Scripts  : fetch_vars4cue.m, calculating_reaction_time_for_licks.m, 
%            get_time.m, calc_time.m

% Returns  : licks, masterMat (trials), cues, reaction times for licks, and
%            some nice figures. 

% Note     : If you make any changes to the local copy of these functions
%           for yourself, please save them as separate versions. You may
%           need to do this in case if your data organization if different
%           from that of Ariel Gilad's, or if you need different plots or
%           want to save different variables or such.

% Pro-Tip  : For running this script on multiple folders, take a look at
%           the function autorun_lick_traces() :)

%% Begin
function lick_traces_reactime(thresh)
    %% Threshold
    % Input verification
    if length(thresh) ~= 2
        fprintf(2, 'Threshold must be a 1x2 vector: [bottom_threshold, top_threshold]. For example: [2.56, 2.65]');
        return
    end
    
    % Take threshold as input
    bot_thresh = thresh(1);
    top_thresh = thresh(2);
    
    %% Read TDMS files to extract lick traces
    licks = import_lick_data(); 
    
    %% Fetch time of the cue and licking conditions
    fetch_vars4cue;     % Generates cues and its parts with go/Nogo
                        % Note: cues is in absolute time (not subtracting baseline)
    
    %% Lick traces for all conditions (hit, miss, early, nogo...)
    licking_traces_conditional(licks, masterMat, cues, bot_thresh, top_thresh);
    
    %% Calculate reaction time for licks relative to the time of cue
    calculating_reaction_time_for_licks;
end

% Create 2 versions:
% 1. Runs on a single folder - this one. For this, create an autorun
%    example script that runs on multiple folders.
% 2. Runs on a bunch of folders with input taken as two vectors (folder
%    names and respective thresholds) or a struct

% Total hours: 2+4+4