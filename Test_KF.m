
init();

% kero=[5e-2];
% kacr=[1e-4];

[INPUT,RES]=calibraKF([num2str(now()) '_dt=24h_KF']);

kero=RES.kero(end,:);
kacr=RES.kacr(end,:);
kcerc=RES.kcerc(end,:);

save('kero.mat','kero');
save('kacr.mat','kacr');
save('kcerc.mat','kcerc');
