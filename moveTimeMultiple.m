%% Reaction time for movement
% Author: Nisheet   (npatel@student.ethz.ch or npatel@ini.uzh.ch)
%         Alternatively, contact Ariel Gilad (gilad@hifo.uzh.ch)

% Description:
% Calculates reaction time for movement for multiple folders IFF the
% organization of the folders is similar to
% W:/Neurophysiology-Storage1/Gilad/Data_per_mouse

% Dependencies:
% 0. moveTime(), which depends on:
% 1. first_move_in_delay.mat or first_move_in_delay_forelimb_m2.mat,
% 2. trials_ind.mat,
% 3. RT.mat & trials_data.mat - cues, both produced by autorun_lick_traces()
%                                     or lick_traces_reactime()

%% Begin
function moveTimeMultiple()
    currentDir = pwd; go=0;
    cd(currentDir)
    fListOut = dir();
    for j=3:length(fListOut)
        temp = fListOut(j).name;
        if strcmp(temp(1:3),'201')
            cd(temp);
            folderList = dir();
            for i=3:length(folderList)
                if length(folderList(i).name)==1
                    try                                 %#ok<TRYNC>
                        cd(folderList(i).name); go=1;
                    end
                    if go==1
                        go=0;
                        moveTime()
                        cd ..
                    end
                end
            end
            clear tr_*
            cd ..
        end
    end
end