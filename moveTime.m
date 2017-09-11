%% Reaction time for movement
% Author: Nisheet   (npatel@student.ethz.ch or npatel@ini.uzh.ch)
%         Alternatively, contact Ariel Gilad (gilad@hifo.uzh.ch)

% Description:
% Calculates reaction time for movement

% Dependencies:
% 1. first_move_in_delay.mat or first_move_in_delay_forelimb_m2.mat,
% 2. trials_ind.mat,
% 3. RT.mat & trials_data.mat - cues, both produced by autorun_lick_traces()
%                                     or lick_traces_reactime()

%% Note to Ariel:
% trials_ind.mat is redundant. Could fetch the trials_100 and trials_1200 
% from masterMat and make code more efficient. However, that would require
% the first_move_in_delay to be in a different format too.

%% Begin
function moveTime()
    if exist('trials_data.mat','file') && exist('RT.mat','file')
        load('trials_data.mat','masterMat','cues');
        load('RT.mat','reactionTime_licks_go');
        reaction_time = reactionTime_licks_go;
        
        if exist('trials_ind.mat','file') && ...
                (exist('first_move_in_delay.mat','file') || ...
                exist('first_move_in_delay_forelimb_m2.mat','file'))
            load('trials_ind.mat');
            try
                load('first_move_in_delay.mat');
            catch 
                load('first_move_in_delay_forelimb_m2.mat');
            end
            
            %% Actual code
            timeVec = (1:270)*0.05;
            j=0; k=0;
            
            reactionTime_move_100 = NaN*ones(size(reaction_time));
            reactionTime_move_1200 = NaN*ones(size(reaction_time));
            for i=1:length(reaction_time)
                if any(tr_1200==i)
                        k=k+1;
                        reactionTime_move_1200(i) = timeVec(first_move_1200_delay(k)) - cues(tr_1200(k));
                elseif any(tr_100==i)
                        j=j+1;
                        reactionTime_move_100(i) = timeVec(first_move_100_delay(j)) - cues(tr_100(j));
                end
            end
            reactionTime_move_100(reactionTime_move_100>0)=0;     %when the mouse did not move
            reactionTime_move_1200(reactionTime_move_1200>0)=0; %#ok<*NASGU>
            %
            
            %% Checking which condition is go from masterMat
            for ii=1:length(masterMat)
                t = masterMat(ii).texture;
                d = masterMat(ii).decision;
                if strfind(t,'100') && strcmp(d,'Go')
                    reactionTime_move_go   = reactionTime_move_100;
                    reactionTime_move_nogo = reactionTime_move_1200;
                    break
                elseif strfind(t,'100') && strcmp(d,'No Go')
                    reactionTime_move_go   = reactionTime_move_1200;
                    reactionTime_move_nogo = reactionTime_move_100;
                    break
                end
            end
            
            %% Saving and plotting
            save('RT','reactionTime_move_go','reactionTime_move_nogo','-append');
            save('RT','reactionTime_move_100','reactionTime_move_1200','-append');
            f=stem(reactionTime_move_go,'ro');
            hold on
            stem(reaction_time,'*'); xlim([0 length(reaction_time)]); hold off;
                    xlabel('Trial Number')
                    ylabel('Time (s)')
                    legend('Move Time','Lick Time') %(forelimb/m2)
                    saveas(f,'RT_plot','png')
            %}
        
        else             
            fprintf(2,'Missing trials_ind.mat or ');
            fprintf(2,'missing first_move_in_delay.mat and first_move');
            fprintf(2,'_in_delay_forelimb_m2.mat for this directory: \n');
            disp(pwd);
        end
    else
        fprintf(2,'Missing RT.mat or trials_data.mat. Please run ');
        fprintf(2,'autorun_lick_traces() or lick_traces_reactime() first \n');
        disp(pwd);
    end
end