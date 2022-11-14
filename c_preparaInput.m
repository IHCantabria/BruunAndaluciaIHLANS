%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prepara el INPUT del IH-LANS

clear *; close all; clc; 

try init; catch me; cd ..; init; end

warning off;
%% ------------------------ CARGANDO LOS DATOS ------------------------

% Nombre del perfil de análisis 
load('DOW.mat','hs','dir','tps','depth','time','lat','lon');timeW=time;
load('GOS.mat','zeta','time');timeSS=time;
load('GOT.mat','tide','time');timeT=time;
clear time;
load('EnsamblesProfiles.mat');
load('Ej_INPUT.mat');
load('Punto_0704_SSP245.mat');
pltFlag=0;

Proj = projcrs(3042);

%% ------------------------ CARGANDO DOMINIO ------------------------

d50=3e-3;
perf = 2488:2509;
Domain = shaperead('PERF_total.shp');
Domain = Domain(perf(1):perf(end));


if pltFlag
    fig1 = figure; 
    hold on;
    for i=1:numel(Domain); plot(Domain(i).X, Domain(i).Y,'r-',LineWidth=1.5); 
    end
    ax=gca;
    ax.YLabel.String = 'Y [UTM]';
    ax.XLabel.String = 'X [UTM]';
    ax.FontSize=12;
    ax.FontWeight='bold';
    legend('Transectos');
    axis equal; grid; grid minor;
end

%% --------------------------- PERFILES ---------------------------

[Hs12,Ts12]=Hs12Calc(hs,tps);
dc=depthOfClosure(Hs12,Ts12);

nTRS=numel(perf);

INPUT.PERF=INPUT.PERF(1:nTRS);

for i = 1:nTRS
    INPUT.PERF(i).xon=Domain(i).X(1);
    INPUT.PERF(i).xof=Domain(i).X(2);
    INPUT.PERF(i).yon=Domain(i).Y(1);
    INPUT.PERF(i).yof=Domain(i).Y(2);
    INPUT.PERF(i).Tipo='lcs';
%     INPUT.PERF(i).yof=600;
    INPUT.PERF(i).yc=510;
    INPUT.PERF(i).dc=dc(1);
    INPUT.PERF(i).d50=d50;
%     INPUT.PERF(i).Adean=??;
    INPUT.PERF(i).Berma=1;
    INPUT.PERF(i).Yberma=480;
    INPUT.PERF(i).nbati=120+rad2deg(atan((Domain(i).Y(2)-Domain(i).Y(1))/...
        (Domain(i).X(2)-Domain(i).X(1))));
    INPUT.PERF(i).date_obs=ENS.time;
    INPUT.PERF(i).Y_obs_lt=ENS.Y_obs_lt;
    INPUT.PERF(i).Y_obs_ct=ENS.Y_obs_st;

end

%% -------------------------- FORZAMIENTO --------------------------

time=[timeW(1):1/24:datenum('2100-01-01 00:00:00')]';
tide=tide(1:numel(hs));

nRep=ceil(numel(time)/numel(hs));

hs=repmat(hs,[nRep,1]); hs=hs(1:numel(time));
tps=repmat(tps,[nRep,1]); tps=tps(1:numel(time));
dir=repmat(dir,[nRep,1]); dir=dir(1:numel(time));
zeta=repmat(zeta,[nRep,1]); zeta=zeta(1:numel(time)); zeta(isnan(zeta))=0;
tide=repmat(tide,[nRep,1]); tide=tide(1:numel(time));

time=[time(1):1:datenum('2100-01-01 00:00:00')]';

k=1;
%reduciendo el input para 1 día
for i=1:numel(time)
   [Hs(i),ii]=max(hs(k:k+23));aux=tps(k:k+23);
   Tp(i)=aux(ii);aux=dir(k:k+23);
   Dir(i)=aux(ii);aux=zeta(k:k+23);
   Surge(i)=aux(ii);aux=tide(k:k+23);
   Tide(i)=aux(ii);
    
   Hs(i)=mean(hs(k:k+23));
   Tp(i)=mean(tps(k:k+23));
   Dir(i)=mean(dir(k:k+23));
   Surge(i)=mean(zeta(k:k+23));
   Tide(i)=mean(tide(k:k+23));
   k=i+24;
end

INPUT.DYN.Hs=Hs';
INPUT.DYN.Tp=Tp';
INPUT.DYN.Dir=Dir';
INPUT.DYN.SS=Surge';
INPUT.DYN.AT=Tide';
INPUT.DYN.h0=depth;
INPUT.DYN.t=time;
[INPUT.DYN.X,INPUT.DYN.Y] = projfwd(Proj,lat,lon);

%% -------------------------- SLR --------------------------

t_anual=[time(1)-1/24 t_anual]';
SLChge_anual = [0 0 0 ; SLChge_anual];


SLR=interp1(t_anual,SLChge_anual(:,2),time);


INPUT.DYN.SLR=SLR;

% hb=.39.*9.81.^(1/5).*(Tp'.*HoFromHs(Hs',Tp',depth)).^(2/5);
% 
% RSLR=wast(hb,d50).*SLR./(dc(1)+1);

% INPUT.RSLR=SLR;

%% ----------------------- PARAMETROS DEL MODELO -----------------------

INPUT.t = time;
INPUT.dt = 24;
INPUT.calcularotura = 1;
INPUT.inthidromorfo = 0;
INPUT.alpha_int=1;
INPUT.gamma=.55;
INPUT.kcerc=200;
INPUT.bctype={'Dirichlet','Dirichlet'};
% INPUT.bctype={'Neumann','Neumann'};
INPUT.bctypeval=[0,0;0,0];
INPUT.fcourant=.1;
INPUT.kacr=0.03;
INPUT.kero=0.25;
INPUT.dy0=-15;
% INPUT.tstab=??;
% INPUT.tcent=??;
INPUT.plott=0;
INPUT.toutp=1;
INPUT.data_asim_l=1;
INPUT.data_asim_c=1;
INPUT.data_asim_lc=1;
% INPUT.path_save='';

INPUT.OUTPUTPERF_ASIM=1:nTRS;

clearvars -except INPUT pathRes wrkDir

save([pathRes 'Fuengirola.mat'],"INPUT",'-mat');



RES=IH_LANS(INPUT);
