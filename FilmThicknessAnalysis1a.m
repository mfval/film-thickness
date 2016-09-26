clear all
close all
clc

fs=100; %sampling frequency Hz

Location1='F:\aug_22\';
Location2='F:\aug_22\';
Location3='F:\aug_22\';
% Location2='E:\2016Data\FilmThickness2016\';
% Location3='E:\2016Data\FilmThickness2016\';
% Location4='E:\2016Data\FilmThickness2016\';
% Location5='E:\2016Data\FilmThickness2016\';
% Location6='E:\2016Data\FilmThickness2016\';

%Win1='Win1';
%Win2='Win4';
%Win3='Win7';

String1='30v10l_thickness.mat';
String2='35v10l_man_thickness.mat';
String3='40v10l_thickness.mat';
% String2='25v10l_thickness.mat';
% String3='30v10l_thickness.mat';
% String4='40v10l_thickness.mat';
% String5='45v10lb_thickness.mat';
% String6='50v10ld_thickness.mat';

Data1=load(strcat(Location1,String1));
Data2=load(strcat(Location2,String2));
Data3=load(strcat(Location3,String3));
% Data4=load(strcat(Location4,String4));
% Data5=load(strcat(Location5,String5));
% Data6=load(strcat(Location6,String6));

figure(1)
plot(((1:length(Data1.IndFT))-1)./fs,Data1.IndFT,'k');
hold on
plot(((1:length(Data2.IndFT))-1)./fs,Data2.IndFT,'r');
plot(((1:length(Data3.IndFT))-1)./fs,Data3.IndFT,'b');
% plot(((1:length(Data4.IndFT))-1)./fs,Data4.IndFT,'b');
% plot(((1:length(Data5.IndFT))-1)./fs,Data5.IndFT,'b');
% plot(((1:length(Data6.IndFT))-1)./fs,Data6.IndFT,'b');
%legend(String2,String3)%,String3);
% legend(String1,String2);
xlabel('t (s)')
ylabel('Film Thickness (\mu m)')
hold off

mean=[Data1.FT Data2.FT Data3.FT] % Data4.FT Data5.FT Data6.FT]

N1=length(Data1.IndFT);
N2=length(Data2.IndFT);
N3=length(Data3.IndFT);
% N4=length(Data4.IndFT);
% N5=length(Data5.IndFT);
% N6=length(Data6.IndFT);
xbins=linspace(5,350,70);

figure(3)
hold on
plot(xbins,hist(Data1.IndFT,xbins)/N1,'k')
plot(xbins,hist(Data2.IndFT,xbins)/N2,'r')
plot(xbins,hist(Data3.IndFT,xbins)/N3,'b')
% plot(xbins,hist(Data4.IndFT,xbins)/N4,'c')
% plot(xbins,hist(Data5.IndFT,xbins)/N5,'m')
% plot(xbins,hist(Data6.IndFT,xbins)/N6,'g')
%legend(strcat(Win2,String2),strcat(Win3,String3));%strcat(Win1,String1),
xlabel('Optical Film Thickness [micrometers]')
ylabel('Frequency [%]')
grid on
%legend(String1,String2);
hold off

%%Compute fft
Y1 = fft(Data1.IndFT); %fft of signal
L1= length(Data1.IndFT); %Length of signal
P1 = abs(Y1/L1);  %symmetrical power spectrum
PP1 = P1(1:L1/2+1); %positive part of power spectrum
PP1(2:end-1) = 2*PP1(2:end-1); %positive part of power spectrum
f1 = fs*(0:(L1/2))/L1; %frequency

Y2 = fft(Data2.IndFT); %fft of signal
L2= length(Data2.IndFT); %Length of signal
P2 = abs(Y2/L2);  %symmetrical power spectrum
PP2 = P2(1:L2/2+1); %positive part of power spectrum
PP2(2:end-1) = 2*PP2(2:end-1); %positive part of power spectrum
f2 = fs*(0:(L2/2))/L2; %frequency
 
Y3 = fft(Data3.IndFT); %fft of signal
L3= length(Data3.IndFT); %Length of signal
P3 = abs(Y3/L3);  %symmetrical power spectrum
PP3 = P3(1:L3/2+1); %positive part of power spectrum
PP3(2:end-1) = 2*PP3(2:end-1); %positive part of power spectrum
f3 = fs*(0:(L3/2))/L3; %frequency

% Y6 = fft(Data6.IndFT); %fft of signal
% L6= length(Data6.IndFT); %Length of signal
% P6 = abs(Y6/L6);  %symmetrical power spectrum
% PP6 = P6(1:L6/2+1); %positive part of power spectrum
% PP6(2:end-1) = 2*PP6(2:end-1); %positive part of power spectrum
% f6 = fs*(0:(L6/2))/L6; %frequency

figure(4)
plot(f1,PP1,'k')
hold on
plot(f2,PP2,'r')
plot(f3,PP3,'b')
% plot(f6,PP6,'g')
title('Power Spectrum')
xlabel('f (Hz)')
ylabel('Thickness PSD')



