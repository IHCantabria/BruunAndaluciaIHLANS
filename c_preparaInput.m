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

load('Ej_INPUT.mat');
load('Punto_0704_SSP245.mat');
load("TRS_Fuengi.mat");
% load('EnsamblesProfiles.mat');
pltFlag=0;

Proj = projcrs(3042);

%% ------------------------ CARGANDO DOMINIO ------------------------

d50=5e-4;
perf = 2334:2415;
Domain = shaperead('PERF_total.shp');
Domain = Domain(perf(1):perf(end));

if pltFlag  
    figure; 
    hold on;
    for i=1:numel(TRS.xin) %numel(Domain)
        plot([TRS.xin(i),TRS.xof(i)],[TRS.yin(i),TRS.yof(i)],'r-',LineWidth=1.5); 
%         plot(Domain(i).X, Domain(i).Y,'r-',LineWidth=1.5);
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

nTRS=numel(TRS.xin);

INPUT.PERF=INPUT.PERF(1:nTRS);

for i = 1:nTRS
    INPUT.PERF(i).xon=TRS.xin(i);%Domain(i).X(1);
    INPUT.PERF(i).xof=TRS.xof(i);%Domain(i).X(2);
    INPUT.PERF(i).yon=TRS.yin(i);%Domain(i).Y(1);
    INPUT.PERF(i).yof=TRS.yof(i);%Domain(i).Y(2);
    INPUT.PERF(i).Tipo='lcs';
    INPUT.PERF(i).yc=TRS.Y_inicial(i);
    INPUT.PERF(i).dc=dc(1);
    INPUT.PERF(i).d50=d50;
    INPUT.PERF(i).Adean=ADEAN(d50);
    INPUT.PERF(i).Berma=1;
    INPUT.PERF(i).Yberma=TRS.Y_inicial(i)-80;
    INPUT.PERF(i).nbati=90-rad2deg(atan((TRS.yof(i)-TRS.yin(i))/...
        (TRS.xof(i)-TRS.xin(i))));
%     rad2deg(atan((Domain(i).Y(2)-Domain(i).Y(1))/...
%         (Domain(i).X(2)-Domain(i).X(1))));
    INPUT.PERF(i).date_obs=TRS.t_obs;%ENS(i).time;
    INPUT.PERF(i).Y_obs_ct=TRS.Y_obs(:,i);%ENS(i).Yobs;
    INPUT.PERF(i).Y_obs_lt=TRS.Y_obs(:,i)-TRS.Y_obs(:,i);%zeros(size(ENS(i).Yobs));
    INPUT.PERF(i).R_c=5.5;
    INPUT.PERF(i).R=5;

    %P0=(e(Ylt) e(Kcerc) e(vlt))
    INPUT.PERF(i).rP0=diag([1 .5 1e-4]).^2;
    
    %Q=(del(Ylt) del(Kcerc) del(vlt))
    INPUT.PERF(i).rQ=diag([0.1 1e-1 1e-5]).^2;

    %P0ero=(e(Yst) e(Kero) 0 0 e(dy0))
    INPUT.PERF(i).rPero0_c=diag([1 .5 0 0 1]).^2; 
    %Qero=(del(Yst) del(Kero) 0 0 del(dy0))
    INPUT.PERF(i).rQero_c=diag([0.1 1e-1 0 0 .1]).^2;

    %P0ero=(0 0 e(Yst) e(Kacr) e(dy0))
    INPUT.PERF(i).rPacr0_c=diag([0 0 1 .5 1]).^2;
    %P0ero=(0 0 del(Yst) del(Kacr) del(dy0))
    INPUT.PERF(i).rQacr_c=diag([0 0 0.2 1e-1 .1]).^2;

end

%% -------------------------- FORZAMIENTO --------------------------

time=[timeW(1):1/24:datenum('2022-01-01 00:00:00')]';%[timeW(1):1/24:datenum('2100-01-01 00:00:00')]';
tide=tide(1:numel(hs));

nRep=ceil(numel(time)/numel(hs));

hs=repmat(hs,[nRep,1]); hs=hs(1:numel(time));
tps=repmat(tps,[nRep,1]); tps=tps(1:numel(time));
dir=repmat(dir,[nRep,1]); dir=dir(1:numel(time));
zeta=repmat(zeta,[nRep,1]); zeta=zeta(1:numel(time)); zeta(isnan(zeta))=0;
tide=repmat(tide,[nRep,1]); tide=tide(1:numel(time));


dt=1;
time=[time(1):1/24*dt:datenum('1995-01-01 00:00:00')]';


k=1;
%reduciendo el input para 1 día
for i=1:numel(time)
%    [Hs(i),ii]=max(hs(k:k+23));aux=tps(k:k+23);
%    Tp(i)=aux(ii);aux=dir(k:k+23);
%    Dir(i)=aux(ii);aux=zeta(k:k+23);
%    Surge(i)=aux(ii);aux=tide(k:k+23);
%    Tide(i)=aux(ii);
    
   Hs(i)=mean(hs(k:k+dt-1));
   Tp(i)=mean(tps(k:k+dt-1));
   Dir(i)=meanangle(dir(k:k+dt-1),[0 360]);
   Surge(i)=mean(zeta(k:k+dt-1));
   Tide(i)=mean(tide(k:k+dt-1));
   k=i+dt;
end
% 
% INPUT.DYN.Hs=hs;
% INPUT.DYN.Tp=tps;
% INPUT.DYN.Dir=dir;
% INPUT.DYN.SS=zeta;
% INPUT.DYN.AT=tide;

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
INPUT.dt = dt;
INPUT.calcularotura = 1;
INPUT.inthidromorfo = 0;
INPUT.alpha_int=1;
INPUT.gamma=.55;
INPUT.kcerc=70;
% INPUT.bctype={'Dirichlet','Dirichlet'};
INPUT.bctype={'Neumann','Neumann'};
INPUT.bctypeval=[0,0;0,0];
INPUT.fcourant=.1;
INPUT.kacr=5e-3;
INPUT.kero=0.02;
INPUT.dy0=0;
% INPUT.tstab=??;
% INPUT.tcent=??;
INPUT.plott=0;
INPUT.toutp=1;
INPUT.data_asim_l=1;
INPUT.data_asim_c=1;
INPUT.data_asim_lc=1;
INPUT.path_save=[];
INPUT.OUTPUTLIST={'Hbd','Dbd','wbd','Q','kest','dQdx','Qbc','saltoYlt',...
    'kcerc','vlt','saltoYct','kero','kacr','dy0','Yeq'};
INPUT.OUTPUTPERF_ASIM=1:nTRS;

clearvars -except INPUT pathRes wrkDir

save([pathRes 'Fuengirola.mat'],"INPUT",'-mat');

INPUT.path_save='C:\Users\freitasl\Documents\MATLAB\Results\FuengirolaIHLANS';
INPUT.nsave=['AGP_kc=' num2str(INPUT.kcerc,'%.0f')...
    '_ka=' num2str(INPUT.kacr,'%.5f') '_ke' num2str(INPUT.kero,'%.3f') '.mat'];

RES=IH_LANS(INPUT);
evaluaResultados(INPUT,RES);





