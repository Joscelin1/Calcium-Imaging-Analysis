%% Detecting calcium peaks 
%this uses _df files from GraphActsPlusMask and finds the max value in user
%defines peak medians 
close all;
% %change to working directory
path = 'P:\Calcium Imaging\SHRWKY\New Analysis 19.08.2021\WKY';
cd(path);

files = dir([path]);
select_folders = [files.isdir];
% Extract only those that are directories.
FolderList = files(select_folders);

nFolders = size(FolderList, 1);
fprintf('%d-2 Folder(s) Found',nFolders);
% adjust this to look for only files in date format??
max_pk_data_allexps = [];
%set predicted peak location [pk1 pk2 pk3]
pk_meds = [620, 1220, 1820];


for iFolder = 3:nFolders %look at folder list - it recognises excels files as folders 
    
    cd([path, '\', FolderList(iFolder).name]);
    df_file = dir('*_df.mat'); % Asks MATLAB to look for all _df.mat files
    nFiles = size(df_file, 1); %should alwyas be 3
    fprintf('\n%d df(s) Found',nFiles);
            %create matrix to save all maxes fro each experiment (before during
        %after)
        max_pk_data = [];
        column_counter = 1;
        column_counter_01 = 10;
    for ii = 1:nFiles
        
        name = df_file(ii).name; % Gets the name of the file that it will work with
        load(name); % load and .mat file
        nCells=size(dfs,1);
        dfs = permute(dfs, [2 1]);
         max_pk_data(:,1) = 1:nCells;
           %% setting parameters
        SamplingFreg = 10;
        aTime = ((1:size(dfs,1))/SamplingFreg)/60;

        % Get peak data for all cells

        for i=1:nCells;
            
            smoothCa = sgolayfilt(dfs(:,i),1,11);
            figure
            hold on
            plot(dfs(:,i))
            %max value between expected peak locations insert each peak
            %into new column
            for kk = 1:3
                pk_med = pk_meds(kk);
                [pk_max, pk_loc] = max(smoothCa(pk_med-50:pk_med+50));
                plot(pk_loc + pk_med-50 ,pk_max,'rv','MarkerFaceColor','r')
                max_pk_data (i,column_counter+kk) = pk_max;
                HalfHeight = pk_max/2;
                if HalfHeight > 2*std(dfs(10:500,i))
                %compute half width
                half = smoothCa(pk_med-100:pk_med+300) > HalfHeight; %(aDataToWrite{ii}{jj}{kk,7}-dHalfHeight);
%                 
                [outputlabel, regioncount] = bwlabel(half);
                half_region = find(outputlabel==1);
                pk_width = aTime(half_region(end)) - aTime(half_region(1)); %half-width in miniutes 
                max_pk_data (i,column_counter_01+kk) = pk_width;
                plot(pk_med-100+half_region(end), HalfHeight, '*','MarkerFaceColor','r', 'MarkerSize', 10);
                plot(pk_med-100+half_region(1), HalfHeight, '*','MarkerFaceColor','r', 'MarkerSize', 10);
                end
            end
            %this inserts a 0 in rows where before drug the peak is not
            %above 2*std of baseline - later I will exclude these cells 
            if ii==1
                if max_pk_data (i,column_counter+1) < 2*std(dfs(50:pk_med-200,i));
                    max_pk_data (i,column_counter+1) = 0;
%                      plot(pk_loc + pk_med-50 ,max_pk_data (i,column_counter+1),'rv','MarkerFaceColor','b')
                end
            end
            % Plot each cell trace with detected peaks labeled
            
           
            hold off
            title(sprintf('Cell %d',i));
               pause(0.2);
            
  
        end
        column_counter = column_counter +3;
        column_counter_01 = column_counter_01 +3;
         close all
    end
    
        max_pk_data_allexps = cat(1,max_pk_data_allexps, max_pk_data);
        
       
        
end
% %remove cells that dont have big enough initial peaks
% indices = find(max_pk_data_allexps(:,2)==0);
% max_pk_data_allexps(indices,:)=[];
%create new column of averaged peaks1/2/3 height
max_pk_data_allexps = cat(2, max_pk_data_allexps, mean(max_pk_data_allexps(:, 2:4),2), mean(max_pk_data_allexps(:, 5:7),2), mean(max_pk_data_allexps(:, 8:10),2));
%create new column of averaged peaks1/2/3 width excluding zeros 
max_pk_data_allexps(max_pk_data_allexps==0)=NaN;
max_pk_data_allexps = cat(2, max_pk_data_allexps, nanmean(max_pk_data_allexps(:, 11:13),2), nanmean(max_pk_data_allexps(:, 14:16),2), nanmean(max_pk_data_allexps(:, 17:19),2));

%create new column of hex block as % of initial (using averaged data)
%HEIGHT
fall_in_signal = (max_pk_data_allexps(:, 21)./max_pk_data_allexps(:, 20))*100;
max_pk_data_allexps = cat(2, max_pk_data_allexps, fall_in_signal);

%create new column of hex block as % of initial (using averaged data) WIDTH
fall_in_signal = (max_pk_data_allexps(:, 24)./max_pk_data_allexps(:, 23))*100;
max_pk_data_allexps = cat(2, max_pk_data_allexps, fall_in_signal);

cd('..');
%change file save into .csv format and make one master file? 
% dlmwrite('P:\Patching\ActionPotentials.csv',oNewAPData.Data,'-append',...
%     'roffset',0,'coffset',0,'delimiter',',','precision','%10.3f');

% filename = 'max_in_window.xlsx'; %in excel
% writematrix(max_pk_data_allexps, filename);
