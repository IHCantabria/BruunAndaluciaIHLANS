%*****************************************************
%***************PRÁCTICA 1 FUNDAMENTOS****************
%**********************DE OBRAS***********************
%**********************MARITMAS***********************
%*****************************************************

%% Autor: Lucas de Freitas Pereira

clear *;
close all;

% addpath('./inputs','./functions','./outputs');
clc;
tic;

%% Cargar los datos

load('DOW.mat');

%% Generación de las series temporales punto DOW

% series temporales
Hs12=prctile(hs,100*.9986);
Hs50=prctile(hs,100*.50);
% Oleaje de temporal
buscHS12=find(hs>=(Hs12-0.1) & hs<=(Hs12+0.1));
[f,xi]=ksdensity(tp(buscHS12,i));
fmax=max(f);
f1=find(f(:)==fmax);

buscHS50=find(hs>=(Hs50-0.1) & hs <= (Hs50+0.1));
[f2,xi2]=ksdensity(tp(buscHS50,i));
fmax2=max(f2);
f2=find(f2(:)==fmax2);

if length(f1)==1 %NOTA: normalmente se encuentra un sólo valor máximo
    Tp_12=xi(f1);
    Tp_50=xi2(f2);
else
    Tp_12=max(xi(f1)); %NOTA: en caso encuentre varios máximos, que tome el mayor xi
    Tp_50=max(xi2(f2));

end
DOC=depthOfClosure(Hs12,Tp_12);
[Hsv,Hsi,Tpv,Tpi,thetav,thetai,timeV,timeI,NNv,NNi]=year_series(time,TOT.Hs(:,i),TOT.Tp(:,i),TOT.DD(:,i),['Punto: ',nombre{i}],'T_p [s]',TOT.NIVEL);
RESv=struct('Hs',Hsv,'Tp',Tpv,'theta',thetav,'time',timeV);
RESi=struct('Hs',Hsi,'Tp',Tpi,'theta',thetai,'time',timeI);
disp(nombre{i});
disp('Verano');
FME(Hsv,Tpv,thetav,NNv,1,h(i));
disp('Invierno');
FME(Hsi,Tpi,thetai,NNi,1,h(i));
close all
pt=['VP',num2str(i),'.mat'];
save(pt,'RESv','-mat');
pt=['IP',num2str(i),'.mat'];
save(pt,'RESi','-mat');

end

i=1;

series_temporales(time,TOT.Hs(:,i),TOT.Tp(:,i),TOT.DD(:,i),['Punto: ',nombre{i}],'T_p [s]');
[Hsv,Hsi,Tpv,Tpi,thetav,thetai,timeV,timeI]=year_series(time,TOT.Hs(:,i),TOT.Tp(:,i),TOT.DD(:,i),['Punto: ',nombre{i}],'T_p [s]');

%% Datos batimétricos obtenidos del DWG y puertos del estado

RES=struct('hs',TOT.Hs(:,1),'tp',TOT.Tp(:,1),'Dir',TOT.DD(:,1),'time',datenum([TOT.fecha,zeros(size(TOT.fecha,1),1),zeros(size(TOT.fecha,1),1)]));


save('P1.mat','RES','-mat');


% st_niveles(MM, MA, h_d, h_DOW, time);

%% Histogramas

% idx=theta_DOW>180;
% theta_hist=theta_DOW;
% theta_hist(idx)=theta_hist(idx)-360;
% 
% idx=theta_d>180;
% thetad_hist=theta_d;
% thetad_hist(idx)=thetad_hist(idx)-360;

% histogramas(Hs_DOW,Tp,theta_hist,'lognormal',150);
% histogramas(TOT.Hs(:,i),TOT.Tp(:,i),TOT.DD(:,i),'lognormal',500,'P1');

%% Grafios de dispersion

graphs_disper(TOT.Hs(:,i),TOT.Tp(:,i),TOT.DD(:,i));

%% Analisis extremal

% extremales(DOW.hs,DOW.tp, DOW.time,'gev',20,.05,'anual',1-1/24/365);

%% casos representativos

