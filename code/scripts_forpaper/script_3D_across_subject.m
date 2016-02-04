% script 3D alignment
% test synthetic + real data with same methods

%% across subjects

fileName = 'Results-3D-across-subject-remove012';
Nsamp = 5000;
Ts=.2; 
percent_samp = 0.5;
%removedir = [0,2,7]; 
removedir = [0,1,2]; 

A = 180; %every 2 deg
numIter=1; 
R2 = zeros(8,numIter); 
L2err = zeros(8,numIter);
minVal = zeros(6,numIter);
loaddata=1;

if loaddata==1
    Data = prepare_superviseddata(Ts,'chewie1','mihi',[]);
    [Xtest,Ytest,Ttest,Xtrain,Ytrain,Ttrain] = removedirdata(Data,removedir);
end

numIter = 1;
for nn = 1:numIter
    % supply optional args (Xtest,Ttest) to display embedding results
    Ny = size(Ytrain,1);
    
    Xtr = Xtrain;
    Ytr = Ytrain;
    Ttr = Ttrain;
    
    Xte = Xtest;
    Yte = Ytest;
    Tte = Ttest;
    
    X3D = mapX3D(Xtr);

    % throw away neurons that dont fire
    id2 = find(sum(Yte)<30); 
    Yr = Yte; 
    Yr(:,id2)=[];

    [Vr,Methods] = computeV(Yr,3,[]); 

    % compute V (low-dim embeddings with factor analysis)
    M1{1} = 'FA'; tmp = computeV(Yr,3,M1); 
    tn = length(Vr); Vr{tn+1} = tmp{1}; Methods{tn+1} = 'FA'; 

    % 3d DAD
    [R2, minVal, Results] = calcR2_minKL3Dgrid(Vr,X3D,Xte,A,[],Methods); % input Methods is optional
    
    
    
    
    
    
    
    R2(1:6,nn) = squeeze(r2val);
    minVal(1:6,nn) = squeeze(minval);
    
    % supervised decoder
%     fldnum=10; lamnum=500;
%     [Wsup, ~, ~, ~]= crossVaL(Ytr, Xtr, Yte, lamnum, fldnum);

%     r2sup = evalR2(Xte,[Yte,ones(size(Yte,1),1)]*Wsup);
%     display(['Supervised decoder, R2 = ', num2str(r2sup,3)])    
%     R2(7,nn) = r2sup;    
%     L2err(7,nn) = evalL2err(Xte,[Yte,ones(size(Yte,1),1)]*Wsup);
    
    % least squares error (best 2 dim projection)
    warning off, Wls = (Yte\Xte); r2ls = evalR2(Xte,Yte*Wls);
    display(['Least-squares Projection, R2 = ', num2str(r2ls,3)])
    R2(7,nn) = r2ls;
    L2err(7,nn) = evalL2err(Xte,Yte*Wls);
    display(['Iterations left = ', int2str(numIter -i)])
    save('Results-3D-across-subject-1')
end


