%this script produces plots of ROIs from calcium imaging data that has been
%run through DFMaker
close all;
% %change to working directory
path = 'P:\Calcium Imaging\SHRWKY\test\SHR\test_test';
cd(path);

FolderList = dir([path]);
nFolders = size(FolderList, 1);
fprintf('%d-2 Folder(s) Found',nFolders);
% adjust this to look for only files in date format??
pk1_3pksonly = [];
%set predicted peak location [pk1 pk2 pk3]
pk_meds = [620, 1220, 1820];

for iFolder = 3:(nFolders) %look at folder list - it recognises excels files as folders 
    
    cd([path, '\', FolderList(iFolder).name]);
    file = dir('*_df.mat'); % Asks MATLAB to look for all _df.mat files
    nFiles = size(file, 1); 
    fprintf('\n%d files Found',nFiles);
    
        load(file.name); % load and .mat file
        
        %make blank to insert peaks
        selectedpks = zeros((size(all_pk_data,1)), 8);
        
        %insert row for experiment number and compensate for first two
        %weird folders
        selectedpks(:, 1) = iFolder-2;
        
        exp_number = repmat(iFolder-2, size(all_pk_data,1), 1);
        %for peak1-3 only select peks in the range 
        for i = 1:3
            
            pk_med = pk_meds(i);
            pk_lines = (all_pk_data(:,4))>(pk_med-50)& ((all_pk_data(:,4))<(pk_med+50));
            pk_number = i*pk_lines;
            pk_in_window = all_pk_data(pk_lines, :);
        
       %add experiment number in column 1 of all_pk_data and pk_number in last column      
        selectedpks(:,2:7)=all_pk_data;
        selectedpks(:,8)=selectedpks(:,8) + pk_number;
        end
      
        keep_pk = zeros(size(selectedpks, 1), 1);
    %remove peaks outside of window
    for ii = 1: size(selectedpks)
        if selectedpks(ii,8) == 0 
           keep_pk(ii,1) = 0;
        else
            keep_pk(ii,1) = 1;
        end
    end     
    keep_pk = logical(keep_pk);
    selectedpks = selectedpks(keep_pk, :);
    
    %only keep before hex app experiments 
     keep_pk = zeros(size(selectedpks, 1), 1);
     for ii = 1: size(selectedpks)
        if selectedpks(ii,2) == 1
           keep_pk(ii,1) = 1;
        else
            keep_pk(ii,1) = 0;
        end
    end     
    keep_pk = logical(keep_pk);
    selectedpks = selectedpks(keep_pk, :);
    
    %only keep cells with 3 peaks 
    keep_pk = []; 
    cells = unique(selectedpks(:,3));
    line = 1;
     for ii = 1: size(cells)
        repeats = selectedpks(:,3) == cells(ii,1); 
        cell_firing = sum(repeats);
        if  cell_firing == 3
            keep_pk = cat(1, keep_pk, ones(cell_firing, 1));
        else
            keep_pk = cat(1, keep_pk, zeros(cell_firing, 1));
        end
        line = line + 1;
    end     
    keep_pk = logical(keep_pk);
    ach_pks = selectedpks(keep_pk, :);
    
    %this is for selecting only cells that are continuing to fire in exp 3 
 
%     exp_3 = ach_pks(:,2) == 3;
%     exp_3 = ach_pks(exp_3, :);
%     cells = unique(exp_3(:, 2));
%     
% 
%     for j = 1:size(cells, 1)
%      cell{j} = ach_pks(ach_pks(:,3) == j, :);
%    
%     end
%     
%     final_cells = cat(1, cell{:});
    
    
    %save individual experiments 
%      save('ach_pks.mat', 'ach_pks')
%         writematrix(ach_pks, 'ach_pks.xlsx');
%      save('final_cells.mat', 'final_cells')
%         writematrix(final_cells, 'final_cells.xlsx');   
%         close all

pk1_3pksonly = cat(1,pk1_3pksonly, ach_pks);

end    
     cd('..');
 %nb have to remobe 8 letters as accidently left.tif on 
save('pk1_3pksonly.mat', 'pk1_3pksonly')
        writematrix(pk1_3pksonly, 'pk1_3pksonly.xlsx');
    close all


