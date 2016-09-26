clear all
close all
clc

%DataFile='E:\NoHeat\FilmThickness\Scale\ScaleBigLens.tif';
DataFile='E:\100W\Window7_try3\FilmThickness\Tiffs\Scale.tif';

info = imfinfo(DataFile);
NumImages=numel(info);


%for n = 1:NumImages
    ImageA=imread(DataFile,1);
    
    imshow(histeq(ImageA));
    [x,y]=ginput(2);
    
    c=sqrt((x(1)-x(2))^2+(y(1)-y(2))^2);    %pixels
%end

LenScale=10e3;                              %micrometers
LenCalibrate=LenScale/c;                    %micrometers/pixel







