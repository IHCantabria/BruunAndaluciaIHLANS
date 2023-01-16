%% calibrando cross-shore model
init();

kero=2e-2;
kacr=1e-4;

P = [1e-2 5e-6 1;
    .1 1e-5 2;
    .5 3e-5 3;
    1 8e-5 4];

Q = P;

calibraKF(kero(1),kacr(1),4,P(2,1:2),Q(2,1:2),['soloCS']);

clc; clear *;
load('Fuengirola.mat')

nTRS=numel(INPUT.PERF);
DYNP=INPUT.DYNP;
DYN=INPUT.DYN;
d50=[INPUT.PERF.d50];
gamma=INPUT.gamma; refNMM=0;
PERF=INPUT.PERF;

INPUT.kacr=INPUT.kacr.*ones(1,nTRS);
INPUT.kero=INPUT.kero.*ones(1,nTRS);

Ycti=zeros(1,nTRS);

PLCS_CS=cumsum(ones(1,nTRS));

tiempo=DYN.t;

for it=1:numel(tiempo)

    Hi=reduce_estructuras(DYNP,'Hb',it);
    D0=reduce_estructuras(DYNP,'Dir0',it);
    Di=reduce_estructuras(DYNP,'Dirb',it);
    w0=reduce_estructuras(DYNP,'wb',it); 
    AT0=reduce_estructuras(DYNP,'AT',it);
    SS0=reduce_estructuras(DYNP,'SS',it);
    SLR0=reduce_estructuras(DYNP,'SLR',it);
    
    wbd=szonewidth(Hi./gamma,'DEAN_A',PERF);

    [Ycti,posero,RES.DYeq(it,:),RES.Yeq(it,:)]=calcula_cshore_md(Ycti,wbd,Hi,SS0,AT0,INPUT.kacr,INPUT.kero,INPUT.dy0,PLCS_CS,INPUT.dt,[PERF.Berma],DYN.SLR(it),[PERF.dc],[PERF.d50]);
    RES.wbd(it,:)=wbd;
    RES.Yct(it,:)=Ycti;
    RES.t_output(it)=DYN.t(it);

end

evalua_CS(INPUT,RES,10);
evalua_CS(INPUT,RES,40);
evalua_CS(INPUT,RES,80);