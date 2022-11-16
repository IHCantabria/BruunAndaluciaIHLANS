global  wrkDir pathLANS %#ok<GVMIS> 

wrkDir=pwd();
addpath(genpath(wrkDir));
pathIn = [wrkDir,'\inputs\'];
pathRes = [wrkDir,'\results\']; 
pathFig = [wrkDir,'\figures\'];
rmpath('.old');rmpath('.git');
pathLANS = 'C:\Users\freitasl\Documents\MATLAB\LANS';
addpath(genpath(pathLANS));
cd(wrkDir);