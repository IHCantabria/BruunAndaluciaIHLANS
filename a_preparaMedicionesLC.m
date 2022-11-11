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
        ii = isnan(LC.(col));
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


%% --- GUARDA DATOS ---
save([pathRes 'EnsamblesProfiles.mat'],'ENS')

%% --------------------------END--------------------------