
%%%%% Script to run DAD on Mihi's neural data + Chewie's motor data

% initialize parameters
C = setinputparams();

% change parameters in C from their defauly value here
% ex: to change thresholds in pre-processing step =
% [C.th1l,C.th1u,C.th2l,C.th2u];

C.delT=.2;
Data = preparedata_newchewie(C.delT);
Data2x = preparedata_newchewie(C.delT/2);

%%%%
removedir = [0,2,7];
[Xtest,Ytest,Ttest,Ttrain,Xtrain] = removedirdata(Data,removedir);
[Xtest2x,Ytest2x,Ttest2x,Ttrain2x,Xtrain2x] = removedirdata(Data2x,removedir);

C.th1l = 1; C.th1u = Inf;
C.th2l = 1; C.th2u = Inf;
Results = DAD2(Ytest,Xtrain,C,Xtest,Ttest,Ttrain);

% plot original data
figure; colorData2014(Data.Xtest, Data.Ttest)

figure; colorData2014(Results.YrKLMat, Data.Ttest)



