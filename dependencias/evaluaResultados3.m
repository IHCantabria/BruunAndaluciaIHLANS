function []=evaluaResultados3(INPUT,RES5,RES50,RES95,TRS,tit,Y)

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
%truco malo
    plot(0,0,'b-')
    plot(0,0,'k-')
    plot(0,0,'r-')

t=RES5.t_output;
Y5=movmean(mean(RES5.YLT(:,TRS)+RES5.YCT(:,TRS),2)-mean(Y(TRS)),2);
p=plot(t,Y5,colores{4,1},LineWidth=.1);
p.Color = [p.Color 0.2];
Y50=movmean(mean(RES50.YLT(:,TRS)+RES50.YCT(:,TRS),2)-mean(Y(TRS)),2);
p=plot(t,Y50,colores{1,1},LineWidth=.1);
p.Color = [p.Color 0.2];
Y95=movmean(mean(RES95.YLT(:,TRS)+RES95.YCT(:,TRS),2)-mean(Y(TRS)),2);
p=plot(t,Y95,colores{2,1},LineWidth=.1);
p.Color = [p.Color 0.2];
patch([flip(t(3:end),1); t(3:end); t(end)],...
    [flip(Y50(3:end),1); Y95(3:end); Y50(end)],...
    'r','FaceAlpha',.2,'EdgeColor','none')
patch([flip(t(3:end),1); t(3:end); t(end)],...
    [flip(Y50(3:end),1); Y5(3:end); Y50(end)],...
    'b','FaceAlpha',.2,'EdgeColor','none')

%% Bruun Original
f2050=datenum('2050-01-01 00:00:00');
[~,idx]=min(abs(t-f2050));
% plot([0 f2050 999999],repmat(-mean([INPUT.RB45_2050(TRS).Q5]),[3,1]),'m--v',MarkerSize=7,MarkerFaceColor='m')
% plot([0 f2050 999999],repmat(-mean([INPUT.RB45_2050(TRS).Q95]),[3,1]),'m--^',MarkerSize=7,MarkerFaceColor='m')
plot([0 f2050],repmat(mean(sum(RES50.RRSLR(1:idx,TRS),1,'omitnan')),[2,1]),'m--s',MarkerSize=7,MarkerFaceColor='m')
% plot([f2050 f2050],-[mean([INPUT.RB45_2050(TRS).Q95]) mean([INPUT.RB45_2050(TRS).Q5])],'m-',LineWidth=1)

fLine=datenum('2023-01-01 00:00:00');
% text(fLine,-mean([INPUT.RB45_2050(TRS).Q95]),'Bruun','FontSize',8,...
%     'FontWeight','bold','Rotation',90)
% text(fLine,-mean([INPUT.RB45_2050(TRS).Q95]),'Bruun: Q95','FontSize',8,...
%     'FontWeight','bold')
text(fLine,mean(sum(RES50.RRSLR(1:idx,TRS)))+2.5,'Bruun: Q50','FontSize',8,...
    'FontWeight','bold')
% text(fLine,-mean([INPUT.RB45_2050(TRS).Q5]),'Bruun: Q05','FontSize',8,...
%     'FontWeight','bold')

f2100=datenum('2100-01-01 00:00:00');
% plot([0 f2100 999999],repmat(-mean([INPUT.RB45_2100(TRS).Q5]),[3,1]),'m--v',MarkerSize=7,MarkerFaceColor='m')
% plot([0 f2100 999999],repmat(-mean([INPUT.RB45_2100(TRS).Q95]),[3,1]),'m--^',MarkerSize=7,MarkerFaceColor='m')
plot([0 f2100],repmat(mean(sum(RES50.RRSLR(:,TRS),1,'omitnan')),[2,1]),'g--s',MarkerSize=7,MarkerFaceColor='g')
% plot([f2100 f2100],-[mean([INPUT.RB45_2100(TRS).Q95]) mean([INPUT.RB45_2100(TRS).Q5])],'m-',LineWidth=1)

% fLine=datenum('2023-01-01 00:00:00');
% text(fLine,-mean([INPUT.RB45_2100(TRS).Q95]),'Bruun','FontSize',8,...
%     'FontWeight','bold','Rotation',90)
% text(fLine,-mean([INPUT.RB45_2100(TRS).Q95]),'Bruun: Q95','FontSize',8,...
%     'FontWeight','bold')
text(fLine,mean(sum(RES50.RRSLR(:,TRS),1,'omitnan'))+2.5,'Bruun: Q50','FontSize',8,...
    'FontWeight','bold')
% text(fLine,-mean([INPUT.RB45_2100(TRS).Q5]),'Bruun: Q05','FontSize',8,...
%     'FontWeight','bold')

