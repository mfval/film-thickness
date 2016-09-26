function [Rx,Ry,RMS] = LocateRadii(ImgIn,plotflag)      
    
%%%
%%% LocateRadii(ImgIn) takes a cropped ring image and uses the gradient
%%% function to identify the radii of the light ring.  The image is rotated
%%% a number of times (currently 18) to obtain 4*18 radii.  
%%%
%%% These radii are then used as inputs for an elipse fitting algorithm,
%%% borrowed from other authors.  This algorithm determines the best fit
%%% elipse and outputs the major and minor axes, the center and the
%%% rotation of the elipse.  
%%%
%%%  plotflag=1: display images
%%%  plotflag=0: do not display images
%%%
%%% The goodness of the fit is determined by finding the RMS difference
%%% between the measured and calculated radii at each measurement location.
%%% Right now this may be overestimating the error.
%%%
%%% This function requires
%%%   Gradient2.m
%%%   fitellipse.m
%%%   Image Processing Toolbox
%%%
%%% Important parameters
%%%   rot = 0:17  (Number of radii to find in each quadrant)
%%%   angle = rot*5
%%%   t = linspace(0,2*pi,73) (The 73 should be changed to match the total
%%%                           number of radii + 1)
tic
%% Define image parameters
    ImgHeight = size(ImgIn,1);
    ImgWidth = size(ImgIn,2);
    CenterX = floor(ImgWidth/2);
    CenterY = floor(ImgHeight/2);

%% Find all the radii
    i = 1; %counter for radius coordinate vectors
    for rot = 0:17 % Gives 18 radii per quadrant
       angle = (rot-7)*5;  % 5*18 = 90 = one quadrant
       angrad = angle*pi/180;
       rotimg = imrotate(ImgIn, angle,'bicubic','crop'); % rotates image
       [ru,rd,rl,rr] = Gradient2(rotimg,plotflag); % Finds radii 
       %% Calculate cartesian coordinates of ring locations 
       %radinfo(i,1) = angle
       %radinfo(i,2) = radius
       %radinfo(i,3) = x coord
       %radinfo(i,4) = y coord
       if (ru > 0)
         radinfo(i,3) = CenterX + ru*sin(angrad);
         radinfo(i,4) = CenterY - ru*cos(angrad);
         radinfo(i,1) =  angrad + 1.5* pi;
         radinfo(i,2) = ru;
         i = i + 1;
       end;
       if (rl > 0)
         radinfo(i,3) = CenterX - rl*cos(angrad);
         radinfo(i,4) = CenterY - rl*sin(angrad);
         radinfo(i,1) = angrad +pi;
         radinfo(i,2) = rl;
         i = i + 1;
       end;
       if (rd > 0)
         radinfo(i,3) = CenterX - rd*sin(angrad);
         radinfo(i,4) = CenterY + rd*cos(angrad);
         radinfo(i,1) = angrad + 0.5*pi;
         radinfo(i,2) = rd;
         i = i + 1;
       end;
       if (rr > 0)
         radinfo(i,3) = CenterX + rr*cos(angrad);
         radinfo(i,4) = CenterY + rr*sin(angrad);
         radinfo(i,1) = angrad;
         radinfo(i,2) = rr;
         i = i + 1;
       end;    
       
    end;
  
%% Eliminate radii that are greater than 1 sd from the local mean    
k = 1;
l = 1;
m = 1;
n = 1;
% Sort radii into quadrants
for j = 1:(i-1)
    if (radinfo(j,1) > (7*pi/4)) || (radinfo(j,1) <= (pi/4)) %change 0 to 7*pi/4 for normal operation
        rq1(k,:) = radinfo(j,:);
        k = k+1;
    elseif (radinfo(j,1) > (pi/4)) && (radinfo(j,1) <= (3*pi/4))
        rq2(l,:) = radinfo(j,:);
        l = l+1;
    elseif (radinfo(j,1) > (3*pi/4)) && (radinfo(j,1) <= (5*pi/4))  %change pi to 5*pi/4 for normal operation
        rq3(m,:) = radinfo(j,:);
        m = m+1;        
    elseif (radinfo(j,1) > (5*pi/4)) && (radinfo(j,1) <= (7*pi/4))   %change values to 5*pi/4 and 7*pi/4 respectively for normal operation
        rq4(n,:) = radinfo(j,:);
        n = n+1;    
    end
end



