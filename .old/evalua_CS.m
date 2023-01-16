
function []=evalua_CS(INPUT,RES,perf)


pos=[10 10 1200 200];
figure('Position',pos); 
tit=['Yst  ' num2str(perf)];
title(tit);

hold on;
plot(RES.t_output,RES.Yct(:,perf),'b-')
plot(INPUT.PERF(perf).date_obs,INPUT.PERF(perf).Y_obs_ct,'rx-',MarkerSize=2)

ax=gca;
ax.FontSize=12;
ax.FontWeight='bold';
datetick;
grid; grid minor;




% figure('Position',pos); 
% tit=['Yeq  ' num2str(perf)];
% title(tit);
% 
% hold on;
% plot(RES.t_output,RES.Yeq(:,perf),'k-')
% % plot(INPUT.PERF(perf).date_obs,INPUT.PERF(perf).Y_obs_ct,'rx')
% 
% ax=gca;
% ax.FontSize=12;
% ax.FontWeight='bold';
% datetick;
% grid; grid minor;
