function [XN, YN]=abs_pos(X0,Y0,phi,dn)
%     #####################    
%     # INPUT:
%     #
%     # X0 : x coordinate, origin of the transect
%     # Y0 : y coordinate, origin of the transect
%     # phi : transect orientation in radians
%     # dn : position on the transect
%     #
%     # OUTPUT:
%     # XN : x coordinate
%     # YN : y coordinate
%     #####################
n=size(dn,1);
XN = X0 + dn.*cos(phi);
YN = Y0 + dn.*sin(phi);
    
%     return XN, YN

end