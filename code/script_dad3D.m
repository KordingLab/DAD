% script 3D alignment
% test synthetic + real data with same methods

%% across subjects
%Data = preparedata_chewiemihi(0.2);
%[Xtest,Ytest,Ttest,Xtrain,Ytrain,Ttrain] = removedirdata(Data,removedir);

%%%% training data is taken from finer sampling (2x sampling rate of test)
%Data2x = preparedata_chewiemihi(Ts/2);

Data2s = prepare_superviseddata(Ts,'chewie1','mihi',[],0);
%[~,~,~,Xtrain2x,~,Ttrain2x] = removedirdata(Data2x,removedir);

%% (1) within subjects (iteration over different partitions of train/test sets)
% compute V (low-dim embeddings from dim red toolbox)
% apply 3d DAD ==> Results = minKL_grid3D(V,X3D,avec,svec,'L2',newk); 

% set parameters
Ts=.2; 
percent_samp = 0.5;
removedir = [0,2,7]; 
A = 180; %every 2 deg
numIter=50; 
R2 = zeros(8,numIter); 
L2err = zeros(8,numIter);
minVal = zeros(6,numIter);

Data = prepare_superviseddata(Ts,'mihi','mihi',[],0);
[Xtest,Ytest,Ttest,Xtrain,Ytrain,Ttrain] = removedirdata(Data,removedir);

% run3Ddad_bootstrap.m



%% run 3D DAD for simulated data (2D)
% N = 10:5:40;
% Methods_sim = Methods;  
% Methods_sim{6} = 'ExpPCA';
% M1{1} = 'ExpPCA';
% 
% dim = 2;
% for i=1:length(N)
%     
%     Ysim = simmotorneurons(Xtest,N(i),'modbase','exp');
%     
%     % simulated data
%     Vsim = computeV(Ysim,dim,[],Xtest,Ttest); 
% %     tmp = computeV(Ysim,dim,M1,Xtest,Ttest); 
% %     tn = length(Vsim); Vsim{tn+1} = tmp{1}; 
%     
%     if dim==3
%         display(['Num neurons = ',int2str(size(Ysim,2))])
%         [R2s(:,i),minVs(:,i)] = calcR2_minKL3Dgrid(Vsim,X3D,Xtest,A,[],Methods); % input Methods is optional
%     else
%         display(['Num neurons = ',int2str(size(Ysim,2))])
%         [R2s(:,i),minVs(:,i)] = calcR2_minKLgrid(Vsim,Xtrain,Xtest,A,[],Methods); % input Methods is optional
%     end
%     
%     warning off, Wls = (Ysim\Xtest); R2ls(i) = evalR2(Xtest,Ysim*Wls);
%     display(['Least-squares Projection, R2 = ', num2str(R2ls(i),3)])
% 
%     
% end % end for loop (sweeping number of neurons)
        
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

