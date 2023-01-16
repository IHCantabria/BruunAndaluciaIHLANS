%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Prepara Perfiles

clear *; close all; clc; 

try init; catch me; cd ..; init; end
%% ------------------------ CARGANDO LOS DATOS ------------------------

LC=readtable('D:\COASTSAT\Tarea_2\M_8\transect_time_series_filtered.csv');
Profiles=readtable('Perfiles_general.csv');

%% ------------------------- SEPARANDO PERFILES -------------------------

perf = 4413:4414; %cambiar

% exclude satelites?

% k=1;
% for i=1:numel(LC.satname)
%     if LC.satname{i}=='L7' %  | LC.satname{i}=='L7'
%         
%     else
%         idx(k)=i;
%         k=k+1;
%     end
%     
% end
% 
% LC=LC(idx,:);
% LC=LC(1:end-7,:);

% k=1;

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
        % do nothing
    end

end

%% -------------------- SEPARANDO FECHAS CON MEDICION --------------------

TimeTOT=sort(TimeTOT,'ascend');
TimeTOT=TimeTOT(diff(TimeTOT) > 15);

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

Yobs=fillmissing(Yobs,'linear');


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

clear ENS;

ENS.Yobs=Yobs;ENS.X=X; ENS.Y=Y;ENS.time=TimeTOT;




%% --- GUARDA DATOS ---
save([pathRes 'EnsamblesProfiles.mat'],'ENS')

%% --------------------------END--------------------------