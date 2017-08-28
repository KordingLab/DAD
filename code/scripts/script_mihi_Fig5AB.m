%script_run3D_DAD_Mihi

removedir = [0,1,2,6];
opts.gridsz=10;
opts.check2D=1;
Data = prepare_superviseddata(0.22,'chewie1','mihi',[],0);
[Xte,Yte,Tte,Xtr,Ytr,Ttr,Nte,Ntr] = removedirdata(Data,removedir);
Yte2 = remove_constcols(Yte);
%Yte2 = downsamp_nd(Yte,0);

%%
opts.dimred_method = 'FA';
numIter=1;

%psamp=1;
psamp = 0.2:0.1:0.9; % what percentage of dataset to use for training
R2Vals = zeros(2,length(psamp),numIter);
PcorrVals = zeros(2,length(psamp),numIter);
MSEVals = zeros(2,length(psamp),numIter);

R2ValsSup = zeros(6,length(psamp),numIter);
PcorrValsSup = zeros(6,length(psamp),numIter);
MSEValsSup = zeros(6,length(psamp),numIter);

for num = 1:numIter
    
    [Xout,Yout,Tout] = permutetrials(Xte,Yte2,Tte);
    Yte2 = Yte2 + randn(size(Yte2))*0.05;    
    
    for i=1:length(psamp)
    
        [ID1,ID2] = split_dataset(Tout,psamp(i));
    
        Xtrain = Xout(ID1,:);
        Xtest = Xout(ID2,:);

        Ytrain = Yout(ID1,:);
        Ytest = Yout(ID2,:);

        Ttrain = Tout(ID1,:);
        Ttest = Tout(ID2,:);

        [Xrec1,~,~,~,tmp] = runDAD3d(Xtr,Ytrain,opts);
    
        H = pinv(Ytrain)*Xrec1;
        Xtest1 = Ytest*H;
    
        R2Vals(:,i,num) = [evalR2(Xrec1,Xtrain), evalR2(Xtest1,Xtest)];
        PcorrVals(:,i,num) = [evalTargetErr(Xrec1,Xtrain,Ttrain), evalTargetErr(Xtest1,Xtest,Ttest)];
        MSEVals(:,i,num) = [evalMSE(Xrec1,Xtrain), evalMSE(Xtest1,Xtest)];
        
        [R2ValsSup(:,i,num), PcorrValsSup(:,i,num), MSEValsSup(:,i,num)] = run_supervisedmethods(Xtrain,Xtest,Ytrain,Ytest,Ttrain,Ttest);
        
        display(['R2 Train = ', num2str(R2Vals(1,i,num),3)])
        display(['R2 Test = ', num2str(R2Vals(2,i,num),3)])
    end
    display(['~~~~*****~~~~~~ Num Iter Left = ', int2str(numIter-num)])
end
