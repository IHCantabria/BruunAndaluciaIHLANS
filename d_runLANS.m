%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RUN IH-LANS

clear *;
init();

load("TRS_Muralla.mat");


kcerc=repmat(0.5,[1,TRS.nTRS]);

kero=repmat(3e-3,[1,numel(kcerc)]);
kacr=repmat(5e-4,[1,numel(kcerc)]);


skill=zeros([numel(keroIN),numel(kacrIN),numel(kcerc)]);
R2=zeros([numel(keroIN),numel(kacrIN),numel(kcerc)]);
RMSE=zeros([numel(keroIN),numel(kacrIN),numel(kcerc)]);
cargador=0;

for i=1:numel(keroIN)
    for j=1:numel(kacrIN)
        
        [INPUT]=calibraKF(kero.*keroIN(i), kacr.*kacrIN(j), kcerc,...
            'CalibraoKF_KF_dt=24h',5,cargador);
        RES5=IH_LANS(INPUT);
        [INPUT]=calibraKF(kero.*keroIN(i), kacr.*kacrIN(j), kcerc,...
            'CalibraoKF_KF_dt=24h',50,cargador);
        RES50=IH_LANS(INPUT);RES=RES50;
        [INPUT]=calibraKF(kero.*keroIN(i), kacr.*kacrIN(j), kcerc,...
            'CalibraoKF_KF_dt=24h',95,cargador);
        RES95=IH_LANS(INPUT);
%         end
        cargador=1;
        for k=1:numel(kcerc)
            [skill(i,j,k), ~, R2(i,j,k),RMSE(i,j,k)]=...
                skillscore([INPUT.PERF(k).date_obs,...
                            INPUT.PERF(k).Y_obs_ct+...
                            INPUT.PERF(k).Y_obs_lt],...
                           [RES.t_output, RES.YCT(:,k)+...
                           RES.YLT(:,k)]);
        end
    end
end


% save('kcerc.mat','kcerc');

Y = TRS.Y_Fisio;

tit=['Calibración Playa de La Muralla'];
evaluaResultados2(INPUT,RES5,1:12,tit,Y)

CAL_FINAL.INPUT=INPUT;
CAL_FINAL.RES5=RES5;

save([pathRes 'CALFIN.mat'],"CAL_FINAL",'-mat');

%% ------------------------ FIN ------------------------
