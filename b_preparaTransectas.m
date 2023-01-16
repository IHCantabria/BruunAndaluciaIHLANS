%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Genera el dominio

clear *; close all; clc; 

try init; catch me; cd ..; init; end
%% ------------------------ CARGANDO LOS DATOS ------------------------

load('EnsamblesProfiles.mat');

shapeFisio='C:\Users\freitasl\OneDrive\Documentos\IHCantabria-LUCAS-WS\Bruun_Andalucia\0_DATOS_MDT\LFisio_Cadiz.shp';
pltFlag = 1; % quieres graficar?
		

xi=207957.09196435384; yi=4053469.148830245;
xf=208269.55667316937; yf=4053416.8478704;

dy=25; %[m]
lenTRS=520; %[m]

%% ------------------------- SEPARANDO PERFILES -------------------------

RefSL=ReferenceSL;
RefSL=RefSL.init(xi,yi,xf,yf);

TRS=Transects2;
TRS=TRS.init(RefSL,dy,lenTRS);
TRS=TRS.addSamples(ENS,0);
TRS=TRS.addFisio(shapeFisio);

%% ------------------------- SEPARANDO PERFILES -------------------------

if pltFlag
    fig1 = figure; 
    plot([RefSL.xi RefSL.xf],[RefSL.yi RefSL.yf],'r-',LineWidth=1.2)
    hold on;
    plot(TRS.xFisio,TRS.yFisio,'m--')
    for i=1:numel(TRS.xin); plot([TRS.xin(i),TRS.xof(i)],...
        [TRS.yin(i),TRS.yof(i)],'k-');
    end
    
    ax=gca;
    ax.YLabel.String = 'Y [UTM]';
    ax.XLabel.String = 'X [UTM]';
    ax.FontSize=12;
    ax.FontWeight='bold';
    legend('Ref. Line', 'Línea Fisiográfica','Transectos');
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

shapewrite(ShapeRef,[pathRes 'testRefLine_Cadiz.shp'])
shapewrite(ShapeTRS,[pathRes 'Transectas_Cadiz.shp'])
save([pathRes 'TRS_Muralla.mat'],'TRS')

%% --------------------------END--------------------------