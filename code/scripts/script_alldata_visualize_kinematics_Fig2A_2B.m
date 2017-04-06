% script to compare kinematics data across monkeys

%% Jango data 
psamp = 0.5; % percentage of data points used for training
numIter = 1; % number os iterations (to compute stats)
whichtarg = [2,5,6,8]; % which targets to select reaches from
numD = [2,2,2,2];
numS = [4,4,4,4];

[Ytr,Ttr,Xtr] = compile_neuraldata(whichtarg,numS,numD,'binnedData_0801.mat');
[Yte2,Tte2,Xte2] = compile_neuraldata(whichtarg,numS,numD,'binnedData_0807.mat');
Yte2 = downsamp_nd(Yte2,2);
[Yte3,Tte3,Xte3] = compile_neuraldata(whichtarg,numS,numD,'binnedData_0819.mat');
Yte3 = downsamp_nd(Yte3,2);
[Yte4,Tte4,Xte4] = compile_neuraldata(whichtarg,numS,numD,'binnedData_0901.mat');
Yte4 = downsamp_nd(Yte4,2);

figure, % figure 2B
subplot(2,2,1), colorData(Xtr,Ttr), view(3), axis equal
subplot(2,2,2), colorData(Xte2,Tte2), view(3), axis equal
subplot(2,2,3), colorData(Xtr,Ttr), axis equal
subplot(2,2,4), colorData(Xte2,Tte2), axis equal


%% Mihili and Cedata
removedir = [0, 1,3,6];
Data = prepare_superviseddata(0.05,'chewie1','mihi',[],0);
[Xte,Yte,Tte,Xtr,Ytr,Ttr,Nte,Ntr] = removedirdata(Data,removedir);

figure, % figure 2A
subplot(2,2,1), colorData(mapX3D(Xtr),Ttr), view(3), axis equal
subplot(2,2,2), colorData(mapX3D(Xte),Tte), view(3), axis equal
subplot(2,2,3), colorData(Xtr,Ttr), axis equal
subplot(2,2,4), colorData(Xte,Tte), axis equal


