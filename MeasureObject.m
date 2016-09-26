%%%%Measure a distance of an object
%%%%Can use a calibration image
%%%%Arganthael Dec. 15th 2010
%%%%
%%%%
clear all
close all
clc

nbrepeat=1; %%%Number of times the user has to repeat the measurements

%%%%Load calibration file
[filename, pathname, filterindex] = uigetfile({'*.jpg','jpg files';'*.*','All files'},'Pick a calibration file (jpg)','MultiSelect','off');
im=imread( [pathname filename]);

%print image
figure(1)
imagesc(im)
axis equal
colormap gray

%%%%%Zoom in on the area of interest
%select zoom in area
title('Zoom in - select bottom left corner... ')
[ixz1,iyz1]=ginput(1);
title('Zoom in - select top right corner... ')
[ixz2,iyz2]=ginput(1);
%zoom in
axis([ixz1 ixz2 iyz2 iyz1])

for i=1:nbrepeat
    %select points on the image
    title('select a first point for the calibration... ')
    [ixg(i),iyg(i)]=ginput(1);
    title('select a second point for the calibration... ')
    [ixd(i),iyd(i)]=ginput(1);
    title('Done - Look at the command window for the next step')
end

%%%%%%Type in the size of the reference object
ref_size=input('Type in the size of the reference object (in um): ')

%%%%%Compute and print pixel size
pixel_size=mean(ref_size./sqrt((ixg-ixd).^2+(iyg-iyd).^2))
display(' ')
display(['Pixel size (um):' pixel_size])



%%%%Load image file
[filename2, pathname2, filterindex2] = uigetfile({'*.jpg','jpg files';'*.*','All files'},'Pick a calibration file (jpg)','MultiSelect','off');
im2=imread( [pathname2 filename2]);

%print image
figure(2)
imagesc(im2)
colormap gray

%%%%%Zoom in on the area of interest
%select zoom in area
title('Zoom in - select bottom left corner... ')
[ixz1b,iyz1b]=ginput(1);
title('Zoom in - select top right corner... ')
[ixz2b,iyz2b]=ginput(1);
%zoom in
axis([ixz1b ixz2b iyz2b iyz1b])

for i=1:nbrepeat
    %select points on the image
    title('select a first point for distance measurement... ')
    [ixgb(i),iygb(i)]=ginput(1);
    title('select a second point for distance measurement... ')
    [ixdb(i),iydb(i)]=ginput(1);
    title('Done - Look at the command window for the next step')
end

%%%%%Compute and print pixel size
pixel_dist=mean(sqrt((ixgb-ixdb).^2+(iygb-iydb).^2));
real_dist=pixel_dist*pixel_size;
display(' ')
display(['Size of the object (pix):' num2str(pixel_dist)])
display(['Size of the object (um):' num2str(real_dist)])
