%% Licking traces per condition
% Author: Unknown (adapted and commented by Nisheet)

% Dependencies: This script is sequentially placed after initializing the 
% thresholds and running import_lick_detector.m, fetch_vars4cue.m
% It needs the variables masterMat.mat, produced by fetch_vars4cue, and
% top_thresh and bot_thresh, which must be input manually (or initialized
% in the parent script lick_traces_reactime.m

% Returns: This script returns lick vectors for all conditions individually
% as in licks_go, licks_nogo, etc. and the corresponding trial numbers.

%% Begin
function licking_traces_conditional(licks, masterMat, cues, bot_thresh, top_thresh)

    go=[];      % initializing
    miss=[];    % initializing
    nogo=[];    % initializing
    FA=[];      % initializing
    early=[];   % initializing

    %% Fetching condition type from the masterMat
    for i=1:length(masterMat)
        if strfind(masterMat(i).decision, 'No Go')
            nogo = [nogo masterMat(i).id];
        elseif strfind(masterMat(i).decision, 'Go')
            go   = [go masterMat(i).id];
        elseif strfind(masterMat(i).decision, 'Inappropriate Response')
            FA   = [FA masterMat(i).id];
        elseif strfind(masterMat(i).decision, 'No Response')
            miss = [miss masterMat(i).id];
        elseif strfind(masterMat(i).decision, 'Early')
            early= [early masterMat(i).id];
        end
    end

    %% Condition-wise lick vectors
    licks_go=nan*ones(1500,size(go,2));
    k=0;
    for i=go
        k=k+1;
        licks_go(1:size(licks(i).lick_vector(1,:),2),k)=licks(i).lick_vector(1,:);
    end

    licks_nogo=nan*ones(1500,size(nogo,2));
    k=0;
    for i=nogo
        k=k+1;
        licks_nogo(1:size(licks(i).lick_vector(1,:),2),k)=licks(i).lick_vector(1,:);
    end

    licks_early=nan*ones(1500,size(early,2));
    k=0;
    for i=early
        k=k+1;
        licks_early(1:size(licks(i).lick_vector(1,:),2),k)=licks(i).lick_vector(1,:);
    end

    if size(licks_early,2)>0
        %figure;plot(x,licks_early,'k')
    end

    licks_FA=nan*ones(1500,size(FA,2));
    k=0;
    for i=FA
        k=k+1;
        licks_FA(1:size(licks(i).lick_vector(1,:),2),k)=licks(i).lick_vector(1,:);
    end
    %figure;plot(x,licks_FA,'k')

    licks_miss=nan*ones(1500,size(miss,2));
    k=0;
    for i=miss
        k=k+1;
        licks_miss(1:size(licks(i).lick_vector(1,:),2),k)=licks(i).lick_vector(1,:);
    end
    %figure;plot(x,licks_miss,'k')
    
    %% Time vector for plotting
    x=(1:1500)*0.01-3;  % 1500 : Total 15 sec time vector
                        % *0.01: Sample rate = 100 Hz; 
                        % -3   : baseline (s)
    
    %% Plotting the lick vectors condition-wise 
    if ~isempty(licks_go)          % isempty faster than length()>0
        f1=figure;
        plot(x,licks_go(1:length(x),:),'r')
        hold on
        if ~isempty(licks_nogo)
            plot(x,licks_nogo(1:length(x),:),'b')
        end
        plot(x,top_thresh,'k')
        plot(x,bot_thresh,'k')
        plot([cues(1) cues(1)], [bot_thresh top_thresh], 'k')
        legend('Go')
        fname= 'licks_goNogo';
        saveas(f1,fname,'png')
    end

    %% Condition-wise threshold calculations
    go_thresh=ones(1500,size(go,2));
    go_thresh(licks_go(1:length(go_thresh),:)>top_thresh)=0.75;
    go_thresh(licks_go(1:length(go_thresh),:)<bot_thresh)=0.75;
    if size(go,2)>0
        %figure;imagesc(x,1:size(go,2),go_thresh',[0 1]);colormap(mapgeog) %
    end
    nogo_thresh=ones(1500,size(nogo,2));
    nogo_thresh(licks_nogo(1:length(nogo_thresh),:)>top_thresh)=0.25;
    nogo_thresh(licks_nogo(1:length(nogo_thresh),:)<bot_thresh)=0.25;
    if size(nogo,2)>0
        %figure;imagesc(x,1:size(nogo,2),nogo_thresh',[0 1]);colormap() %mapgeog
    end
    early_thresh=ones(1500,size(early,2));
    early_thresh(licks_early(1:length(early_thresh),:)>top_thresh)=0.1;
    early_thresh(licks_early(1:length(early_thresh),:)<bot_thresh)=0.1;
    if size(early,2)>0
        %figure;imagesc(x,1:size(early,2),early_thresh',[0 1]);colormap(mapgeog)
    end
    FA_thresh=ones(1500,size(FA,2));
    FA_thresh(licks_FA(1:length(FA_thresh),:)>top_thresh)=0.4;
    FA_thresh(licks_FA(1:length(FA_thresh),:)<bot_thresh)=0.4;
    if size(FA,2)>0
        %figure;imagesc(x,1:size(FA,2),FA_thresh',[0 1]);colormap() %mapgeog
    end
    miss_thresh=ones(1500,size(miss,2));
    miss_thresh(licks_miss(1:length(miss_thresh),:)>top_thresh)=0.6;
    miss_thresh(licks_miss(1:length(miss_thresh),:)<bot_thresh)=0.6;
    if size(miss,2)>0
        %figure;imagesc(x,1:size(miss,2),miss_thresh',[0 1]);colormap() %mapgeog
    end
    total=cat(2,go_thresh,miss_thresh,nogo_thresh,FA_thresh,early_thresh);

    %% Plotting total matrix (ask Ariel Gilad)
    if size(total,2)>0
        f8=figure;imagesc(x,1:size(total,2),total',[0 1]);colormap(mapgeog) %
        xlim([-1 8])
        fname= 'licks_totalMatrix';
        saveas(f8,fname,'png')
    end
    
    %% Saving all variables
    %cd Matt_files
    save('lick_traces_per_condition')

end