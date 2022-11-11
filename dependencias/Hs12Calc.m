function [Hs12,Ts12]=Hs12Calc(Hs,Tp)

%     ###########################################################################    
%     # Significant Wave Height exceed 12 hours a year
%     #
%     # INPUT:
%     # Hs:     Significant wave height.
%     # Tp:     Wave Peak period.
%     #
%     # OUTPUT:
%     # Hs12:     Significant wave height exceed 12 hours in a year.
%     # Ts12:     Significant wave period exceed 12 hours in a year.
%     ###########################################################################   

Hs12=zeros(size(Hs));
Ts12=zeros(size(Tp));
for i=1:size(Hs,2)
    Hs12calc=prctile(Hs(:,i),((365*24-12)/(365*24))*100);
    buscHS12=Hs(:,i)>=(Hs12calc-0.1) & Hs(:,i)<=(Hs12calc+0.1);
    [f,xi]=ksdensity(Tp(buscHS12,i));
    [~,ii]=max(f);
    Ts12(:,i)=xi(ii);
    Hs12(:,i)=Hs12calc;
end
end