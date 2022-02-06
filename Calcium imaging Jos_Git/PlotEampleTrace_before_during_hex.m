%this script plots a df tace before and with hex
%JS. 12/01/2021
 close all;
% %change to working directory

%Manually select files to load 
%first the before dfs
load('21-04-08(00010)_df.mat');
dfs_before = dfs;
%then the during Hex dfs
load('21-04-08(00013)_df.mat');
dfs_hex = dfs;
%choose example cell
Cell=12; 
        nCells=size(dfs_before,1);
        dfs_before = permute(dfs_before, [2 1]);
         dfs_hex = permute(dfs_hex, [2 1]);
           %% setting parameters
        SamplingFreg = 10;
        aTime_1 = ((1:size(dfs_before,1))/SamplingFreg)/60;
        aTime_2 = ((1:size(dfs_hex,1))/SamplingFreg)/60;

        % Get peak data for all cells

       i=Cell;
            
            smoothCa_before = sgolayfilt(dfs_before(:,i),1,11);
            smoothCa_hex = sgolayfilt(dfs_hex(:,i),1,11);
            figure
            hold on
            plot(aTime_1, smoothCa_before(:,:), 'k', 'LineWidth',2)
             plot(aTime_2, smoothCa_hex(:,:), 'm', 'LineWidth',2)
         hold off
       
           
           
            title(sprintf('Cell %d',i));
               pause(0.2);
            
  

