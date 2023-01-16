%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calcula el A de Dean para los perfiles seleccionados



clear *; close all; clc; 

try init; catch me; cd ..; init; end

warning off;
%% ------------------------ CARGANDO LOS DATOS ------------------------

% Nombre del perfil de análisis 
archivo='Perfiles_ajuste.xlsx';

pltFlag=1;

aux=readtable('Limites.xlsx'); 
limX=aux.maxX; limX=fillmissing(limX,'linear');

NMM=1.52;

dc=4;

nTRS=12;

%% ------------------------ AJUSTE PERFILES ------------------------

pos=[50 50 700 300];
A=zeros(nTRS,1);

DeanCurve=fittype('A*x^(2/3)','dependent',{'y'},'independent',{'x'},...
    'coefficients',{'A'});

for i=1:nTRS
    close all;
    prf=readtable(archivo,Sheet=['Hoja' num2str(i)]);
    x=prf.Var1;
    z=-prf.Var2-NMM;
    [~,ii]=min(abs(z));x=x(ii:end);z=z(ii:end);
    [~,ii]=min(abs(z-dc));x=x(1:ii);z=z(1:ii);
    x=x-x(1);
    
    diff=z(2:end)-z(1:end-1);
%     ii=find(diff<0);
    ii=diff<0;

    z(ii)=nan;
    z=fillmissing(z,"linear");

    diff=z(2:end)-z(1:end-1);
    ii=diff==0;
    z(ii)=nan;

    z=fillmissing(z,"linear");

%     [~,ii]=min(abs(x-limX(i)));x=x(1:ii);z=z(1:ii);

    [miAj,gof]=fit(x,z,DeanCurve, fitoptions('Method','NearestInterpolant'));

    A(i)=miAj.A;

    if pltFlag
        figure(Position=pos);
        plot(x,z,'bx',MarkerSize=10,LineWidth=4);
        hold on;
        ajustado=plot(miAj);
        ajustado.LineWidth=2;
        grid; grid minor;
        set(gca, 'YDir','reverse')
        ax=gca();
        ax.YLabel.String='h [m]';
        ax.XLabel.String='x [m]';
        ax.FontWeight="bold";
        legend('Datos', ['Ajuste: h=' num2str(miAj.A) 'x^2^/^3'])   
%         title('La Muralla')
    end
    
end

save([pathRes 'A_Dean.txt'],'A','-ascii');


%% ------------------------ FIN ------------------------