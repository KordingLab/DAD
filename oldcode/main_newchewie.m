
%%%%% Script to run DAD on Mihi's neural data + Chewie's motor data

% change parameters in C from their defauly value here
% ex: to change thresholds in pre-processing step =
% [C.th1l,C.th1u,C.th2l,C.th2u];

% initialize parameters
C = setinputparams();

C.delT=.2; % [C.th1l,C.th1u,C.th2l,C.th2u];
Data = prepare_superviseddata(C.delT,'chewie3','chewie3');

% remove directions from dataset to produce asymmetric dist
removedir = [0,2,7];
[Xtest,Ytest,Ttest,Xtrain,Ytrain,Ttrain] = removedirdata(Data,removedir);

if size(Ytrain,2)~=size(Ytest,2)
    display('The size of the test and training dataset are unequal!')
end

%%%%%%%%%%%%%%
%%%% (1) run supervised algorithm
lamnum=2000;
fldnum=10;
[W, Xc, R2Max]= crossVaL(normal(Ytrain), normal(Xtrain), normal(Ytest),lamnum, fldnum);
Xrec0 = [Ytest, ones(size(Ytest,1),1)]*W;
R2Sup = evalR2(Xrec0,Xtest);

figure; subplot(1,2,1); colorData2014(normal([Ytrain,ones(size(Ytrain,1),1)]*W),Ttrain);
        subplot(1,2,2);colorData2014(normal([Ytest,ones(size(Ytest,1),1)]*W),Ttest);
        
%%%%%%%%%%%%%%
%%% (2) (Supervised + DAD) now run DAD (local search) from output W 
[What,Ynew,FVAL,R2VAL,idremove] = fminunc_DAD(Ytest,Xtrain,W,2,Xtest);

R2Diff = R2VAL-R2Sup;

figure; subplot(1,2,1); colorData2014([Ytrain,ones(size(Ytrain,1),1)]*W,Ttrain);
        subplot(1,2,2);colorData2014([Ytest,ones(size(Ytest,1),1)]*W,Ttest);
        

%%%%%%%%%%%%% 
%%% (3) RUN DAD
C.th1l = 1; C.th1u = Inf;
C.th2l = 1; C.th2u = Inf;
Results = DAD2(Ytest,Xtrain,C,Xtest,Ttest,Ttrain);

% plot original data
figure; colorData2014(Data.Xtest, Data.Ttest)
figure; colorData2014(Results.YrKLMat, Data.Ttest)



