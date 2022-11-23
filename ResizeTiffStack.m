%% Opening a list of image stacks in one folder

% optional: This makes a new folder for you to save your resized/matlab changed images. 
YesFolder = isfolder ('Resized Images');
if YesFolder == 1;
%    ;
else YesFolder == 0;
mkdir ('Resized Images');
end
    
parent_dir=pwd; % this is the main folder for that trial. It is not the folder containing all your raw images

RawImage = dir(['Corrected/','*.tif']); % Asks MATLAB to look for all .tif files in the folder 'CaStacks'
X=zeros(512,672,2400);
for ii = 1:size(RawImage,1)
    cd('Corrected/');
    name = RawImage(ii).name; % Gets the name of the image that it will work with
    Y = ReadTiffStack([name]); % load and convert the tiff image into a .m file
    
    X = Y(:,:,[1:2400]); %make all recordings 2400 frames long (4mins) 
    resizedimage=imresize(X,[512 672]); % resize your image into a XbyX pixels
    cd(parent_dir);
    
    filename = sprintf([num2str(name(1:end-4)),' Resized.tif']); % change the 'Resized' to whatever you want, just make sure it's between '').
    cd('Resized Images'); % This goes to the folder you want your changed images to save in.
    
    saveastiff(resizedimage,[filename]);
    
    cd(parent_dir)
end