% close all
% 
% 
% d_dir=11.25; % deg
% vecLim=-d_dir:2*d_dir:360-d_dir;
% % vecLim=
% NameDir={'N','NNE','NE','ENE','E','ESE','SE','SSE','S','SSW','SW',...
%     'WSW','W','WNW','NW','NNW'};
% 
% ii=abs(DOW.wave_dir)<=66 | abs(DOW.wave_dir)>=322;
% ddir=DOW.wave_dir(ii);
% k=numel(ddir);
% Hs=DOW.hs(ii);
% Tp=DOW.tp(ii);
% Dir=DOW.wave_dir(ii);
% time=DOW.time(ii);
% 
% for i=1:numel(vecLim)-1
%     disp('*********************************************************');
%     disp(['Para la dirección: ',NameDir{i}]);
%     
%     if i==1
%         idx=abs(Dir)>=360+vecLim(i) | abs(Dir)<vecLim(i+1);
%     else
%         idx=abs(Dir)>=vecLim(i) & abs(Dir)<vecLim(i+1);
%     end
%     if sum(idx)~=0
%         histogramas(Hs(idx),Tp(idx),Dir(idx),'lognormal',1000,NameDir(i));
%         K=numel(Hs(idx));
%         disp(['Porcentaje del total de datos:', num2str(100*K/k), ' %']);
%     end
%     
% end
% 
% 
% %%
% 
% DOW_DIR=struct('Info', 'Datos DOW IH Cantabria', 'time',...
%     time,'Hs',Hs,'Tp',Tp,'dir',Dir,'depth',42);
% save('DOW_DIR.mat','DOW_DIR','-mat');


%%

% 
% ti=max([min(GOS.time), min(GOT.time)]); ii1=find(GOS.time==ti);ii2=find(GOT.time==ti);
% tf=min([max(GOS.time), max(GOT.time)]); ff1=find(GOS.time==tf);ff2=find(GOT.time==tf);
% time=ti:1/24:tf;
st_niveles(GOS.zeta(ii1:ff1), GOT.tide(ii2:ff2), time)


%%
toc;


%%
load('DATOS.mat');
i=6;
idx=TOT.Hs(:,1)~=0 & DOW.hs>.05;

H0=DOW.hs(idx);
Hp=TOT.Hs(idx,i);
Tp0=DOW.tp(idx);
Tpp=TOT.Tp(idx,i);
dir0=DOW.wave_dir(idx);
dirp=TOT.DD(idx,i);
time=DOW.time(idx);


% {H0,Hp,Tp0,Tpp,dir0,dirp,time}
Kf=Hp./H0;
% ixd=find(time>=ti && Tp0);

TV=0:1:22;
m=numel(TV);
thetaV=0:10:360;
n=numel(thetaV);
[H_TV,H_thetaV]=meshgrid(TV,thetaV);
k1=1;
k2=1;
H_dir_err=zeros(n-1,m-1);
H_dirp=zeros(n-1,m-1);
Ndata=zeros(n-1,m-1);
H_Kf=zeros(n-1,m-1);
H_Kf_err=zeros(n-1,m-1);
H_T=zeros(n-1,m-1);
H_dir0=zeros(n-1,m-1);

for i=1:n-1
    for j=1:m-1
        idx=find(Tp0>=H_TV(i,j) & Tp0<H_TV(i+1,j+1)...
            & dir0>=H_thetaV(i,j) &...
            dir0<=H_thetaV(i+1,j+1));
        Ndata(i,j)=numel(idx);
        if isempty(idx)
            H_Kf(i,j)=NaN;
        else
            H_Kf(i,j)=mean(Kf(idx),'omitnan');
        end
            
        H_Kf_err(i,j)=(mean((Kf(idx)-H_Kf(i,j)).^2,'omitnan')).^.5;
        H_T(i,j)=H_TV(i+1,j+1);
        H_dir0(i,j)=H_thetaV(i+1,j+1);
        if isempty(idx)
            H_dirp(i,j)=NaN;
        else
            H_dirp(i,j)=meanangle(dirp(idx),1,1e-12,'omitnan');
            if H_dirp(i,j)<0
                H_dirp(i,j)=360+H_dirp(i,j);
            end
        end
        s=0;
        if isempty(idx)
            H_dir_err(i,j)=NaN;
        else
            for k=1:numel(idx)
                aux=abs(dirp(idx(k))-H_dirp(i,j));
                if aux>180 && ~isnan(aux) 
                    H_dir_err(i,j)=H_dir_err(i,j)+(aux-360).^2;
                    s=s+1;
                elseif ~isnan(aux) && aux<180
                    H_dir_err(i,j)=H_dir_err(i,j)+(aux).^2;
                    s=s+1;
                end
            end
        end
        H_dir_err(i,j)=(H_dir_err(i,j)./s).^.5;  
    end
