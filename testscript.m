%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test Scripte for A ROUGH METRIC FOR RECEIVED SIGNAL STRENGTH of ACOMMS transmissions 
%
% 
% Parameter Inputs
% 
% Frequency - Transmit Frequency, defined in Hz
% SPL - Source Power Level, defined in dBuPa@1m
% IsSoundChannel - Binary Identifier to show whether sound channel exists
% OverallRange - Range Between Tx and Rx, in m
% DITx - Directivity Index gain of Tx system
% DIRx - Directivity Index gain of Rx System
% DistancetoSoundChannelAxis - distance, in m, to sound channel axis
% 
% Defined by Alexander Hamilton on 19/2/20
% 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all

%% Set Variables

SPL = 170; % Source Pressure Level
SoundChannel = 0; % Binary Identifier to show whether sound channel exists
DITx = 1; % DI of TX
DIRx = 5; % DI of RX
DistancetoSoundChannelAxis=1; % how many meters of spherical spreading before entering 'waveguide of sound channel'
Q=3;% Q factor of Transducer (how much can it be driven by as a fraction of Fc)


%% Set Distance and Frequencies for Plots

mindistance = 4;
maxdistance = 100;
distanceinterval= 1;
distancescale =  mindistance:distanceinterval:maxdistance;

minfrequency = 4900;
maxfrequency = 5100;
freqinterval= 100;
frequencyscale =  minfrequency:freqinterval:maxfrequency;

transducerBWscale= frequencyscale./Q;

%% Run Code Section

for distanceindex=1:length(distancescale)
for frequencyindex =1:length(frequencyscale)
RSSIMatrix(distanceindex,frequencyindex)=RoughRSSCalculator(frequencyscale(frequencyindex),180,SoundChannel,distancescale(distanceindex),DITx,DIRx,DistancetoSoundChannelAxis);
end
end

%% Set Ocean Noise Background Level

NoiseLvl=70; %arbitary Background Noise

SNRMatrix=RSSIMatrix-NoiseLvl;

CapacityMatrix=1+log2(10.^SNRMatrix); % based off Shannon-Hartley theorem in AWGN channel
CapacityMatrix(CapacityMatrix<0)=nan;

for n = 1:length(frequencyscale)
 MaxDRMatrix(n,:) = CapacityMatrix(:,n).*transducerBWscale(n);
end


%% Plot some graphs

RSSIMatrixaboveNoise=(RSSIMatrix>NoiseLvl).*RSSIMatrix;
RSSIMatrixaboveNoise(RSSIMatrixaboveNoise==0)=nan;

figure

[xx,yy] = meshgrid(frequencyscale,distancescale);

h=surf(xx,yy,RSSIMatrixaboveNoise);
set(h,'LineStyle','none')
set(gca,'XScale','linear')
set(gca,'YScale','linear')
xlabel ('Frequency in Hz')
ylabel ('Range in km')
zlabel ('Power in dBuPa')


figure

[xxx,yyy] = meshgrid(frequencyscale,distancescale);

h=surf(xxx,yyy,MaxDRMatrix');
set(h,'LineStyle','none')
set(gca,'ZScale','linear')
set(gca,'XScale','linear')
set(gca,'YScale','linear')

xlabel ('Frequency in Hz')
ylabel ('Range in km')
zlabel ('Data Rate in bits per second')


