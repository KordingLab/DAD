% script 3D alignment (run DAD on real datasets)

%% (1) within subjects (iteration over different partitions of train/test sets)

% set parameters
% removedir = [0, 1, 2]; 

randseed = randi(100,1);
rng(randseed)

whichdirs = input('Which pattern ? Enter 1 if (012) and 2 if (027): ');
if whichdirs==1
    removedir = [0, 1, 2];
    Ntot = 1027;
else
    removedir = [0, 2, 7];
    Ntot = 1069;
end

A = 180; %every 2 deg
Ts=.20; 

numsol = 5;
numT = 10;
numIter = input('Number of iterations? ');
M1{1} = 'FA'; 

%addname = input('Enter string to append to end of file name: ');

%%
percent_samp = .20;
percent_test = 1;
numInit = 20;

%% prepare data

Data0 = prepare_superviseddata(Ts,'chewie1','mihi',[]);
Data = prepare_superviseddata(Ts,'mihi','mihi',[],0);
[~,~,~,XtrC,~,~,~,~] = removedirdata(Data0,removedir);
[Xtest,Ytest,Ttest,Xtrain,Ytrain,Ttrain,~,Ntrain] = removedirdata(Data,removedir);
clear Data Data0

%%
% initialize variables





