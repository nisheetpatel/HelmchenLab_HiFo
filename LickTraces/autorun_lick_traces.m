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
% For example: 
%   dates       = {'20170718' '20170719'};
%   thresholds  = [[2.57 2.64]; [2.55 2.65]; [2.57 2.64]; [2.55 2.65]]; %(if we have 4
%   folders with those dates, ordered by name in ascending order as: dir()
%   autorun_lick_traces(dates, thresholds)

%% Begin
function autorun_lick_traces(dates, thresholds)
    for ii=1:length(dates)
        %% Finding folder with that date
        date = char(dates(ii));
        folderList = dir();
        for jj = 3:length(folderList)
            if strfind(folderList(jj).name,date(1:end));
                dir_index = jj;
                cd(folderList(dir_index).name)  % cd to desired folder
                %% Running the script (if folder has not already been processed)
                if ~(exist('licks.mat','file') && exist('RT.mat','file'))
                    % Running the script
                    lick_traces_reactime(thresholds(ii,:))
                end
                %% Going back to the parent folder
                cd ..
            end
        end
    end
end