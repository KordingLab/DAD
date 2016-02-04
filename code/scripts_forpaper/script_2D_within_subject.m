% script 3D alignment
% test synthetic + real data with same methods

%% (1) within subjects (iteration over different partitions of train/test sets)
% compute V (low-dim embeddings from dim red toolbox)
% apply 3d DAD ==> Results = minKL_grid3D(V,X3D,avec,svec,'L2',newk); 

% set parameters
numIter=10; 
Ts=.2; 
percent_samp = 0.5; % amount for training
removedir = [0,2,7]; 
A = 180; %every 2 deg
R2 = zeros(8,numIter); 
L2err = zeros(8,numIter);
minVal = zeros(6,numIter);
C = setinputparams();

if loaddata==1
    Data = prepare_superviseddata(Ts,'mihi','mihi',[],0);
    [Xtest,Ytest,Ttest,Xtrain,Ytrain,Ttrain,Ntest,Ntrain] = removedirdata(Data,removedir);
end

for nn = 1:numIter
    
    [Xtr,Ytr,Ttr,Xte,Yte,Tte] = splitdataset(Xtrain,Ytrain,Ttrain,Ntrain,percent_samp); 
    
    Results = DAD2(Yte,Xtr,C,Xte,Tte,Ttr);
    
    R2(1,nn) = Results.R2KL,

%     % supervised decoder
    fldnum=10; lamnum=500;
    [Wsup, ~, ~, ~]= crossVaL(Ytr, Xtr, Yte, lamnum, fldnum);

    r2sup = evalR2(Xte,[Yte,ones(size(Yte,1),1)]*Wsup);
    display(['Supervised decoder, R2 = ', num2str(r2sup,3)])    
    R2(2,nn) = r2sup;    
%     L2err(7,nn) = evalL2err(Xte,[Yte,ones(size(Yte,1),1)]*Wsup);
%     
%     % least squares error (best 2 dim projection)
    warning off, Wls = (Yte\Xte); r2ls = evalR2(Xte,Yte*Wls);
    display(['Least-squares Projection, R2 = ', num2str(r2ls,3)])
    R2(3,nn) = r2ls;
%     L2err(8,nn) = evalL2err(Xte,Yte*Wls);
%     display(['Iterations left = ', int2str(numIter -nn)])
%     
%     Results{nn} = Res;

end

% bootstrap sampling to get standard error
% r2boot = bootstrp(Nsamp,@median,R2');
% l2boot = bootstrp(Nsamp,@median,L2err');
% se = [std(r2boot)', std(l2boot)'];

% save Results_3D_within_subject(1)

% Results (w/ multiple restarts in conefit2.m)
%%%%%%%%%%%%
% numA = 180 , k = 9 , Method = PCA, R2 = 0.554
% numA = 180 , k = 9 , Method = MDS, R2 = -0.149
% numA = 180 , k = 9 , Method = GPLVM, R2 = -0.149
% numA = 180 , k = 9 , Method = ProbPCA, R2 = -0.149
% numA = 180 , k = 9 , Method = Isomap, R2 = -0.224
% numA = 180 , k = 9 , Method = FA, R2 = 0.626
% Supervised decoder, R2 = 0.666
% Least-squares Projection, R2 = 0.856
% Iterations left = 9
%%%%%%%%%%%%
% numA = 180 , k = 9 , Method = PCA, R2 = 0.0614
% numA = 180 , k = 9 , Method = MDS, R2 = 0.0614
% numA = 180 , k = 9 , Method = GPLVM, R2 = 0.0614
% numA = 180 , k = 9 , Method = ProbPCA, R2 = -0.927
% numA = 180 , k = 9 , Method = Isomap, R2 = -0.378
% numA = 180 , k = 9 , Method = FA, R2 = 0.557
% Supervised decoder, R2 = 0.691
% Least-squares Projection, R2 = 0.858
% Iterations left = 8
%%%%%%%%%%%%
% numA = 180 , k = 9 , Method = PCA, R2 = -0.166
% numA = 180 , k = 9 , Method = MDS, R2 = -0.906
% numA = 180 , k = 9 , Method = GPLVM, R2 = -0.91
% numA = 180 , k = 9 , Method = ProbPCA, R2 = -0.912
% numA = 180 , k = 9 , Method = Isomap, R2 = -0.447
% numA = 180 , k = 9 , Method = FA, R2 = 0.664
% Supervised decoder, R2 = 0.725
% Least-squares Projection, R2 = 0.856
% Iterations left = 7
%%%%%%%%%%%%


