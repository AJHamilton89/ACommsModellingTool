clear all



SS = 1500;

MaxRange = 1000000;

MinRange = 100;

RangeInt = 100;

RangeScale= MinRange:RangeInt:MaxRange;


maxduration =20;

Packetsize=500;

Datarate=3000;

Packettime=Packetsize/Datarate;


for CommsProt = 1:maxduration
    
    for n = 1:length(RangeScale)
        
        ToF = RangeScale(n)/SS;
        Tottime(CommsProt,n) = ToF + CommsProt;
        percenttime(CommsProt,n) = CommsProt/Tottime(CommsProt,n);
        
        Tottimedata(CommsProt,n) = ToF + CommsProt;
        Goodput(CommsProt,n)=Packetsize/Tottimedata(CommsProt,n);
        
    end
    
end
figure

hold on
for n = 1:maxduration
   
    plot(percenttime(n,:))

end
xlabel('Range')
ylabel('Percentage of time utilised for transmission')
ylim([0 1])
set(gca,'XScale','log')
set(gca,'YScale','linear')
hold off


figure

for n = 1:maxduration
    hold on
    loglog(Goodput(n,:))
    hold off
    
    
end
xlabel('Range')
ylabel('Goodput')
set(gca,'XScale','log')
set(gca,'YScale','linear')




