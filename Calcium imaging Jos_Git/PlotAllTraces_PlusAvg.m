%this script plots all df taces and a mean 
%JS. 19/08/2021
% close all;
% %change to working directory
path = 'P:\Calcium Imaging\SHRWKY\New Analysis 19.08.2021\WKY';
path_SHR = 'P:\Calcium Imaging\SHRWKY\New Analysis 19.08.2021\SHR';

cd(path);
files = dir([path]);
select_folders = [files.isdir];
% Extract only those that are directories.
FolderList = files(select_folders);

nFolders = size(FolderList, 1);
fprintf('%d-2 Folder(s) Found',nFolders);

WKY_data = [];

for iFolder = 3:(nFolders) %look at folder list 
    
    cd([path, '\', FolderList(iFolder).name]);
    df_file = dir('*_df.mat'); % Asks MATLAB to look for all _df.mat files
    nFiles = size(df_file, 1); %should alwyas be 3
    fprintf('\n%d df(s) Found',nFiles);

    for ii = 1
        
        name = df_file(ii).name; % Gets the name of the file that it will work with
        load(name); % load and .mat file
        nCells=size(dfs,1);
        dfs = permute(dfs, [2 1]);

        figure
        title(name)
          hold on
        for i=1:nCells;
        smoothCa = sgolayfilt(dfs(:,i),1,11);
            % Plot each cell trace with detected peaks labeled

            
            plot(smoothCa, 'Color', [0.6, 0.6, 0.6])

             ylim([-0.02 0.3]);


            
        end
        WKY_data = cat(2, WKY_data, dfs(1:2400, :));
%         close all
hold off
    end
     save('WKY_dfs.mat', 'WKY_data')

        
end

cd(path_SHR);
files = dir([path_SHR]);
select_folders = [files.isdir];
% Extract only those that are directories.
FolderList = files(select_folders);

nFolders = size(FolderList, 1);
fprintf('%d-2 Folder(s) Found',nFolders);

SHR_data = [];

for iFolder = 3:(nFolders) %look at folder list 
    
    cd([path_SHR, '\', FolderList(iFolder).name]);
    df_file = dir('*_df.mat'); % Asks MATLAB to look for all _df.mat files
    nFiles = size(df_file, 1); %should alwyas be 3
    fprintf('\n%d df(s) Found',nFiles);

    for ii = 1
        
        name = df_file(ii).name; % Gets the name of the file that it will work with
        load(name); % load and .mat file
        nCells=size(dfs,1);
        dfs = permute(dfs, [2 1]);

        figure
        title(name)
          hold on
        for i=1:nCells;
        smoothCa = sgolayfilt(dfs(:,i),1,11);
            % Plot each cell trace with detected peaks labeled

            plot(smoothCa, 'Color', [0.6, 0.6, 0.6])
             ylim([-0.02 0.3]);

        end
        SHR_data = cat(2, SHR_data, dfs(1:2400, :));
%         close all
hold off
    end
     save('SHR_dfs.mat', 'SHR_data')     
end

% WKY_data_1sec = [];
%  row_counter = 1;
% for i = 1:10:size(WKY_data, 1)
%     %create 1 second average for each trace
%     WKY_data_1sec(row_counter, :) = mean(WKY_data(i:i+9, :));
%     row_counter = row_counter +1;
% end

close
SEM_WKY = std(WKY_data, 0, 2)./sqrt(size(WKY_data, 2));

figure
hold on
x = 1:2400;
mean_WKY = mean(WKY_data, 2);
mean_WKY = sgolayfilt(mean_WKY(:,1),1,11);

curve1 = transpose(mean_WKY+SEM_WKY);
curve2 = transpose(mean_WKY-SEM_WKY);

x2 = [x, fliplr(x)];
y2 = [curve1, fliplr(curve2)];
fill(x2, y2, [0.8, 0.8, 0.8], 'LineStyle','none');
plot(mean_WKY, 'b');



SEM_SHR = std(SHR_data, 0, 2)./sqrt(size(SHR_data, 2));


mean_SHR = mean(SHR_data, 2);
mean_SHR = sgolayfilt(mean_SHR(:,1),1,11);

curve1 = transpose(mean_SHR+SEM_SHR);
curve2 = transpose(mean_SHR-SEM_SHR);

x2 = [x, fliplr(x)];
y2 = [curve1, fliplr(curve2)];
fill(x2, y2, [0.8, 0.8, 0.8], 'LineStyle','none');
plot(mean_SHR, 'r');
plot(mean_WKY, 'b');
hold off

%% copy paste code to only plot first peak 
close
figure
hold on

SEM_WKY = std(WKY_data(500:1100, :), 0, 2)./sqrt(size(WKY_data(500:1100, :), 2));
x = 1:601;
mean_WKY = mean(WKY_data(500:1100, :), 2);
mean_WKY = sgolayfilt(mean_WKY(:,1),1,11);

curve1 = transpose(mean_WKY+SEM_WKY);
curve2 = transpose(mean_WKY-SEM_WKY);

x2 = [x, fliplr(x)];
y2 = [curve1, fliplr(curve2)];
fill(x2, y2, [0.8, 0.8, 0.8], 'LineStyle','none');
plot(mean_WKY, 'b');



SEM_SHR = std(SHR_data(500:1100, :), 0, 2)./sqrt(size(SHR_data(500:1100, :), 2));

mean_SHR = mean(SHR_data(500:1100, :), 2);
mean_SHR = sgolayfilt(mean_SHR(:,1),1,11);

curve1 = transpose(mean_SHR+SEM_SHR);
curve2 = transpose(mean_SHR-SEM_SHR);

x2 = [x, fliplr(x)];
y2 = [curve1, fliplr(curve2)];
fill(x2, y2, [0.8, 0.8, 0.8], 'LineStyle','none');
plot(mean_SHR, 'r', 'LineWidth', 3);
plot(mean_WKY, 'b', 'LineWidth', 3);
hold off
