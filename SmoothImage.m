function ImgOut=SmoothImage(ImgIn)

%
% SmoothImage(ImgIn) takes a light ring image and applies smoothing
%   filters to it.  
%
%  This function requires the Image Processing Toolbox
%

% Define the Gaussian filter 
GaussFilt = fspecial('gaussian',[12,12]);
AvgFilt = fspecial('average',[8,8]);
Img1 = uint8(filter2(AvgFilt,ImgIn));
Img2 = uint8(filter2(AvgFilt,Img1));
%Img3 = uint8(filter2(GaussFilt,Img2));
%Perform the smooth
ImgOut = uint8(filter2(GaussFilt,Img2));
