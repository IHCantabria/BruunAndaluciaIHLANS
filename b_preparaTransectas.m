%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Genera el dominio

clear *; close all; clc; 

try init; catch me; cd ..; init; end
%% ------------------------ CARGANDO LOS DATOS ------------------------

% load("EnsamblesProfiles.mat");

%% ------------------------- SEPARANDO PERFILES -------------------------

xi=0; yi=0;
xf=0; yf=2000;

dy=100; %[m]

RefSL=ReferenceSL;
RefSL=RefSL.init(xi,yi,xf,yf);

TRS=Transects2;
TRS=TRS.init(RefSL,dy);


%% --- GUARDA DATOS ---
% save([pathRes 'EnsamblesProfiles.mat'],'ENS')

%% --------------------------END--------------------------