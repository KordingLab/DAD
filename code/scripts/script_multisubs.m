
% 1. set parameters for pre-processing + running DAD
numSamp = 4; % number of samples to analyze after goCue + numDelay
numDelay=1; % number of samples to wait after goCue
psamp = 0.5; % percentage of data points used for training
whichtarg = [8,3,5,6]; % which targets to select reaches from
%whichtarg = [8,3,5]; % which targets to select reaches from
M1{1} = 'FA'; 
k = length(whichtarg); % number clusters for kmeans
numIter = 1; % number os iterations (to compute stats)

opts.gridsz = 3; % number of grid points to define 3D distribution
opts.method = 'KL'; % method for measuring alignment (default = 'L2' between point clouds)
opts.nzvar = 0.1;
opts.numA = 100; % maximum number of rotation angles to test in cone alignment (if < gridsz^3)
opts.finealign = 1;

%% get data
[Y1,T1,X1] = compile_neuraldata(whichtarg,numSamp,numDelay);

Res = cell(numIter,1);
for iter=1:numIter
    rng(iter-1)
    [Ytr,Yte0,Xtr,Xte0,Ttr,Tte0] = splitdata(Y1,X1,T1,psamp);
    Yte = downsamp_nd(Yte0,2);
    %Yte = Yte0;
    Xte = Xte0;
    Tte = Tte0;
    opts.rfac=round(size(Xte,1)/size(Xtr,1));
    Res{iter} = runDAD(Yte,Xtr,opts,Tte,Xte);
    Res{iter}.R2_2 = getR2fromRes(Xte,Res{iter}.Xrec);
end


%% visualize results
figure, 

% ground truth
subplot(2,2,1),
colorData(Xte,Tte)
title('Truth')
axis equal

% clustering kinematics
subplot(2,2,2),
labels = kmeans(normcol(Xte')',k);
colorData(Xte,labels)
title('Clustering based upon kinematics data')
axis equal

% neural data clustering
subplot(2,2,3),
labels = kmeans(normcol(full(Yte'))',k);
colorData(Xte,labels)
title('Clustering based upon neural data')
axis equal

% 3d embedding (neural data)
subplot(2,2,4),
[Vr,~] = computeV(Yte,3,M1);
Vfa = Vr{1};
colorData(Vfa,Tte)
title('Embedding')
axis equal

figure, 
subplot(2,2,2), colorData(normal(Xte(:,1:2)),Tte), 
title('Test kinematics')
axis equal

subplot(2,2,1), colorData(normal(Xtr(:,1:2)),Ttr),
title('Training kinematics')

subplot(2,2,3), colorData(Res{numIter}.V(:,1:2),Tte),
title('3D embedding (after cone alignment)')
axis equal

subplot(2,2,4), colorData(Res{numIter}.Xrec(:,1:2),Tte),
R2=getR2fromRes(Xte,Res{end}.Xrec);
title(['Final alignment = ', num2str(R2,2)])
axis equal


