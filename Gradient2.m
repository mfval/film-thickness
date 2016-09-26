function [ru,rd,rl,rr] =Gradient2(ImgIn,plotflag)

%%%
%%% REV 29MAR2009 by TAS
%%%
%%% Gradient2(ImgIn) takes a light ring image and extracts 4 'slices'
%%% Upper, lower, right and left forming a cross so that 4 radii are
%%% found with each function call and returned to the calling program.
%%%
%%% It first takes the gradient of the brightness
%%% of the pixels averaged along rows of the slice, 
%%% then finds the maximum value of the gradient.
%%%
%%%  plotflag=1: display images
%%%  plotflag=0: do not display images
%%%
%%% This function requires the Image Processing Toolbox
%%%%
%%%  Important user specified parameters:
%%%    CenterIgnore = xxx (generally helpful to ignore light source)
%%%    slicewidth = xxx (width of each slice; 50 seems good for many
%%%                      images)
%%%    g = [xx; xx; xx]  (Gradient kernel)
%%%    MinGrad = xx  (Minimum value of a gradient that indicates a light
%%%                   ring exists)


%% Find dimensions of image
ImgHeight = size(ImgIn,1);
ImgWidth = size(ImgIn,2);

CenterIgnore = 150;
CenterY = floor(ImgHeight/2);
CenterX = floor(ImgWidth/2);

%% Define Slice width
slicewidth = 50;

smth =ImgIn;  % no smoothing at this point; legacy feature

%% Define gradient filter
g = [-10; 0; 10];

%% Upper Slice
UpperTop = 1;
UpperBottom = CenterY - CenterIgnore;
UpperLeft = CenterX - floor(slicewidth/2);
UpperRight = CenterX + floor(slicewidth/2);
UpperSlice = smth(UpperTop:UpperBottom, UpperLeft:UpperRight); % Extract slice
StrU = StretchImage(UpperSlice); % Stretch Slice
SmthU=SmoothImage(StrU); % Smooth Slice
%figure, imshow(SmthU), impixelinfo;
Umean = mean(SmthU,2); %Find average brightness in each row

Uprof = flipud(Umean); % Orient slice so that brightness increases with increasing pixel location
%figure, plot(Uprof), grid on;
Upgrad = imfilter(Uprof,g); % Perform gradient
Upgrad(1:10) = 0;  % Zero out artifacts of gradient at leading edge
[maxvalUp,maxposUp] = max(Upgrad); % Find the maximum value of the gradient
%figure, plot(Upgrad), grid on;

%% Lower Slice
LowerTop = CenterY + CenterIgnore;
LowerBottom = ImgHeight;
LowerLeft = CenterX - floor(slicewidth/2);
LowerRight = CenterX + floor(slicewidth/2);
LowerSlice = smth(LowerTop:LowerBottom, LowerLeft:LowerRight);
StrLo = StretchImage(LowerSlice);
SmthLo = SmoothImage(StrLo);
%figure, imshow(SmthLo), impixelinfo;
Lomean = mean(SmthLo,2);

Loprof = Lomean;
%figure, plot(Loprof), grid on;
Lograd = imfilter(Loprof,g);
Lograd(1:10) = 0;
[maxvalLo,maxposLo] = max(Lograd);
%figure, plot(Lograd), grid on;

%Left Slice
LeftTop = CenterY - floor(slicewidth/2);
LeftBottom = CenterY + floor(slicewidth/2);
LeftLeft = 1;
LeftRight =  CenterX - CenterIgnore;
LeftSlice = smth(LeftTop:LeftBottom, LeftLeft:LeftRight);
StrLeft = StretchImage(LeftSlice);
SmthLeft = SmoothImage(StrLeft);
%figure, imshow(SmthLeft), impixelinfo;
Leftmean = mean(SmthLeft,1);

Leftprof = fliplr(Leftmean);
%figure, plot(Leftprof), grid on;
Leftgrad = imfilter(Leftprof,g');
Leftgrad(1:10) = 0;
[maxvalLeft,maxposLeft] = max(Leftgrad);
%figure, plot(Leftgrad), grid on;

%% Right Slice
RightTop = CenterY - floor(slicewidth/2);
RightBottom = CenterY + floor(slicewidth/2);
RightRight = ImgWidth;
RightLeft =  CenterX + CenterIgnore;
RightSlice = smth(RightTop:RightBottom, RightLeft:RightRight);
StrRight = StretchImage(RightSlice);
SmthRight = SmoothImage(StrRight);
%figure, imshow(SmthRight), impixelinfo;
Rightmean = mean(SmthRight,1);

Rightprof = Rightmean;
%figure, plot(Rightprof), grid on;
Rightgrad = imfilter(Rightprof,g');
Rightgrad(1:10) = 0;
[maxvalRight,maxposRight] = max(Rightgrad);
%figure, plot(Rightgrad), grid on;


%% Calculate the four radii; set to 0 if not found
MinGrad = 15;

if (maxvalRight > MinGrad) 
   rr = maxposRight + CenterIgnore;
   x_coord(1,:) = CenterX + rr;
   y_coord(1,:) = CenterY;
else 
   rr = 0;
   x_coord(1,:) = CenterX + rr;
   y_coord(1,:) = CenterY;
end;

if (maxvalLeft > MinGrad) 
   rl = maxposLeft + CenterIgnore;
   x_coord(2,:) = CenterX - rl;
   y_coord(2,:) = CenterY;
else 
   rl = 0;
   x_coord(2,:) = CenterX - rl;
   y_coord(2,:) = CenterY;
end;

if(maxvalUp > MinGrad) 
   ru = maxposUp + CenterIgnore;
   x_coord(3,:) = CenterX;
   y_coord(3,:) = CenterY - ru;
else
   ru = 0;
   x_coord(3,:) = CenterX;
   y_coord(3,:) = CenterY - ru;
end;

if (maxvalLo > MinGrad)
    rd = maxposLo + CenterIgnore;
   x_coord(4,:) = CenterX;
   y_coord(4,:) = CenterY + rd;
else
    rd = 0;
   x_coord(4,:) = CenterX;
   y_coord(4,:) = CenterY + rd;
end;

if(plotflag)
figure(7), imshow(ImgIn), impixelinfo;
hold on;
plot(x_coord, y_coord, 'ro');
set(gca,'position',[0 0 1 1],'units','normalized')
hold off;
end
%pause(1)

