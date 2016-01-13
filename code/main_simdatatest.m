%%%%% Script to run DAD on Chewie and Mihi's data

% initialize parameters
C = setinputparams();

Ts=.16;
Data = preparedata_chewiemihi(Ts);
Data2x = preparedata_chewiemihi(Ts/2);

%%%%
removedir = [0,2,7];
[Xtest,Ytest,Ttest,Xtrain,~,Ttrain] = removedirdata(Data,removedir);
[Xtest2x,Ytest2x,Ttest2x,Xtrain2x,~,Ttrain2x] = removedirdata(Data2x,removedir);

% generate simulated Y (from true X)
N = [50:50:2000];
for j=1:10
for i=1:length(N)
    Ysim = simmotorneurons(Xtest,N(i),Ts);
    ResultsDAD = DADExpPCA(Ysim,Xtrain,Xtest,C,Ttest,Ttrain);
    i,
    R2Val(i,j) = ResultsDAD{i}.R2KL;
end
randbeep
end


