function [returnValue, returnValue2] = measureobject( nbrepeat, interactive, justCalibrate, filepathname1)
%MEASUREOBJECT
%   Calculate the pixel length of a calibration target, and use it to 
%   measure a distance on a target image. 
%   
%   [(D) =] measure() is the real distance. By default, 1 set of points
%   will be used and measurement will be done.
%   P = measure( ..., justCalibrate=true[,...]) is the pixel size. No
%   measurements will be done.
%   [D,P] = measure(...) is the vector of real distance(null if
%   justCalibrate=true), D, and pixel size, P.
%   
% @param nbrepeat number of times the user would like to take measurements.
% @param interactive TRUE for displaying results in figures
% @param filepathname1 the path to the calbiration image
% 
%
% This MATLAB code was originally developed by Arganthael Berson in 
% Dec. 15, 2010. It is used to translate image pixels to real length units.
% This is important as we are rarely interested in the behaviour of matter
% in pixels, but in, say, micrometers. This program is intended to
% calculate the pixel length of a calibration target, and use it to measure 
% some distance on a target image. 
%
% Originally writtten as a script, this file should now be run only
% as a function. There are two parts to this function: calibration and 
% measurement. The calibration part finds the pixel size, while the 
% measurement part uses the previously found pixel size to find the
% distance between two points on a target image. 
% 



% Measure a distance of an object
% Can use a calibration image
% Arganthael Dec. 15th 2010


% assign returnValues first.
returnValue = 0;
returnValue2 = null;

if( nargin == 0 )
    nbrepeat = 1;
end;

% If only one is given, nbrepeat, set the values of rest to default.
if( nargin < 2 )
    interactive = true;
end;

% If 1 to 3 are given, set whether to measure or not.
% Default: false. Measure too.
if( nargin < 3 )
        justCalibrate = false;
end;

% If one or two are given, the filepathname needs to be requested.
if( nargin < 4 )
    %Load calibration file
    [filename, pathname, ~] = uigetfile({'*.jpg;*.tif;*.png','All Image Files';'*.*','All Files'},'Pick a calibration image file ','MultiSelect','off');
    % Fail gracefully if user cancels.
    if isequal(filename,0) || isequal(pathname,0)
        return;
    end;
    filepathname1 = [ pathname, filename ];
end;

% Check if the file is valid
% return if not, or maybe fail gracefully....?
if( exist(filepathname1, 'file') == 0 )
    error('File not found.');
end;

% read the image file.
im=imread( filepathname1 );

% print image
f1 = figure(1);
imagesc(im);
axis equal;
colormap gray;

% Zoom in on the area of interest(AOI)
% select zoom in area
z=[0,0; 1,1];
tries=1;
while( (z(1,1) < z(2,1) && z(1,2) < z(2,2)) || ...
            (z(1,1) > z(2,1) && z(1,2) > z(2,2)))
    if (tries == 4)
        uiwait(errordlg('Incorrect zoom parameters chosen'));
        f1.delete();
        return;
    elseif( tries > 1)
         uiwait(warndlg('Please select correct zoom parameters'));
    end;
    title('Zoom in AOI - select bottom left corner... ')
    [z(1,1),z(1,2)]=ginput(1);
    title('Zoom in AOI - select top right corner... ')
    [z(2,1),z(2,2)]=ginput(1);
    
    % correct parameters if simply flipped.
    if( z(1,1) > z(2,1) && z(1,2) < z(2,2) )
        t=z(1,:); z(1,:)=z(2,:); z(2,:)=t;
        break;
    end;
    
    % Increment tries counter;
    tries=tries+1;
end;
%zoom in

axis([z(1,1),z(2,1), z(2,2),z(1,2)])

% allocate size for array variables.
ixg = zeros(nbrepeat);
iyg = zeros(nbrepeat);
ixd = zeros(nbrepeat);
iyd = zeros(nbrepeat);

%select points on the image
for i=1:nbrepeat
    title('select a first point for the calibration... ')
    [ixg(i),iyg(i)]=ginput(1);
    title('select a second point for the calibration... ')
    [ixd(i),iyd(i)]=ginput(1);
    title('Done - Look at the command window for the next step')
end

% close figure
f1.delete();

% Type in the size of the reference object
ref_size=input('Type in the size of the reference object (in um): ');

% Compute pixel size  (double)
pixel_size=mean(ref_size./sqrt((ixg-ixd).^2+(iyg-iyd).^2));

% Display if requested
if( interactive )
    fprintf('\n');
    pixel_size = pixel_size(1);
    display( ['Pixel size (um):' num2str(pixel_size)] )
end;

% Stop here if justCalibrate
if( justCalibrate )
    returnValue = pixel_size;
    if( nargout == 2)
        returnValue = null;
        returnValue2 = pixel_size;
    end;
    return;
end;

%
% Otherwise, carry on to measure the distance between two points on the
% target image.
%

% Load image file
[filename, pathname, ~] = uigetfile({'*.jpg;*.tif;*.png','All Image Files';'*.*','All Files'},'Pick a target image file','MultiSelect','off');
% It's always nice to fail nicely.
if isequal(filename,0) || isequal(pathname,0)
	return;
end;

% read image.
im2=imread( [pathname filename]);

% print image
f2 = figure();
imagesc(im2)
colormap gray

% zoom in
% select zoom in area
z=[0,0; 1,1];
tries=1;
while( (z(1,1) < z(2,1) && z(1,2) < z(2,2)) || ...
            (z(1,1) > z(2,1) && z(1,2) > z(2,2)))
    if (tries == 4)
        uiwait(errordlg('Incorrect zoom parameters chosen'));
        f2.delete();
        return;
    elseif( tries > 1)
         uiwait(warndlg('Please select correct zoom parameters'));
    end;
    title('Zoom in AOI - select bottom left corner... ')
    [z(1,1),z(1,2)]=ginput(1);
    title('Zoom in AOI - select top right corner... ')
    [z(2,1),z(2,2)]=ginput(1);
    
    % correct parameters if simply flipped.
    if( z(1,1) > z(2,1) && z(1,2) < z(2,2) )
        t=z(1,:); z(1,:)=z(2,:); z(2,:)=t;
        break;
    end;
    
    % Increment tries counter;
    tries=tries+1;
end;
%zoom in

axis([z(1,1),z(2,1), z(2,2),z(1,2)])


%select points on the image
for i=1:nbrepeat
    title('select a first point for distance measurement... ')
    [ixg(i),iyg(i)]=ginput(1);
    title('select a second point for distance measurement... ')
    [ixd(i),iyd(i)]=ginput(1);
    title('Done - Look at the command window for the next step')
end

% Compute and print pixel size
pixel_dist=mean( sqrt( (ixg-ixd).^2+(iyg-iyd).^2) );
real_dist=pixel_dist.*pixel_size;

% close f2
f2.delete();

% Display distance if requested.
if( nbrepeat > 1 )
    pixel_dist = pixel_dist(1);
    real_dist = real_dist(1);
end;
if( interactive )
    fprintf('\n');
    display(['Size of the object (pix):' num2str(pixel_dist)])
    display(['Size of the object (um):' num2str(real_dist)])
end;

% at this step, the return value would be the real distance ...
% if nvarout == 1
% other wise, both real distance and pixel_size.

returnValue = real_dist;
% for when 2 outputs are called.
if( nargout == 2)
    returnValue2 = pixel_size;
end;


