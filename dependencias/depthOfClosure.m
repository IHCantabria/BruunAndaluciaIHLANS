function dc=depthOfClosure(Hs12,Ts12)
%    ###########################################################################    
%    # Closure depth, Birkemeier(1985)
%    # Hs12:     Significant wave height exceed 12 hours in a year.
%    # Ts12:     Significant wave period exceed 12 hours in a year.
%    # hs_ecdf = ECDF(hsDOWserie)
%    # f_hs = interpolate.interp1d(hs_ecdf.y,hs_ecdf.x)
%    # Hs12 = f_hs(1-12./365./24.)
%    # Ts12 = 5.7*np.sqrt(Hs12)
%    ###########################################################################
        
dc = 1.75.*Hs12 - 57.9.*(Hs12.^2./(9.81.*Ts12.^2));
    
end