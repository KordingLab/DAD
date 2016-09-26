% Script to run DAD on new datasets

% 1. set parameters for pre-processing + running DAD
gridsz = 2; % number of grid points to define 3D distribution
numSamp = 10; % number of samples to analyze after goCue + numDelay
numDelay=5; % number of samples to wait after goCue
psamp = 0.6; % percentage of data points used for training
whichtarg = [1:8]; % which targets to select reaches from
method = 'KL'; % method for measuring alignment (default = 'L2' between point clouds)
numA = 20; % maximum number of rotation angles to test in cone alignment (if < gridsz^3)
finealign = 1;

% generating train and test sets
[Y,T,X] = compile_neuraldata(whichtarg,numSamp,numDelay);
[Ytr,Yte0,Xtr,Xte0,Ttr,Tte0] = splitdata(Y,X,T,psamp);

%Yte = downsamp_nd(Yte0,10);
Yte = Yte0;
Xte = Xte0;
Tte = Tte0;

%id1 = find(sum(normal(Xtr)'.^2)<0.3); % remove kinematics data at origin
%Xtr(id1,:)=[];
%Ttr(id1)=[];

id1 = find(sum(normal(Xte)'.^2)<0.8); % remove kinematics data at origin
Xte(id1,:)=[];
Tte(id1)=[]; Yte(id1,:)=[];

%%
% run DAD
tic, Res = runDAD(Yte,Xtr,gridsz,[],Tte,Xte); toc

% figure, 
% subplot(1,2,1), colorData(normal(Xte(:,1:2)),Tte), 
% title(['Training kinematics (numSamp =', int2str(numSamp), ', numDelay = ', ...
%     int2str(numDelay), ', psamp = ', num2str(psamp*100), '%)'])
% 
% subplot(1,2,2), colorData(normal(Res.V(:,1:2)),Tte)
% title(['Final embedding (numSamp =', int2str(numSamp), ', numDelay = ', ...
%     int2str(numDelay), ', psamp = ', num2str(psamp*100), '%)'])

 
% figure, 
% subplot(1,2,1), colorData(normal(Xte(:,1:3)),Tte), 
% title(['Ground truth kinematics (numSamp =', int2str(numSamp), ', numDelay = ', ...
%     int2str(numDelay), ', psamp = ', num2str(psamp*100), '%)'])
% 
% subplot(1,2,2), colorData(normal(Res.V(:,1:3)),Tte)
% title(['Final embedding (numSamp =', int2str(numSamp), ', numDelay = ', ...
%     int2str(numDelay), ', psamp = ', num2str(psamp*100), '%)'])

figure, 
subplot(3,2,1), colorData(normal(Xte(:,1:3)),Tte), 
title(['Training kinematics (numSamp =', int2str(numSamp), ', numDelay = ', ...
    int2str(numDelay), ', psamp = ', num2str(psamp*100), '%)'])

subplot(3,2,2), colorData(normal(Xtr(:,1:3)),Ttr), 
title(['Training kinematics (numSamp =', int2str(numSamp), ', numDelay = ', ...
    int2str(numDelay), ', psamp = ', num2str(psamp*100), '%)'])

subplot(3,2,3), colorData(normal(Res.V(:,1:3)),Tte)
title(['3D embedding (numSamp =', int2str(numSamp), ', numDelay = ', ...
    int2str(numDelay), ', psamp = ', num2str(psamp*100), '%)'])

subplot(3,2,4), colorData(normal(Res.Xrec(:,1:2)),Tte)
title(['Final 2D embedding (numSamp =', int2str(numSamp), ', numDelay = ', ...
    int2str(numDelay), ', psamp = ', num2str(psamp*100), '%)'])

subplot(3,2,5), colorData(normal(Res.Vflip{1}(:,1:2)),Tte)
title(['Vflip 1 (numSamp =', int2str(numSamp), ', numDelay = ', ...
    int2str(numDelay), ', psamp = ', num2str(psamp*100), '%)'])

subplot(3,2,6), colorData(normal(Res.Vflip{2}(:,1:2)),Tte)
title(['Vflip 2 (numSamp =', int2str(numSamp), ', numDelay = ', ...
    int2str(numDelay), ', psamp = ', num2str(psamp*100), '%)'])
