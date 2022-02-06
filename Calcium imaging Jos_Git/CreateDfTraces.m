%this script produces plots of ROIs from calcium imaging data that has been
%run through CreateAct - it makes _df traces of each cell 
%JS. 19/08/2021
close all;
% %change to working directory
path = 'P:\Calcium Imaging\SHRWKY\New Analysis 19.08.2021\WKY\New WKYs';
cd(path);
files = dir([path]);
select_folders = [files.isdir];
% Extract only those that are directories.
FolderList = files(select_folders);

nFolders = size(FolderList, 1);
fprintf('%d-2 Folder(s) Found',nFolders);
% adjust this to look for only files in date format??
WKY_data = [];

for iFolder = 3:(nFolders) %look at folder list 
    
    cd([path, '\', FolderList(iFolder).name, '\Act']);
    df_file = dir('*.mat'); % Asks MATLAB to look for all _df.mat files
    nFiles = size(df_file, 1); %should alwyas be 3
    fprintf('\n%d acts Found',nFiles);
    
    
    for ii = 1:nFiles
        
        name = df_file(ii).name; % Gets the name of the file that it will work with
        load(name); % load and .mat file
        nRois=size(act,2);
        dfs = zeros(size(act,2), size(act,1));

        
         for iRoi = 1:nRois
        roi = act(:,iRoi);
        flatten = movmean(roi, 200);
        
        subtracted = roi - flatten;
%         mean = mean(subtracted);
        subtracted = single(subtracted);
        stdev = std(subtracted);
        % create mask variable 
        mask = ones(size(roi));
        %exclude begining and end frames (as these should be background)
        %and look for all peaks that are larger than 1 or larger than 3SD 
        if stdev*3 > 3
            mask(500:end-300, 1) = subtracted(500:end-300, 1) < 3;
        elseif stdev*3 > 0.2
            mask(500:end-300, 1) = subtracted(500:end-300, 1) < stdev*3;
        end
        
       %take this a mask of 1s and 0s to exclude areas that wont be used for baseline  
       
        mask = logical(mask);
        % SE is a nesisary input for the imerode function in this case the first
        % number is the number of values and 90 is the degrees to apply it with -
        % this is 90 because I cam using the function for a lineral 1D array rather
        % than a 2D image
        SE = strel('line',300,90);
        mask = imerode(mask, SE);
        %make sure some areas between peaks remain (known 200 frames just
        %before puff
        mask((900:1100), 1) = 1;
        mask((1500:1700), 1) = 1;
        %check mask against origional df
        figure;
        hold on
        plot(repmat(stdev*3, size(roi)));
        plot(mask, 'g');
        plot(subtracted, 'r');
        hold off
        pause(0.2);
        %look at background without pk data 
        bg_nopks = roi(mask);
        % when removing peaks the x value aka the frame number must be preserved -
        % this is done below and plotted
        x = 1:length(roi);
        xx = x(mask);
        xx = reshape(xx,[],1);
        
        %using a spline fitting function inbuilt into matlab which allows a
        %degree of fitting CHANGED HERE
        fittedcurve = csaps(xx, bg_nopks, 0.0000001);
        figure;
        hold on
        plot(xx,bg_nopks);
        fnplt(fittedcurve);
        hold off
        pause(0.2);
        xvalues = fnval(fittedcurve,1:1:length(roi));
        %change variable shape to fit into cat data
        roi = transpose(roi);
        % xvalues = fittedcurve(1:length(roi1));
        df = roi - xvalues;
        %scele the responses to give DF/F0 
           F0 = mean(roi(1, 10:110));
       df = df ./ F0; 
        figure;
        plot(df, 'm');
        %pause for 1 sec to view graph
        pause(0.2);
        
        dfs(iRoi, :) = df(1, :);
    end
%         close all
 cd('..');
 %nb have to remobe 8 letters as accidently left.tif on 
 filename = sprintf([num2str(name(1:end-8)), '_df']); 
    save([filename '.mat'],'dfs');
    close all
 cd('Act\');
    end      
end




