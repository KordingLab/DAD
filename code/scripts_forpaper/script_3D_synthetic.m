% set parameters
loaddata = 1;
Nsamp = 5000;
Ts=.2; 
percent_samp = 0.1;
removedir = [0,2,7]; 
A = 180; %every 2 deg
numIter=20; 
N = [10,20,30,40,60,80,100];
dim = 3; % run DAD in 3D (kinematics alignment + speed)

if loaddata==1
    Data = prepare_superviseddata(Ts,'mihi','mihi',[],0);
    [Xtest,Ytest,Ttest,Xtrain,Ytrain,Ttrain,Ntest,Ntrain] = removedirdata(Data,removedir);
end

% initialize variables
R2 = zeros(5,4,length(N),numIter); % 5 DR methods, 4 recons (Xfinal, Vfa, Vflip, Vicp) 
R2sup = zeros(numIter,1);
R2ls = zeros(numIter,1);
minVal = zeros(5,length(N),numIter);
for nn = 1:numIter
    
    [Xtr,Ytr,Ttr,Xte,Yte,Tte,trainid,testid] = splitdataset(Xtrain,Ytrain,Ttrain,Ntrain,percent_samp); 
    X3D = mapX3D(Xtr);
    
    SplitStats{nn} = computesplitstats(Xte,Xtr,Tte,Ttr);
    SplitStats{nn}.trainid = trainid;
    SplitStats{nn}.testid = testid;
    
    % supervised decoder
    fldnum=10; lamnum=500;
    [Wsup, ~, ~, ~]= crossVaL(Ytr, Xtr, Yte, lamnum, fldnum);

    r2sup = evalR2(Xte,[Yte,ones(size(Yte,1),1)]*Wsup);
    warning('off'), Wls = (Yte\Xte); r2ls = evalR2(Xte,Yte*Wls);
    
    R2sup(nn) = r2sup;
    R2ls(nn) = r2ls;
        
    for i=1:length(N)   

        % create synthetic dataset with kinematics Xte
        Ysim = simmotorneurons(Xte,N(i),'modbase','exp');
        [Vsim,Methods] = computeV(Ysim,dim,[]); % supply optional args (Xtest,Ttest) to display embedding results

        if dim==3
            display(['Num neurons = ',int2str(size(Ysim,2))])
            [R2s,minVal(:,i,nn)] = calcR2_minKL3Dgrid(Vsim,X3D,Xte,A,[],Methods); % input Methods is optional
        else
            display(['Num neurons = ',int2str(size(Ysim,2))])
            [R2s,minVal(:,i,nn)] = calcR2_minKLgrid(Vsim,Xtr,Xte,A,[],Methods); % input Methods is optional
        end
        
        % compile R2s
        R2X = squeeze(R2s.R2X);
        R2V = squeeze(R2s.R2V);
        R2Vf = squeeze(R2s.R2Vf);
        R2Vicp = squeeze(R2s.R2Vicp);
        R2(:,:,i,nn) = [R2X, R2V, R2Vf, R2Vicp];
        
        display(['Supervised decoder, R2 = ', num2str(r2sup,3)])   
        display(['Least-squares Projection, R2 = ', num2str(r2ls,3)])
        display(['*********** Iterations left = ', int2str(numIter -nn), ' ***********'])
         
    end % end for loop (sweeping number of neurons)
end % end for loop (iters across partitions)

% bootstrap sampling to get standard error
% r2boot = bootstrp(Nsamp,@median,R2');
% l2boot = bootstrp(Nsamp,@median,L2err');
% se = [std(r2boot)', std(l2boot)'];