% Remove bad radii
baderror = 1;
numiter = 0;
StdScale = 0.8;
while baderror
   if (numiter == 8)
       break;
   end
    
    o = 1;
    
    if (exist('rq1','var'))
        rq_bar = mean(rq1(:,2));
        rq_sd = StdScale*std(rq1(:,2));
        for j = 1:(k-1)
            if (abs(rq_bar - rq1(j,2)) < rq_sd)
                goodr(o,:) = rq1(j,:);
                o = o+1;
                baderror = 0;
            else
                baderror = 1;
            end
        end
%          baderror=1;
    end
    
    if (exist('rq2','var'))
        rq_bar = mean(rq2(:,2));
        rq_sd = StdScale*std(rq2(:,2));
        for j = 1:(l-1)
            if (abs(rq_bar - rq2(j,2)) < rq_sd)
                goodr(o,:) = rq2(j,:);
                o = o+1;
                baderror = 0;
            else
                baderror =1;
            end
        end
%          baderror=1;
    end

    if (exist('rq3','var'))
        rq_bar = mean(rq3(:,2));
        rq_sd = StdScale*std(rq3(:,2));
        for j = 1:(m-1)
            if (abs(rq_bar - rq3(j,2)) < rq_sd)
                goodr(o,:) = rq3(j,:);
                o = o+1;
                baderror = 0;
            else
                baderror = 1;
            end
        end
%          baderror=1;
    end
    
    if (exist('rq4','var'))
        rq_bar = mean(rq4(:,2));
        rq_sd = StdScale*std(rq4(:,2));
        for j = 1:(n-1)
            if (abs(rq_bar - rq4(j,2)) < rq_sd)
                goodr(o,:) = rq4(j,:);
                o = o+1;
                baderror = 0;
            else
                baderror = 1;
            end
        end
%          baderror=1;
    end
 
        validr = goodr;

    clear goodr;
    numiter=numiter+1;
    %baderror = 0;
end
    
%% Fit the light ring points to an elipse 
% Call the function from Fitzgibbon et al
x_coord = validr(:,3);
y_coord = validr(:,4);
xyang = validr(:,1);
A = fitellipse(x_coord,y_coord);
Cx = A(:,1);
Cy = A(:,2);
Rx = A(:,3);
Ry = A(:,4);
Rotation = A(:,5);

%fprintf('Ry = %g, Rx = %g\n', Ry, Rx);
%fprintf('Cy = %g, Cx = %g\n', Cy, Cx);
%fprintf('Rotation = %g\n', Rotation);
% Use the parameters to plot the ellipse

%% Check calculated ring locations against elipse
t = linspace(0,2*pi,73);       % Generate evenly spaced angles
x = Rx * cos(xyang-Rotation); % Theoretical coordinates of elipse at angles used for measurement
y = Ry * sin(xyang-Rotation);
nx = x*cos(Rotation)-y*sin(Rotation) + Cx; % Adjusted for center and rotation
ny = x*sin(Rotation)+y*cos(Rotation) + Cy;
xx = Rx * cos(t); 
yy = Ry * sin(t);
nxx = xx*cos(Rotation)-yy*sin(Rotation) + Cx; 
nyy = xx*sin(Rotation)+yy*cos(Rotation) + Cy;

%% Calculate length of each radius
xfdiff = nx - Cx;
yfdiff = ny - Cy;
Rfit = sqrt(xfdiff.*xfdiff + yfdiff.*yfdiff);

xediff = x_coord - Cx;
yediff = y_coord - Cy;
Rexp = sqrt(xediff.*xediff + yediff.*yediff);

%% Find RMS error between data and fit
Rdiff = abs(Rfit - Rexp);
Rdiffsqr = Rdiff.*Rdiff;
%RMS = sqrt(mean(Rdiffsqr));
RMS = mean(Rdiff);

%Plot for visual check of elliptical fit
% figure(6)
% plot(nx, ny, 'ro')
% title('Elliptic Fit')
% xlabel('x (pixels)')
% ylabel('y (pixels)')
% legend('Least Square Fit Ellipse')
% axis equal      % Don't distort the image, keep axis units equal
%

if(plotflag)
    figure(5), imshow(ImgIn), impixelinfo;
    hold on;
    plot(x_coord, y_coord, 'ro', nx,ny,'b*',nxx,nyy,'g-');
    set(gca,'position',[0 0 1 1],'units','normalized')
    hold off;
end

% pause(1)
%toc