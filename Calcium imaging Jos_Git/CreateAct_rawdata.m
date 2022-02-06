%JS 18.08.2021
%to first select rois (networkroi/ roiactivity) then ave act files of each
%(zaxis pot of each cell)
close all;
% %change to working directory
path = 'P:\Calcium Imaging\SHRWKY\New Analysis 19.08.2021\WKY\New WKYs';
cd(path);


FolderList = dir([path]);
nFolders = size(FolderList, 1);
fprintf('%d-2 Folder(s) Found',nFolders);
% adjust this to look for only files in date format??

%loop through each experiment folder
for iFolder = 3:nFolders
    % convert ROIs to mask
    cd([path, '\', FolderList(iFolder).name]);
    networkroi(672,512);
    
    %get all tiff staks in corrected folder
    cd([path, '\', FolderList(iFolder).name, '\Corrected']);
    RawImage = dir('*.tif'); % Asks MATLAB to look for all .tif files in the folder
    nRawImages = size(RawImage, 1);
    fprintf('\n%d Image(s) Found',nRawImages);
    
    
    for ii = 1:size(RawImage,1)
        %load image
        name = RawImage(ii).name; % Gets the name of the image that it will work with
        stack = single(ReadTiffStack([name])); % load and convert the tiff image into a .m file
        fprintf('\n load image %d name: %s \n', ii, name);
        
        
        cd([path, '\', FolderList(iFolder).name]);
        % %get the data in these rois this is raw not a df
        roiactivity_jos(name, stack);
        
    end
    
end