% bootstrap sampling to get standard error
%r2boot = bootstrp(Nsamp,@median,R2');
%l2boot = bootstrp(Nsamp,@median,L2err');
%se = [std(r2boot)', std(l2boot)'];

%save('Results-3D-across-subject-1')



%%%%%%%%%%%%
%% Results
%%%%%%%%%%%%%

% 2D Matching N = 200 (syn neurons)
% numA = 180 , k = 9 , Method = MDS, R2 = 0.949
% numA = 180 , k = 9 , Method = GPLVM, R2 = 0.949
% numA = 180 , k = 9 , Method = ProbPCA, R2 = 0.949
% numA = 180 , k = 9 , Method = Isomap, R2 = 0.905
% numA = 180 , k = 9 , Method = ExpPCA, R2 = 0.897

% 2D Matching N = 500 (syn neurons)
% numA = 180 , k = 9 , Method = PCA, R2 = 0.953
% numA = 180 , k = 9 , Method = MDS, R2 = 0.953
% numA = 180 , k = 9 , Method = GPLVM, R2 = 0.953
% numA = 180 , k = 9 , Method = ProbPCA, R2 = 0.953
% numA = 180 , k = 9 , Method = Isomap, R2 = 0.932

% 2D Matching
% Preprocessing data using PCA...
% Learn GPLVM model...
% ........................................ 
% Constructing neighborhood graph...
% Computing shortest paths...
% Constructing low-dimensional embedding...
% Num neurons = 200
% numA = 180 , k = 9 , Method = PCA, R2 = 0.947
% numA = 180 , k = 9 , Method = MDS, R2 = 0.947
% numA = 180 , k = 9 , Method = GPLVM, R2 = 0.947
% numA = 180 , k = 9 , Method = ProbPCA, R2 = 0.947
% numA = 180 , k = 9 , Method = Isomap, R2 = 0.92
% numA = 180 , k = 9 , Method = ExpPCA, R2 = 0.702
% Preprocessing data using PCA...
% Learn GPLVM model...
% ........................................ 
% Constructing neighborhood graph...
% Computing shortest paths...
% Constructing low-dimensional embedding...
% Num neurons = 400
% numA = 180 , k = 9 , Method = PCA, R2 = 0.952
% numA = 180 , k = 9 , Method = MDS, R2 = 0.952
% numA = 180 , k = 9 , Method = GPLVM, R2 = 0.952
% numA = 180 , k = 9 , Method = ProbPCA, R2 = 0.952
% numA = 180 , k = 9 , Method = Isomap, R2 = 0.826
% numA = 180 , k = 9 , Method = ExpPCA, R2 = 0.87
% Preprocessing data using PCA...
% Learn GPLVM model...
% ........................................ 
% Constructing neighborhood graph...
% Computing shortest paths...
% Constructing low-dimensional embedding...
% Num neurons = 600
% numA = 180 , k = 9 , Method = PCA, R2 = 0.941
% numA = 180 , k = 9 , Method = MDS, R2 = 0.941
% numA = 180 , k = 9 , Method = GPLVM, R2 = 0.941
% numA = 180 , k = 9 , Method = ProbPCA, R2 = 0.94
% numA = 180 , k = 9 , Method = Isomap, R2 = 0.714
% numA = 180 , k = 9 , Method = ExpPCA, R2 = 0.917
% Preprocessing data using PCA...
% Learn GPLVM model...
% ........................................ 
% Constructing neighborhood graph...
% Computing shortest paths...
% Constructing low-dimensional embedding...
% Num neurons = 800
% numA = 180 , k = 9 , Method = PCA, R2 = 0.955
% numA = 180 , k = 9 , Method = MDS, R2 = 0.955
% numA = 180 , k = 9 , Method = GPLVM, R2 = 0.955
% numA = 180 , k = 9 , Method = ProbPCA, R2 = 0.954
% numA = 180 , k = 9 , Method = Isomap, R2 = 0.944
% numA = 180 , k = 9 , Method = ExpPCA, R2 = 0.932
% Preprocessing data using PCA...
% Learn GPLVM model...
% ........................................ 
% Constructing neighborhood graph...
% Computing shortest paths...
% Constructing low-dimensional embedding...
% Num neurons = 1000
% numA = 180 , k = 9 , Method = PCA, R2 = 0.958
% numA = 180 , k = 9 , Method = MDS, R2 = 0.958
% numA = 180 , k = 9 , Method = GPLVM, R2 = 0.958
% numA = 180 , k = 9 , Method = ProbPCA, R2 = 0.959
% numA = 180 , k = 9 , Method = Isomap, R2 = 0.931
% numA = 180 , k = 9 , Method = ExpPCA, R2 = 0.956
%%%%%%%%%%%%%




%%%%%%%%%%%%%
% N = 500 (synthetic exp neurons) (3D matching)
% numA = 180 , k = 9 , Method = PCA, R2 = 0.568
% numA = 180 , k = 9 , Method = MDS, R2 = 0.568
% numA = 180 , k = 9 , Method = GPLVM, R2 = 0.568
% numA = 180 , k = 9 , Method = ProbPCA, R2 = 0.556
% numA = 180 , k = 9 , Method = Isomap, R2 = -0.0352
% numA = 180 , k = 9 , Method = ExpPCA, R2 = 0.377

% % N = 200 (synthetic exp neurons) (3D matching)
% numA = 180 , k = 9 , Method = PCA, R2 = 0.699
% numA = 180 , k = 9 , Method = MDS, R2 = 0.699
% numA = 180 , k = 9 , Method = GPLVM, R2 = 0.699
% numA = 180 , k = 9 , Method = ProbPCA, R2 = 0.714
% numA = 180 , k = 9 , Method = Isomap, R2 = 0.419
% numA = 180 , k = 9 , Method = ExpPCA, R2 = 0.778


% %%%% simulated data
% numA = 180 , k = 9 , Method = PCA, R2 = -0.361
% numA = 180 , k = 9 , Method = MDS, R2 = -0.361
% numA = 180 , k = 9 , Method = GPLVM, R2 = 0.565
% numA = 180 , k = 9 , Method = ProbPCA, R2 = 0.551
% numA = 180 , k = 9 , Method = Isomap, R2 = -0.117
% numA = 180 , k = 9 , Method = ExpPCA, R2 = -0.287

% using 2x kinematics to train (thr = 20 to remove neurons)
% numA = 180 , k = 9 , Method = PCA, R2 = -1.63
% numA = 180 , k = 9 , Method = MDS, R2 = -1.63
% numA = 180 , k = 9 , Method = GPLVM, R2 = 0.476
% numA = 180 , k = 9 , Method = ProbPCA, R2 = 0.475
% numA = 180 , k = 9 , Method = Isomap, R2 = -0.513
% numA = 180 , k = 9 , Method = FA, R2 = 0.656

% using same kinematics to train (thr = 20 to remove neurons)
% R2 = [0.4767, 0.4767, 0.4767, 0.4767, -0.5133, 0.6556]

% R2(:,:,1) =
% 
%     0.4785    0.4785    0.4668    0.4668    0.4785    0.4785
%     0.4775    0.4721    0.4721    0.4721    0.4721    0.4775
%     0.4772    0.4737    0.4737    0.4737    0.4737    0.4772

% R2(:,:,2) =
% 
%     0.4785    0.4785    0.4668    0.4668    0.4785    0.4785
%     0.4775    0.4721    0.4721    0.4721    0.4721    0.4775
%     0.4772    0.4737    0.4737    0.4737    0.4737    0.4772

%R2(:,:,4) =
% 
%     0.4785    0.4785    0.4668    0.4668    0.4785    0.4785
%     0.4775    0.4721    0.4721    0.4721    0.4721    0.4775
%     0.4772    0.4737    0.4737    0.4737    0.4737    0.4772

%%%%%%%%%
% All methods tested
%'GDA','SNE','SymSNE','tSNE','LPP','NPE','LLTSA','SPE','LLC',
%'ManifoldChart','CFA','NCA','MCML','LMNN'
%%%%%%%%%
% PCA:            - none
%     LDA:            - none
%     MDS:            - none
%     ProbPCA:        - <int> max_iterations -> default = 200
%     FactorAnalysis: - none
%     GPLVM:          - <double> sigma -> default = 1.0
%     Sammon:         - none
%     Isomap:         - <int> k -> default = 12
%     LandmarkIsomap: - <int> k -> default = 12
%                     - <double> percentage -> default = 0.2
%     LLE:            - <int> k -> default = 12
%                     - <char[]> eig_impl -> {['Matlab'], 'JDQR'}
%     Laplacian:      - <int> k -> default = 12
%                     - <double> sigma -> default = 1.0
%                     - <char[]> eig_impl -> {['Matlab'], 'JDQR'}
%     HessianLLE:     - <int> k -> default = 12
%                     - <char[]> eig_impl -> {['Matlab'], 'JDQR'}
%     LTSA:           - <int> k -> default = 12
%                     - <char[]> eig_impl -> {['Matlab'], 'JDQR'}
%     MVU:            - <int> k -> default = 12
%                     - <char[]> eig_impl -> {['Matlab'], 'JDQR'}
%     CCA:            - <int> k -> default = 12
%                     - <char[]> eig_impl -> {['Matlab'], 'JDQR'}
%     LandmarkMVU:    - <int> k -> default = 5
%     FastMVU:        - <int> k -> default = 5
%                     - <logical> finetune -> default = true
%                     - <char[]> eig_impl -> {['Matlab'], 'JDQR'}
%     DiffusionMaps:  - <double> t -> default = 1.0
%                     - <double> sigma -> default = 1.0
%     KernelPCA:      - <char[]> kernel -> {'linear', 'poly', ['gauss']} 
%                     - kernel parameters: type HELP GRAM for info
%     GDA:            - <char[]> kernel -> {'linear', 'poly', ['gauss']} 
%                     - kernel parameters: type HELP GRAM for info
%     SNE:            - <double> perplexity -> default = 30
%     SymSNE:         - <double> perplexity -> default = 30
%     tSNE:           - <int> initial_dims -> default = 30
%                     - <double> perplexity -> default = 30
%     LPP:            - <int> k -> default = 12
%                     - <double> sigma -> default = 1.0
%                     - <char[]> eig_impl -> {['Matlab'], 'JDQR'}
%     NPE:            - <int> k -> default = 12
%                     - <char[]> eig_impl -> {['Matlab'], 'JDQR'}
%     LLTSA:          - <int> k -> default = 12
%                     - <char[]> eig_impl -> {['Matlab'], 'JDQR'}
%     SPE:            - <char[]> type -> {['Global'], 'Local'}
%                     - if 'Local': <int> k -> default = 12
%     Autoencoder:    - <double> lambda -> default = 0
%     LLC:            - <int> k -> default = 12
%                     - <int> no_analyzers -> default = 20
%                     - <int> max_iterations -> default = 200
%                     - <char[]> eig_impl -> {['Matlab'], 'JDQR'}
%     ManifoldChart:  - <int> no_analyzers -> default = 40
%                     - <int> max_iterations -> default = 200
%                     - <char[]> eig_impl -> {['Matlab'], 'JDQR'}
%     CFA:            - <int> no_analyzers -> default = 2
%                     - <int> max_iterations -> default = 200
%     NCA:            - <double> lambda -> default = 0.0
%     MCML:           - none
%     LMNN:           - <int> k -> default = 3

