%%%%% Script to run DAD on Chewie and Mihi's data

% initialize parameters
C = setinputparams();

C.delT=.2;
Data = preparedata_chewiemihi(0.1);
Data2x = preparedata_chewiemihi(0.06);

%%%%
removedir = [0,2,7];
[Xtest,Ytest,Ttest,Xtrain,~,Ttrain] = removedirdata(Data,removedir);
[Xtest2x,Ytest2x,Ttest2x,Xtrain2x,~,Ttrain2x] = removedirdata(Data2x,removedir);

% generate simulated Y (from true X)
N = [50:50:2000];
for j=1:10
for i=1:length(N)
    Ytest_sim = simmotorneurons(Xtest,N(i));
    ResultsDAD{i,j} = DADExpPCA(Ytest_sim{i},Xtrain,Xtest2x,C,Ttest2x,Ttrain2x);
    i,
    R2Val(i,j) = ResultsDAD{i}.R2KL;
end
randbeep
end


