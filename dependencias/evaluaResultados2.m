function []=evaluaResultados2(INPUT,RES,TRS,tit,Y)

% close all;


colores={'k-','kx';...
    'r-','rx';
    'm-','mo';
    'b-','bx';
    'c-','cx';
    'g-','g*';
    'y-','yx';};

%% Transectos
pos=[10 600 1100 300];

figure('Position',pos); 
% tit=['Calibración Playa de La Carihuela'];
hold on
aux=mean([INPUT.PERF(TRS).Y_obs_lt]+[INPUT.PERF(TRS).Y_obs_ct],2)';
plot(INPUT.PERF(1).date_obs,movmean(aux-mean(Y(TRS)),5),colores{2,2})
plot(RES.t_output-90,movmean(mean(RES.YLT(:,TRS)+RES.YCT(:,TRS),2)-mean(Y(TRS)),5),colores{1,1})
ax=gca;
ax.FontSize=10;
ax.FontWeight='bold';
ax.YLabel.String='Retroceso [m]';
ax.XLim=[datenum('1995-01-01 00:00:00') datenum('2020-01-01 00:00:00')]';
ax.XTick=[datenum('1995-01-01 00:00:00')
          datenum('2000-01-01 00:00:00')
          datenum('2005-01-01 00:00:00')
          datenum('2010-01-01 00:00:00')
          datenum('2015-01-01 00:00:00')
          datenum('2020-01-01 00:00:00')]';
datetick('keepticks','keeplimits');
grid; grid minor;
legend('Mediciones', 'IH-LANS',Location='northoutside',NumColumns=2)
% title(tit);
print(['D:\Resultados_BruunAndalucia\' tit '.png'],'-dpng')


