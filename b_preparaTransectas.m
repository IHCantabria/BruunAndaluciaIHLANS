%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Genera el dominio

clear *; close all; clc; 

try init; catch me; cd ..; init; end
%% ------------------------ CARGANDO LOS DATOS ------------------------

pltFlag = 1; % quieres graficar?

%% ------------------------- SEPARANDO PERFILES -------------------------

xi=328803.436; yi=4041814.838;
xf=329725.341; yf=4041861.742;

dy=100; %[m]
lenTRS=600; %[m]

RefSL=ReferenceSL;
RefSL=RefSL.init(xi,yi,xf,yf);

TRS=Transects2;
TRS=TRS.init(RefSL,dy,lenTRS);

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

% [Lat,Lon] = projinv(Proj,[RefSL.xi RefSL.xf],[RefSL.yi RefSL.yf]);

ShapeRef = mapshape([RefSL.xi RefSL.xf],[RefSL.yi RefSL.yf]);

% ShapeRef.ProjectedCRS = Proj;
% ShapeRef.Filename = 'testRefLine.shp';

%% --- GUARDA DATOS ---
% save([pathRes 'EnsamblesProfiles.mat'],'ENS')
shapewrite(ShapeRef,'testRefLine.shp')

%% --------------------------END--------------------------