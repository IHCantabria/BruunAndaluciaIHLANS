%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prepara Perfiles

clear *; close all; clc; 

try init; catch me; cd ..; init; end
%% ------------------------ CARGANDO LOS DATOS ------------------------

LC=readtable('D:\COASTSAT\Tarea_2\M_23\transect_time_series_filtered.csv');
Profiles=readtable('Perfiles_general.csv');

%% ------------------------- SEPARANDO PERFILES -------------------------

perf = 2334:2415; %cambiar

k=1;
Fecha=zeros(size(LC,1),1);

for i=1:size(LC,1)
    Fecha(i)=datenum(LC.dates{i},'yyyy-mm-dd HH:MM:SS');
end

TimeTOT=[];
k=1;
for i=1:numel(perf)
    try
        col = ['Transect' num2str(perf(i))];
        ii = ~isnan(LC.(col));
        ENS(k).time = Fecha(ii);
        ENS(k).Yobs = LC.(col)(ii);
        ENS(k).Sat = LC.satname(ii);
        ENS(k).trs = perf(i);
        ENS(k).xon = Profiles.xon(perf(i));
        ENS(k).yon = Profiles.yon(perf(i));
        ENS(k).xof = Profiles.xof(perf(i));
        ENS(k).yof = Profiles.yof(perf(i));
        ENS(k).phi = -pi/2.-atan((ENS(k).xof-ENS(k).xon)/(ENS(k).yof-ENS(k).yon));
        TimeTOT=[TimeTOT;ENS(i).time];
        [ENS(k).absX,ENS(k).absY]=abs_pos(ENS(k).xon,ENS(k).yon,ENS(k).phi,ENS(k).Yobs);
        k=k+1;

    catch
%         ENS(i).time = [];
%         ENS(i).Yobs = [];
%         ENS(i).Sat = [];
%         ENS(i).trs = perf(i);
%         ENS(i).xon = Profiles.xon(perf(i));
%         ENS(i).yon = Profiles.yon(perf(i));
%         ENS(i).xof = Profiles.xof(perf(i));
%         ENS(i).yof = Profiles.yof(perf(i));
%         ENS(i).phi = -pi/2.-atan((ENS(i).xof-ENS(i).xon)/(ENS(i).yof-ENS(i).yon));
    end
%     TimeTOT=[TimeTOT;ENS(i).time];
end

% porque las primeras transectas de la playa no tienen medicion
% for i=numel(perf)-1:-1:1
% %     if isempty(ENS(i).Sat)
% %         ENS(i).time = ENS(i+1).time;
% %         ENS(i).Yobs = ENS(i+1).Yobs;
% %         ENS(i).Sat = ENS(i+1).Sat;   
% %     end
%     
% end

%% -------------------- SEPARANDO FECHAS CON MEDICION --------------------

TimeTOT=sort(TimeTOT,'ascend');
TimeTOT=TimeTOT(diff(TimeTOT) > 1);

for i=1:numel(TimeTOT)
    for j=1:numel(ENS)
        ii=abs(TimeTOT(i)-ENS(j).time)<1;
        try
            Yobs(i,j)=ENS(j).Yobs(ii);
        catch
            Yobs(i,j)=NaN;
        end
    end
end

Yobs=fillmissing(Yobs,'makima');

for i=1:numel(ENS)

    [X(:,i),Y(:,i)]=abs_pos(ENS(i).xon,ENS(i).yon,ENS(i).phi,Yobs(:,i));


end


k=1;
for i=1:numel(TimeTOT)
    if sum(~isnan(Yobs(i,:)))==size(Yobs,2)
        Yobs2(k,:)=Yobs(i,:);
        TimeTOT2(k)=TimeTOT(i);
        k=k+1;
    end
end


% Yobs=Yobs(10:end);
clear ENS;

ENS.Yobs=Yobs;ENS.X=X; ENS.Y=Y;ENS.time=TimeTOT;



%% ------------------------- CALCULAMOS LA MEDIA -------------------------

% tmin=min(min(vertcat(ENS.time)));
% tmax=max(max(vertcat(ENS.time)));
% 
% time=[tmin:1/24:tmax]';
% OBS=nan(numel(time),1);
% 
% for i=1:numel(time)
%     clear ii aux;
%     for j=1:numel(ENS)
%         ii = abs(time(i)-ENS(j).time)<=1;
%         if sum(ii)>0
%             aux(j) = mean(ENS(j).Yobs(ii));
%         else
%             aux(j)=nan;
%         end
%     end
%     OBS(i)=mean(aux(~isnan(aux)));
% end
% 
% OBS=OBS(~isnan(OBS));time=time(~isnan(OBS));
% 
% %% ------------------------- DESACOPLAMOS LT y ST -------------------------
% 
% timeLT=1*365; %[dias]
% Y_obs_lt=zeros(size(OBS));%movmean(OBS,timeLT);
% Y_obs_st=OBS; %OBS - Y_obs_lt;
% 
% clear ENS;
% 
% ENS.time=time; ENS.Y_obs_lt=Y_obs_lt;ENS.Y_obs_st=Y_obs_st;

%% --- GUARDA DATOS ---
save([pathRes 'EnsamblesProfiles.mat'],'ENS')

%% --------------------------END--------------------------