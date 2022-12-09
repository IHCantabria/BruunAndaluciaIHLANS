%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Genera el dominio

clear *; close all; clc; 

try init; catch me; cd ..; init; end
%% ------------------------ CARGANDO LOS DATOS ------------------------

load('EnsamblesProfiles.mat');
pltFlag = 1; % quieres graficar?

xi=364427.109; yi=4051734.355;
xf=368993.083; yf=4058795.609;

dy=100; %[m]
lenTRS=1500; %[m]

%% ------------------------- SEPARANDO PERFILES -------------------------



RefSL=ReferenceSL;
RefSL=RefSL.init(xi,yi,xf,yf);

TRS=Transects2;
TRS=TRS.init(RefSL,dy,lenTRS);
TRS=TRS.addSamples(ENS);

%% ------------------------- SEPARANDO PERFILES -------------------------

if pltFlag
    fig1 = figure; 
    plot([RefSL.xi RefSL.xf],[RefSL.yi RefSL.yf],'r-',LineWidth=1.2)
    hold on;
    for i=1:numel(TRS.xin); plot([TRS.xin(i),TRS.xof(i)],...
        [TRS.yin(i),TRS.yof(i)],'k-'); 
    end
    ax=gca;
    ax.YLabel.String = 'Y [UTM]';
    ax.XLabel.String = 'X [UTM]';
    ax.FontSize=12;
    ax.FontWeight='bold';
    legend('Ref. Line', 'Transectos');
    axis equal; grid; grid minor;
end

%% ------------------ GIARDANDO UN SHAPEFILE DEL DOMINIO -----------------
% [ETSG: 3042; ETRS89 / UTM zone 30N (N-E)]

Proj=projcrs(3042);

for i=1:numel(TRS.xin)
    XTRS{i}=[TRS.xin(i) TRS.xof(i)];YTRS{i}=[TRS.yin(i) TRS.yof(i)];
end

ShapeRef = mapshape([RefSL.xi RefSL.xf],[RefSL.yi RefSL.yf]);
ShapeTRS = mapshape(XTRS,YTRS);

%% --- GUARDA DATOS ---

% shapewrite(ShapeRef,[pathRes 'testRefLine.shp'])
% shapewrite(ShapeTRS,[pathRes 'Transectas.shp'])
save([pathRes 'TRS_Fuengi.mat'],'TRS')

%% --------------------------END--------------------------