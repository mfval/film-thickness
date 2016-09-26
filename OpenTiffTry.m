clear all 
close all
clc

%parpool

flagplot=0

% fname='G:\20120911RTFC\Optical\Dry.tif';
fname='F:\aug_23\dry.tif';
%fname ='E:\NoHeat\FilmThickness\Tiffs\mv40ml40.tif';
%fname = 'E:\NoHeat\FilmThickness\Scale\ScaleBigLens.tif';
info = imfinfo(fname);
num_images = numel(info);
%num_images = 100;

Rx=zeros(num_images,1);
Ry=zeros(num_images,1);
RMS=zeros(num_images,1);

parfor k=1:num_images
    A=imread(fname,k);
    display(['Processing image ' num2str(k)])

    %B=histeq(A);
    
%     figure(1),
%     imshow(B);
    if flagplot
    imshow(A)
    end
    img=ReadnCrop(A,flagplot);
    %imshow(img);
    %Bimg=adapthisteq(img,'NumTiles',[5 5],'ClipLimit',0.02,'Distribution','exponential');  
    %Cimg=histeq(img);
    [Rx(k),Ry(k),RMS(k)] = LocateRadii(img,flagplot);
    
   
    %pause;
    
end




% savefile='E:\NoHeat\FilmThickness\Tiffs\Dry.mat';
% Outstruct=struct('Rx',Rx,'Ry',Ry,'RMS',RMS);
% 
% 
% save(savefile,'-struct','Outstruct');

  MeanRadx = mean(Rx);
  MeanRady = mean(Ry);  
  StdRadx = std(Rx);
  StdRady = std(Ry);
  
  MeanDiam = 2 * (MeanRadx + MeanRady)/2
  StDev = (StdRadx + StdRady)/2;
  Nsamp = num_images;
  MeanRMS = mean(RMS);
  StdErr = sqrt(StDev^2 + MeanRMS^2)/sqrt(Nsamp)

  
  
%% EXCESS
%     [x1,y1]=ginput(2);
% %    [x2,y2]=ginput(1);
%     
%     c=sqrt((x1(1)-x1(2))^2+(y1(1)-y1(2))^2)

