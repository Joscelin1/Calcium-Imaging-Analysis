%% Opening a list of image stacks in one folder

% optional: This makes a new folder for you to save your resized/matlab changed images. 
YesFolder = isfolder ('Resized Images');
if YesFolder == 1;
%    ;
else YesFolder == 0;
mkdir ('Resized Images');
end
    
RawImage = dir('*.tif'); % Asks MATLAB to look for all .tif files in the folder 'Raw Tiff'

for ii = 1:size(RawImage,1)
    name = RawImage(ii).name; % Gets the name of the image that it will work with
    stack = ReadTiffStack([name]); % load and convert the tiff image into a .m file
    stack = single(stack);
    filename = sprintf(num2str(name(1:end-4))); 
    cd('Resized Images'); % This goes to the folder you want your changed images to save in.
    save([filename '.mat'],'stack');
    
%     saveastiff(resizedimage,[filename, '_resized.tiff']);
    
    cd(parent_dir)
end
