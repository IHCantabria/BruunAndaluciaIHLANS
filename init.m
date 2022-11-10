global  wrkDir %#ok<GVMIS> 

wrkDir=pwd();
addpath(genpath(wrkDir));
pathIn = [wrkDir,'\inputs\'];
pathRes = [wrkDir,'\results\']; 
pathFig = [wrkDir,'\figures\'];
rmpath('old');rmpath('.git');
