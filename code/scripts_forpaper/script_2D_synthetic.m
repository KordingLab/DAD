% set parameters

fileName = 'Results-2D-synthetic(1)'; 
Ts=.2; 
percent_samp = 0.5;
removedir = [0,2,7]; 
A = 180; %every 2 deg
numIter=10; 
N = 10:10:40;
dim = 2; % run DAD in 2D (kinematics alignment)
numsol = 5;

% Data = prepare_superviseddata(Ts,'mihi','mihi',[],0);
[Xtest,Ytest,Ttest,Xtrain,Ytrain,Ttrain,Ntest,Ntrain] = removedirdata(Data,removedir);

%%
% initialize variables
R2 = cell(length(N),numIter);
minVal = zeros(5,length(N),numIter);
R2sup = zeros(length(N),numIter);
R2ls = zeros(length(N),numIter);

for nn = 1:numIter
    
     % new split each iteration
     [Xtr,Ytr,Ttr,Xte,Yte,Tte] = splitdataset(Xtrain,Ytrain,Ttrain,Ntrain,percent_samp); 

    for i=1:length(N)
        
        % create synthetic dataset with kinematics Xte
        Yr = simmotorneurons(Xte,N(i),'modbase','exp');
        [Vr,Methods] = computeV(Yr,dim,[],Xte,Tte); % include args (Xte,Tte) to display embedding results
     
        
        %M1{1} = 'FA'; tmp = computeV(Yr,3,M1); 
        %tn = length(Vr); Vr{tn+1} = tmp{1}; Methods{tn+1} = 'FA'; 

        if dim==3
            display(['Num neurons = ',int2str(size(Yr,2))])
            [R2{i,nn},minVal(:,i,nn)] = calcR2_minKL3Dgrid(Vr,X3D,Xte,A,[],Methods,numsol); % input Methods is optional
        else
            display(['Num neurons = ',int2str(size(Yr,2))])
            [R2{i,nn},minVal(:,i,nn)] = calcR2_minKLgrid(Vr,Xtr,Xte,A,[],Methods,numsol); % input Methods is optional
        end
        
        pause, 
        
        % supervised decoder
        fldnum=10; lamnum=500;
        [Wsup, ~, ~, ~]= crossVaL(Ytr, Xtr, Yte, lamnum, fldnum);

        R2sup(i,nn) = evalR2(Xte,[Yte,ones(size(Yte,1),1)]*Wsup);
        display(['Supervised decoder, R2 = ', num2str(R2sup(i,nn),3)])
        
        % least squares error (best 2 dim projection)
        warning off, Wls = (Yte\Xte); 
        R2ls(i,nn) = evalR2(Xte,Yte*Wls);
        display(['Least-squares Projection, R2 = ', num2str(R2ls(i,nn),3)])
        display(['Iterations left = ', int2str(numIter -nn)])
        display('~~+~+~++~+~+~++~+~~*~*~**~~~+~+~+~+~~~+~++~~')
         
    end % end for loop (sweeping number of neurons)
    
    %save(fileName)
    
end % end for loop (iters across partitions)

% bootstrap sampling to get standard error
% r2boot = bootstrp(Nsamp,@median,R2');
% l2boot = bootstrp(Nsamp,@median,L2err');
% se = [std(r2boot)', std(l2boot)'];
% 
% save(fileName)
