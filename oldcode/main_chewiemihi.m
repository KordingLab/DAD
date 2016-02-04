%%%%% Script to run DAD on Chewie and Mihi's data

% initialize parameters
C = setinputparams();

C.delT=.2;
Data = preparedata_chewiemihi(C.delT);
Data2x = preparedata_chewiemihi(0.08);

%%%%
removedir = [0,2,7];
[Xtest,Ytest,Ttest,Xtrain,~,Ttrain] = removedirdata(Data,removedir);
[Xtest2x,Ytest2x,Ttest2x,Xtrain2x,~,Ttrain2x] = removedirdata(Data,removedir);

C.th1l = 1;
C.th1u = inf;
C.th2l = 1;
C.th2u = inf;

ResultsDAD = DAD2(Ytest,Xtrain2x,C,Xtest,Ttest,Ttrain);

Results = DADExpPCA(Ytest,Xtrain,Xtest,C,Ttest,Ttrain);

