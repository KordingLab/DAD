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

% generate simulated Y (from true X)
N = [100:100:1000];
for i=2:length(N)
    Ytest_sim{i} = simmotorneurons(Xtest2x,N(i));
    ResultsDAD{i} = DADExpPCA(Ytest_sim{i},Xtrain,Xtest,C,Ttest,Ttrain);
    i,
    R2Val(i) = ResultsDAD{i}.R2KL;
end



