%%%%% Script to run DAD on Chewie and Mihi's data

% initialize parameters
C = setinputparams();

C.delT=.2;
Data = preparedata_chewiemihi(C.delT);
Data2x = preparedata_chewiemihi(C.delT/2);

%%%%
removedir = [0,2,7];
[Xtest,Ytest,Ttest,Ttrain,Xtrain] = removedirdata(Data,removedir);
   
C.th1l = 1;
C.th1u = inf;
C.th2l = 1;
C.th2u = inf;

Results = DAD2(Ytest,Xtrain2x,C);



