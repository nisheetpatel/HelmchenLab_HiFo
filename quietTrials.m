%% Reaction time for movement
% Author: Nisheet   (npatel@student.ethz.ch or npatel@ini.uzh.ch)
%         Alternatively, contact Ariel Gilad (gilad@hifo.uzh.ch)

% Description:
% Gives trials wherein the mouse was quiet before the cue and X ms after 
% the cue; by default X = post_cue_quiet_time = 300 ms (change as need be).

% Dependencies:
% 1. move_vectors_from_movie.mat or move_vectors_M2_start_forelimb_end.mat,
% 2. trials_ind.mat,
% 3. RT.mat & trials_data.mat, both produced by autorun_lick_traces()
%                                     or lick_traces_reactime()

%% Note to Ariel:
% trials_ind.mat is redundant. Could fetch the trials_100 and trials_1200 
% from masterMat and make code more efficient. However, that would require
% the first_move_in_delay.mat and also the move_vectors_from_movie.mat to 
% be in a different format.

%% Begin
function quietTrials()
    %% Skip useless folders while using autorunInWdataPerMouse
    if exist('trials_ind.mat','file') && exist('RT.mat','file') && ...
            (exist('move_vectors_from_movie.mat','file') || ...
            exist('move_vectors_M2_start_forelimb_end.mat','file'))

        %% Loading necessary files
        load('trials_ind.mat')                      % Mapping orignial trial numbers to 100/1200 trial number
        load('RT.mat','reactionTime_move_*');      % for RT_movement
        load('trials_data.mat','masterMat','cues'); % Fetching delay values

        %
        if ~exist('movie','var')
            movie = true;   % Whether we want to analyze data for sessions w/ movie
        end
        if ~exist('forelimb','var')
            forelimb = true; % Whether we want to analyze data for sessions w/o movie
        end

        % Loading Movement vectors (prefereably) from movie or calcium maps(forelimb)
        if (exist('move_vectors_from_movie.mat','file') && movie)
            load('move_vectors_from_movie.mat','roi_bod*')
            movemt100 = roi_bod_100;
            movemt1200= roi_bod_1200;
            tstep = 1/30;       % Movie taken at 30 Hz
        elseif (exist('move_vectors_M2_start_forelimb_end.mat','file') && forelimb)
            load('move_vectors_M2_start_forelimb_end.mat','move_vec*')
            movemt100 = move_vect_100_fl;
            movemt1200= move_vect_1200_fl;
            tstep = 0.05;       % Calcium maps at 20 Hz
        else
            fprintf(2,'No move vectors for: \n'); disp(pwd);
        end
        clear move_vec* roi_bod*  % clearing variables that we do not need


        %% Finding indices for trials in which mouse was quiet before cue
        orig_ind_quietB4zero_100 = find(reactionTime_move_100==0);
        orig_ind_quietB4zero_1200= find(reactionTime_move_1200==0);

        ind_quietB4zero_100 = [];   % Initializing
        ind_quietB4zero_1200= [];   % Initializing

        % Mapping to the new trial indices for 100 and 1200
        for ii=1:length(orig_ind_quietB4zero_100)
            ind_quietB4zero_100 = [ind_quietB4zero_100 find(tr_100==orig_ind_quietB4zero_100(ii))];
        end
        for ii=1:length(orig_ind_quietB4zero_1200)
            ind_quietB4zero_1200 = [ind_quietB4zero_1200 find(tr_1200==orig_ind_quietB4zero_1200(ii))];
        end
        clear orig_* ii tr_1* reaction_time_move_*   % clearing variables that we do not need


        %% Defining variables and vectors needed for finding trials_quiet_b4+after
        if ~exist('basel','var')
            basel = 3;  % Baseline = 3 seconds 
        end
        post_cue_quiet_time = 300;  % 300ms; time duration w/ no movement after cue
        if mean(cues)~=Inf
            cue = mean(cues) - basel;
        else
            notInf_ind = [];
            for ii=1:length(cues)
                if cues(ii)~=Inf
                    notInf_ind = [notInf_ind ii]; %#ok<AGROW>
                end
            end
            cue = mean(cues(notInf_ind)) - basel;
        end

        quiet_300_post_cue_100 = [];    % initializing vector for trial indices
        quiet_300_post_cue_1200 = [];    % initializing vector for trial indices
        tBehav = (1:length(movemt100))*tstep-basel;    % time vector

        cue_ind = find(tBehav-cue>0 & tBehav-cue<(post_cue_quiet_time/1000));


        %% Detecting the quiet_b4+after trials
        for ii=1:length(ind_quietB4zero_100)
            stdev100 = std(movemt100(2:length(movemt100),ind_quietB4zero_100(ii)));
            m100 = mean(movemt100(2:length(movemt100),ind_quietB4zero_100(ii)));
            if movemt100(cue_ind,ind_quietB4zero_100(ii))<(m100+(stdev100/2))
                quiet_300_post_cue_100 = [quiet_300_post_cue_100, ind_quietB4zero_100(ii)]; %#ok<AGROW>
            end
        end
        for ii=1:length(ind_quietB4zero_1200)
            stdev1200 = std(movemt1200(2:length(movemt1200),ind_quietB4zero_1200(ii)));
            m1200 = mean(movemt1200(2:length(movemt1200),ind_quietB4zero_1200(ii)));
            if movemt1200(cue_ind,ind_quietB4zero_1200(ii))<(m1200+(stdev1200/2))
                quiet_300_post_cue_1200 = [quiet_300_post_cue_1200, ind_quietB4zero_1200(ii)]; %#ok<AGROW>
            end
        end

        %% Plotting daily average
        f_movemt = figure();
        plot(tBehav,mean(movemt100(:,quiet_300_post_cue_100),2));hold on;
        plot(tBehav,mean(movemt1200(:,quiet_300_post_cue_1200),2),'r');
        yl = ylim;
        plot([cue cue],ylim,'k--')
        plot([cue+0.3 cue+0.3],ylim,'k--')
        xlabel('Time (s)')
        ylabel('Movement (roi-bod or move-vect)')
        legend('Texture P100','Texture P1200')
        saveas(f_movemt,'roiBod_averageForQuietTrialsB4andAfterCue.png')
        % close(f_movemt)
        clear basel go i ii ind* m100 move* st* y*


        %% Saving shit
        tr_1200_quiet_response = quiet_300_post_cue_1200;
        tr_100_quiet_response = quiet_300_post_cue_100;
        clear quiet*

        if exist(['trial_quiet_response_B4and' num2str(post_cue_quiet_time) 'msAfterCue.mat'],'file')
            save(['trial_quiet_response_B4and' num2str(post_cue_quiet_time) 'msAfterCue.mat'],'tr_100_quiet_response','tr_1200_quiet_response','cue','tBehav','tstep','-append')
        else
            save(['trial_quiet_response_B4and' num2str(post_cue_quiet_time) 'msAfterCue.mat'],'tr_100_quiet_response','tr_1200_quiet_response','cue','tBehav','tstep')
        end

    end
end