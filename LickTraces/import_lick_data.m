%% Reads the behavior (.tdms) files and outputs lick vectors
% Author: Unknown (adapted and commented by Nisheet)

% Dependencies: This function calls one or more of the TDMS sub-functions. 
% Make sure that those are added to the path in order for this script to 
% run without errors.

% Returns: This function returns the lick data (voltage traces 
% corresponding to the licking) w.r.t. time

% CAUTION! This script may fail if the current working directory does not 
% have a behavior folder containing the TDMS files. This organization of 
% code has been adapted to Ariel Gilad's data. Please either organize your
% data in a similar manner or create another version of this function and
% change the directory name from 'behavior/' to the one that contains your
% TDMS files.
%% 
function licks = import_lick_data()

% enter these parameters before beginning
sample_rate = 100;    %in Hz

% begin 
directory = 'behavior/';
ca = dir(directory);
ca = struct2cell(ca);
ca = ca(1,:);
ca = reshape(ca, [], 1);
a = size(ca);
a = a(1);
licks = [];

for i = 1:a
    if findstr('.', ca{i}) == 1 
    elseif findstr('..', ca{i}) == 1 
    elseif findstr('notebook', ca{i}) == 1
    elseif findstr('Thumbs', ca{i}) == 1
    elseif findstr('index', ca{i}) > 1
    elseif findstr('txt', ca{i}) > 1
    elseif findstr('mat', ca{i}) > 1
    else
        
        ca_char = ca{i}
        % generate lick data from 2 channel data
        lick_tdms = TDMS_getStruct(['behavior/' ca_char]);
        pre_lick = lick_tdms.Untitled.Untitled.data;
        pre_lick(:,2:2:end) = [];    %odd columns only
        time_lick = [];
        lick_length = length(pre_lick);
        for j = 1:lick_length
            t = j/sample_rate;
            time_lick = [time_lick, t];
        end
        lick.lick_vector = [pre_lick; time_lick];
           
        licks = [licks; lick];
    end
end

savename = 'licks.mat';
if exist(savename, 'file') == 0
      save(savename, 'licks');
else 
      licks_new = licks; 
      load('licks.mat')
      save('licks_old.mat','licks');
      licks = licks_new; %#ok<NASGU>
      save('licks.mat','licks')
end

%% Outdated piece of code removed:
%{
% Outdated: Omitting this omits the trial number and timestamp collection 
% from the file names. Not generalizable & useless, hence discarded.
% Position in the original code: After ca_char = ca{i}
underscore = findstr('_', ca_char);
first_underscore = underscore(1);
second_underscore = underscore(2);
period = findstr('.', ca_char);

% store trial number
trial = ca_char(second_underscore+1:period-1);
lick.trial = str2double(trial);

% store time stamp
hr = ca_char(first_underscore+9:first_underscore+10);
min = ca_char(first_underscore+11:first_underscore+12);
sec = ca_char(first_underscore+13:first_underscore+14);
time = [hr ':' min ':' sec];
lick.time_stamp = time; 
%}