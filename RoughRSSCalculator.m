
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION TO DEFINE A ROUGH METRIC FOR RECEIVED SIGNAL STRENGTH of ACOMMS transmissions 
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
% Test Script
% 
% mindistance = 0.1;
% maxdistance = 100;
% distanceinterval= 0.1;
% distancescale =  mindistance:distanceinterval:maxdistance;
% 
% minfrequency = 100;
% maxfrequency = 100000;
% freqinterval= 100;
% frequencyscale =  minfrequency:freqinterval:maxfrequency;
% 
% 
% for distanceindex=1:length(distancescale)
% for frequencyindex =1:length(frequencyscale)
% RSSIMatrix(distanceindex,frequencyindex)=RoughRSSCalculator(frequencyscale(frequencyindex),180,1,distancescale(distanceindex),1,1,1);
% end
% end
% 
% NoiseLvl=70 %arbitary Background Noise
% 
% RSSIMatrixaboveNoise=(RSSIMatrix>NoiseLvl).*RSSIMatrix;
% RSSIMatrixaboveNoise(RSSIMatrixaboveNoise==0)=nan;
% 
% figure(1)
% 
% [xx,yy] = meshgrid(frequencyscale,distancescale);
% 
% h=surf(xx,yy,RSSIMatrixaboveNoise);
% set(h,'LineStyle','none')
% xlabel ('Frequency in Hz')
% ylabel ('Range in km')
% zlabel ('Power in dBuPa')
% 
% 
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [RSS] = RoughRSSCalculator(Frequency,SPL,IsSoundChannel,OverallRange,DITx,DIRx,DistancetoSoundChannelAxis)

A = 2.34e-6;
B = 3.38e-6;
S = 35;%Salinity of Ocean
P = 100;%Hydrostatic Pressure
T = 10; %temperature



F=Frequency/1000;


if F > 3
    
    FT=21.9*10^[6-(1520/(T+273))];
    
    SpecificAtt = 8.68e3*[(S*A*FT*F^2)/(FT^2+F^2)]+[(B*F^2/FT)]*[1-6.54e-4*P]; %based on Sams book
    
else
    
    SpecificAtt = (0.11*F^2/(1+F^2))+(44*F^2/(4100+F^2));
    
end

%SpecificAtt = 3.3e-3+(0.11*F^2/(1+F^2))+(44*F^2/(4100+F^2))+3e-4*F^2; %Defined in page 24 of NATO SONAR book as attenuation per km in dB F is in KHz Defined for a temperature of 4 degrees centrigrade salinity of 35 pptm, pH of 8.0 and depth of approx 1000m

TransmissionLossSA = (OverallRange)*SpecificAtt; %Transmission Loss according to Path length

if IsSoundChannel == 1
    
    SphereSpreadLoss = 20*log10(DistancetoSoundChannelAxis); %assume Spherical Spreading loss to sound channel axis (based on source depth)
    
    CylindricalLoss = 10*log10(OverallRange*1000); %Making the assumption that distance into sound channel (laterally) is minimal
    
    TransmissionLoss = TransmissionLossSA + SphereSpreadLoss + CylindricalLoss;
    
else
    
    SphereSpreadLoss = 20*log10(OverallRange*1000);
    
    TransmissionLoss = TransmissionLossSA + SphereSpreadLoss; %Likely include lots of other losses to bottom and sea surface interaction
    
end

RSS =  SPL - TransmissionLoss + DITx+DIRx;

end



