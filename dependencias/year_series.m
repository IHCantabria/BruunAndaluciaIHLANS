function [Hsv,Hsi,Tpv,Tpi,thetav,thetai,timeV,timeI,NNv,NNi]=year_series(time,Hs,Tp,theta,name,tstr,NN)



% [~,MO,DD]=datevec(time);


DD=time-datenum(year(time),1,1) + 1;

Iv=datenum(0,06,21,0,0,0);
Fv=datenum(0,09,23,0,0,0);

Ii=datenum(0,12,21,0,0,0);
Fi=datenum(0,03,20,0,0,0);


Hsv=Hs(DD<Fv & DD>Iv);
Hsi=Hs(DD>Ii | DD<Fi);

Tpv=Tp(DD<Fv & DD>Iv);
Tpi=Tp(DD>Ii | DD<Fi);

thetav=theta(DD<Fv & DD>Iv);
thetai=theta(DD>Ii | DD<Fi);

NNv=NN(DD<Fv & DD>Iv);
NNi=NN(DD>Ii | DD<Fi);


timeV=DD(DD<Fv & DD>Iv);

timeI=DD(DD>Ii | DD<Fi);

fig=figure;
title('Variabilidad anual de los datos')
fig.Position=[200 50 800 600];
fig.Name=name;
fig.Color=[1 1 1];
subplot(3,1,1);
plot(DD, Hs,'k.','markersize',.5);

ax=gca;
ax.FontWeight='bold';
ax.YLabel.String='Hs [m]';
% ax.XLabel.String='Año';
ax.YLim=[0 8];
ax.YTick=0:1:8;
ax.XLim=[0 366];
ax.XTick=15:30:366;
ax.XTickLabel={'JAN' 'FEB' 'MAR' 'ABR' 'MAY' 'JUN' 'JUL' 'AGO' 'SEP' 'OCT' 'NOV' 'DIC'};
grid;grid minor;

subplot(3,1,2);
plot(DD, Tp,'r.','markersize',.5);
datetick();
ax=gca;
ax.FontWeight='bold';
ax.YLabel.String=tstr;
% ax.XLabel.String='Año';
ax.YLim=[0 20];
ax.YTick=0:5:20;
ax.XLim=[0 366];
ax.XTick=15:30:366;
ax.XTickLabel={'JAN' 'FEB' 'MAR' 'ABR' 'MAY' 'JUN' 'JUL' 'AGO' 'SEP' 'OCT' 'NOV' 'DIC'};
grid;grid minor;

idx1=theta<=180;
idx2=theta>180;
theta(idx1)= theta(idx1)+180;
theta(idx2)= theta(idx2)-180;
subplot(3,1,3);
plot(DD, theta,'b.','markersize',.5);
ax=gca;
ax.FontWeight='bold';
ax.YLabel.String='\theta_p';
% ax.XLabel.String='Año';
ax.YLim=[0 360];
ax.XLim=[0 366];
ax.XTick=15:30:366;
ax.XTickLabel={'JAN' 'FEB' 'MAR' 'ABR' 'MAY' 'JUN' 'JUL' 'AGO' 'SEP' 'OCT' 'NOV' 'DIC'};
ax.YTick=[0 90 180 270 360];
txt={'S' 'W' 'N' 'E' 'S'};
ax.YTickLabel=txt;
grid;grid minor;







