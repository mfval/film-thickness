clear all
close all
clc

fs=100; %sampling frequency Hz
Nfiles=4; %number of files

Location={'F:\aug_23\' ; 'F:\aug_23\'; 'F:\aug_23\'; 'F:\aug_23\'}
Filename={'30v10lmanual_thickness.mat'; '30v10lmanualpulses_2_thickness.mat';'30v10lmanualpulses_3_thickness.mat';'35v10lmanual_thickness.mat'}
Markercolor={'-k';'-r';'b-';'m-';'g-';'-c'}
LegendStr={'30v10l';'30v10l pulses';'30v10l pulses b';'35v10l'}
startIndx=[1 500 500 1]; %when to start averaging
stopIndx=[0 500 500 0]; %How many images before the end do you want to keep

for i=1:Nfiles
    Data=load([char(Location(i,:)),char(Filename(i,:))]);
    FilmThickness=Data.IndFT(startIndx(i):(end-stopIndx(i)));
    
    figure(1)
    hold on
    plot(((1:length(FilmThickness))-1)./fs,FilmThickness,char(Markercolor(i,:)));
    xlabel('t (s)')
    ylabel('Film Thickness (\mu m)')
    legend(LegendStr)
    
    meanThickness(i)=[mean(FilmThickness)];

    N=length(FilmThickness);
    xbins=linspace(5,350,70);

    figure(2)
    hold on
    plot(xbins,hist(FilmThickness,xbins)/N,char(Markercolor(i,:)))
    xlabel('Optical Film Thickness [micrometers]')
    ylabel('Frequency [%]')
    grid on
    legend(LegendStr)
    
    %%Compute fft
    Y = fft(FilmThickness); %fft of signal
    L= length(FilmThickness); %Length of signal
    P = abs(Y/L);  %symmetrical power spectrum
    PP = P(1:L/2+1); %positive part of power spectrum
    PP(2:end-1) = 2*PP(2:end-1); %positive part of power spectrum
    f = fs*(0:(L/2))/L; %frequency

    figure(3)
    hold on
    plot(f,PP,char(Markercolor(i,:)))
    axis([0 5 0 10])
    title('Power Spectrum')
    xlabel('f (Hz)')
    ylabel('Thickness PSD')
    legend(LegendStr)

%     clear FilmThickness
end
    display(['Mean Thicknesses (um):' num2str(meanThickness)])



