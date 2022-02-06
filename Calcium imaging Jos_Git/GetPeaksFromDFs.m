%% Detecting calcium peaks from _df files - this is good for all properties of each peak 
close all;
% %change to working directory
path = 'P:\Calcium Imaging\SHRWKY\New Analysis 19.08.2021\WKY';
cd(path);

FolderList = dir([path]);
nFolders = size(FolderList, 1);
fprintf('%d-2 Folder(s) Found',nFolders);
% adjust this to look for only files in date format??
ALL_data = [];

for iFolder = 3:nFolders %look at folder list - it recognises excels files as folders 
    
    cd([path, '\', FolderList(iFolder).name]);
    df_file = dir('*_df.mat'); % Asks MATLAB to look for all _df.mat files
    nFiles = size(df_file, 1); %should alwyas be 3
    fprintf('\n%d df(s) Found',nFiles);
    all_pk_data=[];
    for ii = 1:nFiles
        
        name = df_file(ii).name; % Gets the name of the file that it will work with
        load(name); % load and .mat file
        nCells=size(dfs,1);
        dfs = permute(dfs, [2 1]);
        file_pk_data = [];
        %    %% setting parameters
        % SamplingFreg = 10;
        % aTime = ((1:size(dfs,1))/SamplingFreg)/60;
        
        %% Juliettes solution
        % Get peak data for all cells
        
        for i=1:nCells;
            pk_data=[];
            smoothCa = sgolayfilt(dfs(:,i),1,11);
            [pk_height,pk_loc,pk_width,pk_prom]=findpeaks(smoothCa,'MinPeakDistance',50,'MinPeakHeight',0.005,'MinPeakWidth',10,'MinPeakProminence',0.005, 'Annotate','extents');
            pk_data (:,1) = repmat(ii,[1,size(pk_height,1)]); %create file number (1=n 2=hex 3=wash);
            pk_data (:,2) = repmat(i,[1,size(pk_height,1)]); %create cell number in  column one for each piece of data
            pk_data (:,3) = pk_height;
            pk_data (:,4) = pk_loc;
            pk_data (:,5) = pk_width;
            pk_data (:,6) = pk_prom;
            file_pk_data = cat(1,file_pk_data,pk_data);
            % Plot each cell trace with detected peaks labeled
            figure
            hold on
            plot(dfs(:,i))
            plot(pk_loc,pk_height,'rv','MarkerFaceColor','r')
            hold off
%             ylim([-1 6]);
            title(sprintf('Cell %d',i));
            % saveas(gcf,sprintf('Cell %d',i), 'png')
            pause(0.5)
            
        end
        all_pk_data = cat(1, all_pk_data, file_pk_data);
        close all
    end
    save(['all_pk_data_', name(1:end-7), '.mat'], 'all_pk_data')
        filename = 'all_pk_data.xlsx'; %save as sheet in excel
        writematrix(all_pk_data, filename, 'Sheet', name(1:end-7));
        
        ALL_data = cat(1,ALL_data, all_pk_data);
        
end
cd('..');
save('ALL_pks.mat', 'ALL_data')
filename = 'ALL_pks.xlsx'; %in excel
writematrix(ALL_data, filename);
