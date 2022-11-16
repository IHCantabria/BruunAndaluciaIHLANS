%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Evalua resultados

function []=evaluaResultados(INPUT,RES)

figure; 
hold on;
plot(RES.t_output,mean(RES.YCT,2)+mean(RES.YLT,2),'k-')
plot(INPUT.PERF(1).date_obs,INPUT.PERF(1).Y_obs_ct,'rx')
ax=gca;
ax.FontSize=12;
ax.FontWeight='bold';
legend('Transectos');
grid; grid minor;


