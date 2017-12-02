clear; clc; close all;

load noisdopp;
y = noisdopp;
Fs = 44100;

[h0,h1,g0,g1] = getFilterBank(4,0.55*pi,0.6*pi,0.5); %get the filter bank
[py,pind] = getPyramid(y,h0,h1,4); %decompose the signal 

py = setBand(py,pind,1,1,0); %set 10-20kHz to 0
py = setBand(py,pind,2,1,0); %set 5-10kHz to 0
py = setBand(py,pind,4,2,0); %set 0-1.25kHz to 0

band = getBand(py,pind,3,1); %get the 2.5-5kHz band
[pyBand,pindB] = getPyramid(band,h0,h1,1); %decompose the band
pyBand = setBand(pyBand,pindB,1,1,0); %set 3.75-5kHz to 0
band = reconstruct(pyBand,pindB,g0,g1,1); %reconstruct the band
py = setBand(py,pind,3,1,band); %apply the new band value to the pyramid

band = getBand(py,pind,4,1); %get the 1.25-2.5kHz band
[pyBand,pindB] = getPyramid(band,h0,h1,1); %decompose the band
pyBand = setBand(pyBand,pindB,1,2,0); %set 1.875-2.5kHz to 0
band = reconstruct(pyBand,pindB,g0,g1,1); %reconstruct the band
py = setBand(py,pind,4,1,band); %apply the new band value to the pyramid

yRec = reconstruct(py,pind,g0,g1,4); %reconstruct the audio signal
sound(yRec,Fs);

figure; 
plot(psd(spectrum.periodogram,y,'Fs',Fs,'NFFT',length(y)));
title('Original audio signal');
figure; 
plot(psd(spectrum.periodogram,yRec,'Fs',Fs,'NFFT',length(yRec)));
title('Bandpassed audio signal');
