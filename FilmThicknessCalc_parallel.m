%function  FilmThicknessCalc
% parpool %start workers for parallel computing

tic
  close all;
  clear all;
  clc

  plotflag=0; %plot figures if 1, do not plot figure if 0
  saveflag=1; %save results if 1, do not save results if 0
 %SetupFile = fopen('FTParams.dat', 'r');
 %FTParams = textscan(SetupFile, '%s %f %f %f %f %f %f', 'headerlines', 1,'Delimiter',',');
 %fclose(SetupFile);
 
 DataFile='F:\aug_23\35v10lmanual.tif';
 savefile='F:\aug_23\35v10lmanual_thickness.mat';


 info = imfinfo(DataFile);
 NumImages=numel(info);
 %NumImages=100;
 
%   DataFile = fullfile('',char(FTParams{1}));
%   FileList = dir(fullfile('','*.tif'));
%   NumFiles = length(FileList);
  
%   PixScale =  FTParams{2}; % microns per pixel
%   RefInd =  FTParams{3}; % 
%   RefIndWall =  FTParams{4}; % polycarbonate
%   DryDiam =  FTParams{5}; %826.87; %818.97; % Enter this for diameter (pixels) of dry ring
%   DryStdErr =  FTParams{6}; %0.956; %0.94; % Enter the standard error of the dry ring measurement
%   t_wall = FTParams{7}; %actual wall thickness

PixScale = 25.8042;   %micrometers/pixel
RefInd = 1.26;      %refractive index of R-245fa-liquid
RefIndWall = 1.517; %refractive index of Float Glass - delta-technologies.com
DryDiam = 418.4232; %360.6799; %based on DryNew.tif using OpenTiffTry.m
DryStdErr =  0.3087; %0.5604; %based on DryNew.tif using OpenTiffTry.m...this may not be right as shown below
t_wall = 3200;      %micrometers


  theta_c = asin(1/RefInd); % defines the critical angle!!

%   Radx=2;   %creates variable Radx
%   Rady=2;   %creates variable Rady
%   RMSerror=2;   %creates variable RMSerror
  parfor n = 1:NumImages    %parfor is a parallel for loop

      display(['Processing image number' num2str(n,'%d') '/' num2str(NumImages,'%d')])
%      LocFileName = fullfile('',FileList(n).name);
%      StatusMsg = ['Processing file' ' ' LocFileName];
%      disp(StatusMsg);
      ImageA=imread(DataFile,n);
      %ImageB=imcrop(ImageA,[100 0 1000 900]);
      %ImageB=imcrop(ImageA,[50 0 924 900]);
      ImgIn = ReadnCrop(ImageA,plotflag);
      %figure, imshow(ImgIn), impixelinfo;
      %ImageB=adapthisteq(ImgIn,'NumTiles',[5 5],'ClipLimit',0.02,'Distribution','exponential');
      
%       figure(1),imshow(ImageA)
%       set(gca,'position',[0 0 1 1],'units','normalized')
%       pause
      
      [Rx(n),Ry(n),RMS(n)] = LocateRadii(ImgIn,plotflag);
      %Ry/Rx
      
      %pause(0.1)
     
    
  end;

%Eliminate incorrect data  
x_dry = DryDiam/4;  %TODO: this is removing entire images, which would mismatch with the timestamp...
i = 1;
for n=1:NumImages
    if Ry(n)/Rx(n) > 0.8 && Ry(n)/Rx(n) < 1.2 && (Ry(n)/2) > x_dry %&& Ry > (261.7899/2)
        Radx(i,:) = Rx(n);
        Rady(i,:) = Ry(n); 
        RMSerror(i,:) = RMS(n);
        i = i+1;
    end;
end
  
  %For Tubes only want major axis
  MeanRadx = mean(Radx);
  MeanRady = mean(Rady);  
  StdRadx = std(Radx);
  StdRady = std(Rady); 
  
%  MeanDiam = 2 * (MeanRadx + MeanRady)/2
%  StDev = (StdRadx + StdRady)/2;
  MeanDiam = 2*MeanRady;
  MeanDiamMic = MeanDiam*PixScale/1000;
  StDev = StdRady;
  Nsamp = i;
  MeanRMS = mean(RMSerror);
  StdErr = sqrt(StDev^2 + MeanRMS^2)/sqrt(Nsamp);
  
  disp(['Mean diameter (pix) = ' num2str(MeanDiam)]);
  disp(['Mean diameter (mm) = ' num2str(MeanDiamMic)]);
  disp(['Standard Error (pix) = ' num2str(StdErr)]);

  
  x = MeanDiam/4;
  
  
  IndDiam = 2*Rady;
  IndX = IndDiam/4;
  IndFTpix = (IndX - x_dry)/(tan(theta_c));
  IndFT = IndFTpix * PixScale;
  
  theta_cw = asin(1/RefIndWall); 
%   t_wall = x*PixScale/tan(theta_cw);
  PixScaleCorr = t_wall * tan(theta_cw)/x;

  disp(['Wall Thickness = ' num2str(t_wall)]);
  disp(['Corrected Pix Scale = ' num2str(PixScaleCorr)]);
    
  FTpix = (x - x_dry)/(tan(theta_c));
  FT = FTpix * PixScale;
  
  disp(['Film thickness (pix) = ' num2str(FTpix)]);
  disp(['Film thickness (microns) = ' num2str(FT)]);
  
  Uncertpix =  sqrt(StdErr.^2 + DryStdErr^2)/tan(theta_c);
  Uncert = Uncertpix * PixScale;
  
  disp(['Film thickness uncertainty (pix) = ' num2str(Uncertpix)]);
  disp(['Film thickness uncertainty (microns) = ' num2str(Uncert)]);
  

  if(saveflag)
  wdir = pwd;
  Outstruct=struct('WorkingDirectory',wdir,'PixScale',PixScale,'RefInd',RefInd,'RefIndWall',RefIndWall,'DryDiam',DryDiam,'DryStdErr',DryStdErr,'MeanDiam',MeanDiam,'StdErr',StdErr,'t_wall',t_wall,'PixScaleCorr',PixScaleCorr,'FTpix',FTpix,'FT',FT,'Uncertpix',Uncertpix,'Uncert',Uncert,'Radx',Radx,'Rady',Rady,'RMSerror',RMSerror,'IndFT',IndFT);
  save(savefile,'-struct','Outstruct');
  end
    
  toc
  
  
  