end

% idx=find(H_T<5);
% H_Kf(idx)=NaN;
% H_Kf_err(idx)=NaN;
% H_dirp(idx)=NaN;
% H_dir_err(idx)=NaN;
% 


% idx=isnan(H_Kf);
% H_Kf(idx)=0;

fig=figure;
fig.Name='Kf - Bruto';
pcolor(H_T,H_dir0,H_Kf);
caxis([0 2])
colormap(jet)
fig.Color=[1 1 1];
xticks=0:2:22;
yticks={'N', 'NNE','NE','ENE','E','ESE','SE','SSE','S','SSW','SW','WSW','W','WNW','NW','NNW','N'};

ax=gca;

ax.Color=[0 0 0];
ax.XLabel.String='T_p [s]';
ax.XLabel.FontSize=12;
ax.XLabel.Color=[0 0 0];
ax.XLabel.FontWeight='bold';
ax.XTick=xticks;
ax.FontSize=12;
ax.FontWeight='bold';

ax.YLabel.String='\theta_0 [\circ]';
ax.YLabel.FontSize=12;
ax.YLabel.Color=[0 0 0];
ax.YLabel.FontWeight='bold';
ax.YTick=0:22.5:360;
ax.YTickLabel=yticks;

cb=colorbar;
cb.Limits=[0 2];
cb.FontSize=12;
cb.Label.String='K_f [-]';
cb.Label.FontWeight='bold';
cb.Label.Color=[0 0 0];
% idx=find(H_Kf>1);
% H_Kff=H_Kf;
% H_Kff(idx)=0;


% idx=find(H_dirp>180);
% H_dirp(idx)=H_dirp(idx)-360;
cont3=figure;
cont3.Name='dirp';
pcolor(H_T,H_dir0,H_dirp);
colormap(hsv);
bonitin(cont3,'\theta_p [\circ]');
axis([0 22 10 360 ])
caxis([0 360])
fig.Color=[1 1 1];
xticks=0:2:22;
yticks={'N', 'NNE','NE','ENE','E','ESE','SE','SSE','S','SSW','SW','WSW','W','WNW','NW','NNW','N'};

ax=gca;

ax.Color=[0 0 0];
ax.XLabel.String='T_p [s]';
ax.XLabel.FontSize=12;
ax.XLabel.Color=[0 0 0];
ax.XLabel.FontWeight='bold';
ax.XTick=xticks;
ax.FontSize=12;
ax.FontWeight='bold';

ax.YLabel.String='\theta_0 [\circ]';
ax.YLabel.FontSize=12;
ax.YLabel.Color=[0 0 0];
ax.YLabel.FontWeight='bold';
ax.YTick=0:22.5:360;
ax.YTickLabel=yticks;

cb=colorbar;
cb.Limits=[0 360];
cb.FontSize=12;
cb.Label.String='\theta_p [\circ]';
cb.Label.FontWeight='bold';
cb.Label.Color=[0 0 0];
cb.Ticks=0:22.5:360;
cb.TickLabels=yticks;

toc;


%%
i=1;
dt=60*24;
series_temporales(time(265825:265825+dt),TOT.Hs(265825:265825+dt,i),TOT.Tp(265825:265825+dt,i),TOT.DD(265825:265825+dt,i),['Punto: ',nombre{i}],'T_p [s]');

series_temporales(time(265825:265825+dt),DOW.hs(265825:265825+dt,i),DOW.tp(265825:265825+dt,i),DOW.wave_dir(265825:265825+dt,i),'Punto DOW', 'T_p [s]');
