%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Verificar las mediciones

clear *; close all; clc; 

try init; catch me; cd ..; init; end

warning off;
%% ------------------------ CARGANDO LOS DATOS ------------------------

% Nombre del perfil de análisis 
load('Fuengirola.mat');

%% ------------------------ PLOTS ------------------------

for i =1:ntrs
    figure;
    plot(INPUT.PERF(i).date_obs,INPUT.PERF(i).Y_obs_lt,'kx-')
    figure;
    plot(INPUT.PERF(i).date_obs,INPUT.PERF(i).Y_obs_ct,'rx-')
end

ntrs=numel(INPUT.PERF);

for i =1:ntrs
    figure;
    plot(INPUT.PERF(i).date_obs,INPUT.PERF(i).Y_obs_lt,'kx-')
    figure;
    plot(INPUT.PERF(i).date_obs,INPUT.PERF(i).Y_obs_ct,'rx-')
end



%% -------------------------- FIN --------------------------
