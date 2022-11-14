 function H0 = HoFromHs(Hs,T,h)

g = 9.81;
Cgo = 1./4.*g.*T./pi;
L=hunt(h,T);
C = L./T;
Cg = 0.5.*(1 + 4.*pi.*h./L./sinh(4.*pi.*h./L)).*C;

H0 = Hs.*sqrt(Cg./Cgo);