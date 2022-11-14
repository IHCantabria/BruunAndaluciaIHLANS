%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prepara Perfiles

clear *; close all; clc; 

try init; catch me; cd ..; init; end
%% ------------------------ CARGANDO LOS DATOS ------------------------

LC=readtable('D:\COASTSAT\Tarea_2\M_22\transect_time_series_filtered.csv');
Profiles=readtable('Perfiles_general.csv');

%% ------------------------- SEPARANDO PERFILES -------------------------

perf = 2488:2509; %cambiar

k=1;
Fecha=zeros(size(LC,1),1);

for i=1:size(LC,1)
    Fecha(i)=datenum(LC.dates{i},'yyyy-mm-dd HH:MM:SS');
end

for i=1:numel(perf)
    try
        col = ['Transect' num2str(perf(i))];
        ii = ~isnan(LC.(col));
        ENS(k).time = Fecha(ii);
        ENS(k).Yobs = LC.(col)(ii);
        ENS(k).Sat = LC.satname(ii);
        ENS(k).trs = perf(i);
        k=k+1;
       
        ENS(k).xon = Profiles(perf(i)).xon;
        ENS(k).yon = Profiles(perf(i)).yon;
        ENS(k).xof = Profiles(perf(i)).xof;
        ENS(k).yof = Profiles(perf(i)).yof;
    catch
    end
end

%% ------------------------- CALCULAMOS LA MEDIA -------------------------

tmin=min(min(vertcat(ENS.time)));
tmax=max(max(vertcat(ENS.time)));

time=[tmin:1:tmax]';
OBS=nan(numel(time),1);

for i=1:numel(time)
    clear ii aux;
    for j=1:numel(ENS)
        ii = abs(ENS(j).time-time(i))<=1;
        if sum(ii)>0
            aux(j) = mean(ENS(j).Yobs(ii));
        else
            aux(j)=nan;
        end
    end
    OBS(i)=mean(aux(~isnan(aux)));
end

OBS=OBS(~isnan(OBS));time=time(~isnan(OBS));

%% ------------------------- DESACOPLAMOS LT y ST -------------------------

timeLT=5*365; %[dias]
Y_obs_lt=movmean(OBS,timeLT);
Y_obs_st=OBS - Y_obs_lt;

clear ENS;

ENS.time=time; ENS.Y_obs_lt=Y_obs_lt;ENS.Y_obs_st=Y_obs_st;

%% --- GUARDA DATOS ---
save([pathRes 'EnsamblesProfiles.mat'],'ENS')

%% --------------------------END--------------------------