%% Generating the z-axis profile and finding the baseline
% Assuming you've loaded the raw tiff images into a mat file 
%Image = ReadTiffStack('20.10.15(31).tif'); % Image is the variable and the 'name.tif' is the name of your image.
%% Generating a z-axis profile ?
% Set the variable for the raw image stack (as mat file) as 'RawStack' 
% Make sure the raw images is in a stack e.g. has 3 dimensions. The third  dimension is the number of frames. 
% E.g. 256 x 256 x 2400, the 256 is the pixel and 2400 is the  number of frames in this recording.
load('P:\Calcium Imaging\00-20-10-15\Resized Images\DFs\20.10.15(31).mat');
RawStack=stack; 
z_axis = [];
for ii = 1:size(RawStack,3); %'RawStack' is the variable for the raw images
 b = nanmean (RawStack(:,:,ii),'all'); %This averages all the pixel for that one frame.
 z_axis = cat(1,z_axis,b);
end
%% Finding different baseline
% Mean 
meanF0 = mean(z_axis);
% Mode
%modeF0 = mode(z_axis); % Don't want to use 'mode' as a variable, because it's a function. 
% Moving average
movavF20 = movmean(z_axis,20); % The '20' is the frame window. Change this to 500 if you want the window to be 500 frames. 
movavF50 = movmean(z_axis,50); 
movavF100 = movmean(z_axis,100); 
movavF200 = movmean(z_axis,200); 
% 25th percentile
%percentile25 = prctile(z_axis,25); % '25' is the 25th percentile. Change the number to whatever percentile you want.  
figure
plot(z_axis, 'k');
xlabel ('Frame');
ylabel ('Mean grey value');
hold on;
p1 = yline (meanF0, 'r');
%p2 = yline (modeF0, 'b');
%p3 = yline (percentile25,'c');
p4 = plot(movavF20,'m');
p5 = plot(movavF50,'g');
p6 = plot(movavF100,'c');
p7 = plot(movavF200,'b');
legend ([p1 p4 p5 p6 p7], 'mean','moving average 20 frames','moving average 50 frames','moving average 100 frames', 'moving average 100 frames', 'location', 'best');