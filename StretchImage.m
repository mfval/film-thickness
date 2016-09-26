function ImgOut=StretchImage(ImgIn)

%
% StretchImage(ImgIn) takes a light ring image and then finds the
%   mean gray value and the minimum gray value in the image.
%   These values are used to stretch the image between 0 and 
%   mean + 40.  The upper value may need to be adjusted according 
%   to the image set.  
%
%   The raw stretch doesn't work because of the number of 255 
%   pixels at the center of the image.
%
%  This function requires the Image Processing Toolbox
%

% Find minimum; this is a column function so it must be run twice
MinPix = double(min(min(ImgIn)));

% Find the mean value
MeanPix = mean2(ImgIn);

% imadjust needs a fraction between 0 and 1 for each argument
MinAdj = double(MinPix)/255;
%MaxAdj = double(MeanPix+70)/255;
MaxAdj = min(double(MeanPix+70)/255,1.0);

% Stretch the image
ImgOut = uint8(imadjust(ImgIn,[MinAdj,MaxAdj],[0,1]));