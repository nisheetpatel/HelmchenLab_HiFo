%% Calculating the Reaction Time for licks
% Author: Nisheet (adapted and commented by Nisheet)

% Dependencies: This script needs the variables licks - created by 
% import_lick_data, masterMat & cues - created by fetch_vars4cue.m, and
% variables bot_thresh and top_thresh input by the user. Best used as part
% of lick_traces_reactime.m

% Returns: This script calculates the licking reaction time for all trials
% and classifies go and nogo trials separately too. Furthermore, it plots
% and saves a stem of the reaction times in the go cases.

%% Keeping track of variables created by this script to delete them later
vars_before = who;

%% Initializing
reactionTime_licks_all  = NaN*ones(size(masterMat));   % initializing
reactionTime_licks_go   = NaN*ones(size(masterMat));   % initializing
reactionTime_licks_nogo = NaN*ones(size(masterMat));   % initializing

%% Calculating reaction times
for k=1:length(masterMat)
    lick_trial = licks(k).lick_vector;
    lick_trial = lick_trial(1,:);
    index = find(lick_trial>=top_thresh | lick_trial<=bot_thresh); %index is time*100
    for jj=1:length(index)
        if index(jj)/100 > cues(k) % TimeOfCueInSeconds
            reactionTime_licks_all(k) = index(jj)/100 - cues(k);
            break     % Records the first instance when threshold exceeds after cues(k)
        end
    end
    if strfind(masterMat(k).decision,'Go') == 1
        reactionTime_licks_go(k) = reactionTime_licks_all(k);
    elseif strfind(masterMat(k).decision,'No Go') == 1
        reactionTime_licks_nogo(k) = reactionTime_licks_all(k);
    end
end

%% Saving and plotting
save('RT','reactionTime_licks*')
f = figure();
fname = 'reactionTimes_licks';
stem(reactionTime_licks_go,'*'); xlim([0 length(masterMat)]);
xlabel('Trial Number')
ylabel('Time (s)')
saveas(f,fname,'png')
%close(f)
%}

%% Deleting unwanted variables created by the script
% Uncomment if variables not needed in the workspace
% vars_after  = [];
% vars_new    = [];
% vars_after  = who;
% vars_new    = setdiff(vars_after,vars_before);
% clear(vars_new{:})