function r=BruunRule(hc,D50,Hberm,slr)
%    ###########################################################################    
%    # Bruun Rule
%    # INPUT:
%    # hc:     depth of closure
%    # D50:      Mean sediment grain size (m)
%    # Hberm:    Berm Height (m)
%    # slr:      Expected Sea Level Rise (m)
%    # OUTPUT:
%    # r:        expected progradation/recession (m)
%
%    ###########################################################################    
Wc = wast(hc,D50);

r=slr.*Wc./(Hberm+hc);

end