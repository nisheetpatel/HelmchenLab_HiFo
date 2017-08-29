%% This is the master function for getting all lick information
% Author: Nisheet   (npatel@student.ethz.ch or npatel@ini.uzh.ch)
%         Alternatively, contact Ariel Gilad (gilad@hifo.uzh.ch)

% Description:
% Runs lick_traces_reactime() over multiple folders with the specific dates
% and thresholds that one inputs.

% Input Parameters:
% For the current version of the function, the input dates must be a cell 
% array and thresholds must be a matrix. Change the script if you want to
% input them alternatively, for instance, as a struct.

%% Begin
function autorun_lick_traces(dates, thresholds)
    if length(dates) ~= length(thresholds)
        fprintf(2, 'Length of both input vectors must be the same! \n');
    else
        for ii=1:length(dates)
            %% Finding folder with that date
            date = cell2str(dates(ii));
            folderList = dir();
            for jj = 3:length(folderList)
                if strfind(folderList(jj).name,date(1:end-1));
                    dir_index = jj;
                    break
                end
            end
            %% cd to that folder
            cd(folderList(dir_index).name)
            cd(date(end))
            %% Running the script
            lick_traces_reactime(thresholds(ii,:))
            %% Going back to the parent folder
            cd ../..
        end
    end
end