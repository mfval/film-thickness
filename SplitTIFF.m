close all;
  clear all;
  clc;

fname = 'HR.tif';    %Manually set the name of the multi-page TIFF
info = imfinfo(fname);  %Sets name of multi-page TIFF
num_images = numel(info);   %Determines number of images in the TIFF file

for Num = 1:(num_images-1)
    A = imread(fname, Num); %Reads in current image
%     B = imread(fname, Num + 1); %Reads in next image
 
%     StitchedImg=[A;B];  %Creates one image with current image on top and next image on bottom
      StitchedImg=A;
    
%     Max = max(max(StitchedImg));
%     StitchedImg = Max-StitchedImg;
    
%     ParticleFilter = PartFiltGenNI(2.9,100,-10); 
%     StrMax = StretchImageMinMax(StitchedImg);
%     Smth = SmoothImageSD(StrMax,2);
%     
%     PartImg = imfilter(Smth,ParticleFilter, 'symmetric');
%     PixMean = (mean2(PartImg));
%     Threshold = PartImg > (PixMean);
%     Processed = uint16(Threshold*65535);
      
     if Num < 10
        OutFileName = fullfile('',['FT000',int2str(Num),'.tif']); %Creates the file name
     end;
        
     if Num >= 10 && Num < 100
        OutFileName = fullfile('',['FT00',int2str(Num),'.tif']); %Creates the file name
     end;
     
     if Num >=100 && Num <1000
         OutFileName = fullfile('',['FT0',int2str(Num),'.tif']);
     end;
     
     if Num >= 100 && Num < 1000
         OutFileName = fullfile('',['FT0',int2str(Num),'.tif']); %Creates the file name
     end; 
     
     if Num >= 1000
         OutFileName = fullfile('',['FT',int2str(Num),'.tif']); %Creates the file name
     end;
     
         imwrite(StitchedImg, OutFileName,'tif','compression', 'none');  %Writes combined image to file
end;

