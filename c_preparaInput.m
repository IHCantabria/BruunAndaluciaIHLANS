%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prepara el INPUT del IH-LANS

clear *; close all; clc; 

try init; catch me; cd ..; init; end
%% ------------------------ CARGANDO LOS DATOS ------------------------

% Nombre del perfil de análisis 
load('DOW.mat','hs','dir','tps','depth','time');timeW=time;
load('GOS.mat','zeta','time');timeSS=time;
load('GOT.mat','tide','time');timeT=time;
clear time;

%% --------------------------- PERFILES ---------------------------

[Hs12,Ts12]=Hs12Calc(hs,tps);
dc=depthOfClosure(Hs12,Ts12);

timeENS=WAVEC.time(idx);
INPUT.PERF=INPUT.PERF(1:10);

% xon=0:100:1000;
for i = 1:10
    INPUT.PERF(i).xon=transects(i).xi;
    INPUT.PERF(i).xof=transects(i).xe;
    INPUT.PERF(i).yon=transects(i).yi;
    INPUT.PERF(i).yof=transects(i).ye;
    INPUT.PERF(i).Tipo='lcs';
%     INPUT.PERF(i).yof=600;
    INPUT.PERF(i).yc=dc;
    
    INPUT.PERF(i).dc=CNST.dc(2,1);
    INPUT.PERF(i).d50=3e-4;
%     INPUT.PERF(i).Adean=??;
    INPUT.PERF(i).Berma=1;
%     INPUT.PERF(i).Yberma=200;
    INPUT.PERF(i).date_obs=timeENS;
    INPUT.PERF(i).Y_obs_lt=Yobs_lt;
    INPUT.PERF(i).Y_obs_ct=Yobs_ct;
    INPUT.PERF(i).Rc=6.5;
    INPUT.PERF(i).nbati=transects(i).alfan;
end

%% -------------------------- FORZAMIENTO --------------------------

nwav=numel(hs);
time=timeW;

% INPUT.DYN.X=1000;
% INPUT.DYN.Y=1000;


INPUT.DYN.Hs=hs;
INPUT.DYN.Tp=tps;
INPUT.DYN.Dir=dir;
INPUT.DYN.SS=zeta;
INPUT.DYN.AT=tide(1:nwav);
INPUT.DYN.SLR=SLR;
INPUT.DYN.h0=depth;
INPUT.DYN.t=time;

%% ----------------------- PARAMETROS DEL MODELO -----------------------

INPUT.t = time;
INPUT.dt = 1;
INPUT.calcularotura = 1;
INPUT.inthidromorfo = 0;
INPUT.alpha_int=1;
INPUT.gamma=.55;
INPUT.kcerc=200;
INPUT.bctype={'Dirichlet','Dirichlet'};
% INPUT.bctype={'Neumann','Neumann'};
INPUT.bctypeval=[0,0;0,0];
INPUT.fcourant=.1;
% INPUT.kacr=kacr;
% INPUT.kero=kero;
% INPUT.tstab=??;
% INPUT.tcent=??;
INPUT.plott=0;
INPUT.toutp=1;
INPUT.data_asim_l=0;
INPUT.data_asim_c=1;
INPUT.data_asim_lc=0;
INPUT.path_save='C:\Users\freitasl\Documents\MATLAB\Results\FuengirolaIHLANS';

INPUT.OUTPUTPERF_ASIM=1:10;

save([pathRes 'Fuengirola.mat'],"INPUT",'-mat');
