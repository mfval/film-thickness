function img=ReadnCrop(image,plotflag)

%%%
%%% ReadnCrop(image,plotflag) reads a light ring image from a file, finds
%%%   its approximate center, then crops the image around the light ring
%%% 
%%%  The user needs to provide the width and length of the final
%%%  cropped image
%%%
%%%  plotflag=1: display images
%%%  plotflag=0: do not display images
%%%
%%%  This function requires the Image Processing Toolbox
%%%
%%% Important User Specified parameters:
%%%   imft = mf > xxx  (Threshold value)
%%%   Width = xxx 
%%%   Height = xxx    

%% read and display the original image
%w = imread(image);
w=image;
%figure, imshow(w), impixelinfo;

%% convert to grayscale an display (if desired)
% info = imfinfo(image);
% 
% if strcmp(info(1,1).ColorType,'truecolor')
%     gs = rgb2gray(w);
% else
%         gs = w;
% end;
gs=w;
%figure, imshow(gs), impixelinfo;

%% Clean up random noise with a median filter
mf = medfilt2(gs, [3,3]);
%figure, imshow(mf), impixelinfo;

%%Stretch Image Contrast
strimg = StretchImage(mf);
%figure, imshow(strimg), impixelinfo;
%% Threshold the image
%%% The threshold value may need to be changed for a given image set
%imft = strimg>170;%150;  %130 %120
imft = strimg>150;  %130 %120
%strelement = strel('disk',150); %150
%dil = imdilate(imft,strelement);
%figure, imshow(imft), impixelinfo;



%% Find the centroid
%L = double(dil);
[B1,L1]=bwboundaries(imft,'noholes');
X = regionprops(imft, 'centroid','area');

for j=1:length(B1)
    S(j)=X(j).Area;
end

[val,valindex]=sort(S);
boundary2=B1{valindex(length(B1))}; %perhaps not necessary?
N=length(valindex);

Cen=X(valindex(N)).Centroid;
centroids=Cen;


% %centroids = cat(1, s.Centroid)
% hold on;
% plot(boundary2(:,2),boundary2(:,1),'r-');
% plot(centroids(:,1), centroids(:,2), '*');
% hold off;
% pause
%% Define boundaries of new image
%  upr = upper row
%  leftc = left column
%  lowr = lower row
%  rightc = right column
Width = 600;%600;%600;%675;
Height = 600;%600;%568;
%Vshift = 60;  % This is a hack and should not be used in general
%Vshift = 160;  % This is a hack and should not be used in general
Vshift = 0;
upr = round(centroids(:,2) - Height/2 + Vshift);
lowr = round(centroids(:,2) + Height/2 + Vshift);
leftc = round(centroids(:,1) - Width/2);
rightc = round(centroids(:,1) + Width/2);
x_c = round(centroids(:,1));
y_c = round(centroids(:,2));
%centertext = sprintf('Center located at (%g,%g)',x_c, y_c);
%disp(centertext);
% upr
% lowr
% leftc
% rightc
size(strimg);
img = strimg(upr:lowr, leftc:rightc);
% figure, imshow(img), impixelinfo;
% hold on;
% plot(centroids(:,1), centroids(:,2), '*');
% hold off;
% pause