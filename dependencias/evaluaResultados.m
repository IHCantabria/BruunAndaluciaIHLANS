%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Evalua resultados

function []=evaluaResultados(INPUT,RES,nameFIG,pathFig)

% tit='Media General';
% close all;
% F1=figure; 
% hold on;
% title(tit);
% plot(RES.t_output,mean(RES.YCT,2)+mean(RES.YLT,2),'k-')
% ax=gca;
% ax.FontSize=12;
% ax.FontWeight='bold';
% legend('Transectos');
% grid; grid minor;
% datetick;
% print([pathFig tit nameFIG],F1,'-dpng')


%% Resultado por transectos
F2=figure; 
tit='TRS-1-10-81';
title(tit);
colores={'k-','kx';...
    'r-','rx';
    'm-','mx';
    'g-','gx';
    'y-','yx';
    'b-','bx';
    'c-','cx';};
k=1;
hold on;
for i=2:13:82
    Y=RES.YCT(:,i)+RES.YLT(:,i);
%     plot(RES.t_output(Y<1000 & Y>300),Y(Y<1000 & Y>300),colores{k,1})
    plot(RES.t_output,Y,colores{k,1})
    plot(INPUT.PERF(i).date_obs,INPUT.PERF(i).Y_obs_ct+INPUT.PERF(i).Y_obs_lt,colores{k,2})
    k=k+1;
end
ax=gca;
ax.FontSize=12;
ax.FontWeight='bold';
datetick;
grid; grid minor;
print([pathFig tit nameFIG],F2,'-dpng')


%% Corto plazo
F3=figure; 
tit='Y_s_t';
title(tit);
k=1;
hold on;
for i=2:13:82
    plot(RES.t_output,RES.YCT(:,i),colores{k,1})
    k=k+1;
end
ax=gca;
ax.FontSize=12;
ax.FontWeight='bold';
datetick;
grid; grid minor;
print([pathFig tit nameFIG],F3,'-dpng')

%% Largo plazo
F4=figure; 
tit='Y_l_t';
title(tit);
k=1;
hold on;
for i=2:13:82
    plot(RES.t_output,RES.YLT(:,i),colores{k,1})
    k=k+1;
end
ax=gca;
ax.FontSize=12;
ax.FontWeight='bold';
datetick;
grid; grid minor;
print([pathFig tit nameFIG],F4,'-dpng')

%% Evolución Kcerc
F5=figure; 
tit='K_c_e_r_c';
title(tit);
k=1;
hold on;
for i=2:13:82
    plot(RES.t_output,RES.kcerc(:,i),colores{k,1})
    k=k+1;
end
ax=gca;
ax.FontSize=12;
ax.FontWeight='bold';
datetick;
grid; grid minor;
print([pathFig tit nameFIG],F5,'-dpng')

%% Evolución Kero
F6=figure; 
tit='K_e_r_o';
title(tit);
k=1;
hold on;
for i=2:13:82
    plot(RES.t_output,RES.kero(:,i),colores{k,1})
    k=k+1;
end
ax=gca;
ax.FontSize=12;
ax.FontWeight='bold';
datetick;
grid; grid minor;
print([pathFig tit nameFIG],F6,'-dpng')

%% Evolución Kacr
F7=figure; 
tit='K_a_c_r';
title(tit);
k=1;
hold on;
for i=2:13:82
    plot(RES.t_output,RES.kacr(:,i),colores{k,1})
    k=k+1;
end
ax=gca;
ax.FontSize=12;
ax.FontWeight='bold';
datetick;
grid; grid minor;
print([pathFig tit nameFIG],F7,'-dpng')