%% Adaptacion
f2050=datenum('2050-01-01 00:00:00');
% plot([0 f2050 999999],repmat(-mean([INPUT.RTT45_2050(TRS).Q5]),[3,1]),'m--v',MarkerSize=7,MarkerFaceColor='m')
% plot([0 f2050 999999],repmat(-mean([INPUT.RTT45_2050(TRS).Q95]),[3,1]),'m--^',MarkerSize=7,MarkerFaceColor='m')
plot([0 f2050],repmat(-mean([INPUT.RTT45_2050(TRS).Q50]),[2,1]),'c--s',MarkerSize=7,MarkerFaceColor='c')
% plot([f2050 f2050],-[mean([INPUT.RTT45_2050(TRS).Q95]) mean([INPUT.RTT45_2050(TRS).Q5])],'m-',LineWidth=1)

% fLine=datenum('2023-01-01 00:00:00');
% text(fLine,-mean([INPUT.RTT45_2050(TRS).Q95]),'Bruun','FontSize',8,...
%     'FontWeight','bold','Rotation',90)
% text(fLine,-mean([INPUT.RTT45_2050(TRS).Q95]),'Bruun: Q95','FontSize',8,...
%     'FontWeight','bold')
text(fLine,-mean([INPUT.RTT45_2050(TRS).Q50])+2.5,'Adaptación: Q50','FontSize',8,...
    'FontWeight','bold')
% text(fLine,-mean([INPUT.RTT45_2050(TRS).Q5]),'Bruun: Q05','FontSize',8,...
%     'FontWeight','bold')

f2100=datenum('2100-01-01 00:00:00');
% plot([0 f2100 999999],repmat(-mean([INPUT.RTT45_2100(TRS).Q5]),[3,1]),'m--v',MarkerSize=7,MarkerFaceColor='m')
% plot([0 f2100 999999],repmat(-mean([INPUT.RTT45_2100(TRS).Q95]),[3,1]),'m--^',MarkerSize=7,MarkerFaceColor='m')
plot([0 f2100],repmat(-mean([INPUT.RTT45_2100(TRS).Q50]),[2,1]),'k--s',MarkerSize=7,MarkerFaceColor='k')
% plot([f2100 f2100],-[mean([INPUT.RTT45_2100(TRS).Q95]) mean([INPUT.RTT45_2100(TRS).Q5])],'m-',LineWidth=1)

% fLine=datenum('2023-01-01 00:00:00');
% text(fLine,-mean([INPUT.RTT45_2100(TRS).Q95]),'Bruun','FontSize',8,...
%     'FontWeight','bold','Rotation',90)
% text(fLine,-mean([INPUT.RTT45_2100(TRS).Q95]),'Bruun: Q95','FontSize',8,...
%     'FontWeight','bold')
text(fLine,-mean([INPUT.RTT45_2100(TRS).Q50])+2.5,'Adaptación: Q50','FontSize',8,...
    'FontWeight','bold')
% text(fLine,-mean([INPUT.RTT45_2100(TRS).Q5]),'Bruun: Q05','FontSize',8,...
%     'FontWeight','bold')

% [~,idx]=min(abs(INPUT.DYN(1).t-datenum('2050-01-01 00:00:00')));
% RSLR=mean(sum(RES.RRSLR(1:idx,:),1,'omitnan'));
% plot([0, 999999],[RSLR RSLR], 'm--',LineWidth=2)
% RSLR=mean(sum(RES.RRSLR,1,'omitnan'));
% plot([0, 999999],[RSLR RSLR], 'r--',LineWidth=2)
ax=gca;
ax.FontSize=8;
ax.FontWeight='bold';
ax.YLabel.String='Retroceso [m]';
ax.XTick=[datenum('2020-01-01 00:00:00')
          datenum('2030-01-01 00:00:00')
          datenum('2040-01-01 00:00:00')
          datenum('2050-01-01 00:00:00')
          datenum('2060-01-01 00:00:00')
          datenum('2070-01-01 00:00:00')
          datenum('2080-01-01 00:00:00')
          datenum('2090-01-01 00:00:00')
          datenum('2100-01-01 00:00:00')];
ax.XLim=[datenum('2022-01-01 00:00:00') datenum('2100-01-01 00:00:00')]';
datetick('keepticks','keeplimits');
grid; grid minor;
% legend('IH-LANS', 'R_B_r_u_u_n 2050', 'R_B_r_u_u_n 2100',Location='northoutside',NumColumns=3)
legend('Q05', 'Q50', 'Q95',Location='northoutside',NumColumns=3)
% title(tit);
print(['D:\Resultados_BruunAndalucia\' tit '.png'],'-dpng')