function transferFiles()
%
    pathW = 'W:\Neurophysiology-Storage1\Gilad\Data_per_mouse\mouse_tgg6fl23_12';
    pathF = 'K:\for_Nisheet\Trial_Nisheet\m12\';
    folderListW = dir(pathW);
    folderListF = dir(pathF); b=0;
    for i=3:(length(folderListW))
        for j=3:length(folderListF)
            if strfind(folderListF(j).name,'_problematic')
                b=1;    %break counter for problematic folders
            end
            cd(folderListF(j).name)
            inListF = dir();
            for in=3:length(inListF)
                if b==1
                    b=0; break
                end
                if strcmp(folderListW(i).name,inListF(in).name(end-7:end))
                    if inListF(in).name(end-9)~='_'
                        ses = inListF(in).name(end-9);
                        copyfile([pathF, '\', folderListF(j).name, '\', inListF(in).name, '\RT.mat'],[pathW, '\', folderListW(i).name, '\', ses]);
                    elseif inListF(in).name(end-9)=='_'    
                        ses = inListF(in).name(end-10);
                        copyfile([pathF, '\', folderListF(j).name, '\', inListF(in).name, '\RT.mat'],[pathW, '\', folderListW(i).name, '\', ses]);
                    end
                end
            end
            cd ..
        end
    end
end
%}

%{
% Good old code for single threshold folder in F, not multiple folders
    pathW = 'W:\Neurophysiology-Storage1\Gilad\Data_per_mouse\mouse_tgg6fl23_2';
    pathF = 'K:\for_Nisheet\Trial_Nisheet\m2\';    
    folderListW = dir(pathW); %cd(pathW);
    folderListF = dir(pathF);
    for i=3:(length(folderListW)-4)
            for j=3:length(folderListF)
                if strcmp(folderListW(i).name,folderListF(j).name(end-7:end))
                    if folderListF(j).name(end-9)~='_'
                        ses = folderListF(j).name(end-9);
                        if exist([pathW, '\', folderListW(i).name, '\', ses],'dir')
                            copyfile([pathF, '\', folderListF(j).name, '\RT.mat'],[pathW, '\', folderListW(i).name, '\', ses]);
                        end
                    elseif folderListF(j).name(end-9)=='_'    
                        ses = folderListF(j).name(end-10);
                        if exist([pathW, '\', folderListW(i).name, '\', ses],'dir')
                            copyfile([pathF, '\', folderListF(j).name, '\RT.mat'],[pathW, '\', folderListW(i).name, '\', ses]);
                        end
                    end
                end
            end
            %end
    end
end
%}