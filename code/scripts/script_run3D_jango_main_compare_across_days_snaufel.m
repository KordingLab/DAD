
% 1. set parameters for pre-processing + running DAD
psamp = 0.5; % percentage of data points used for training
numIter = 1; % number os iterations (to compute stats)
whichtarg = [2,5,6,8]; % which targets to select reaches from
numD = [2,2,2,2];
numS = [4,4,4,4];

%%
% training set
[Ytr,Ttr,Xtr] = compile_jango_neuraldata(whichtarg,numS,numD,'binnedData_0801.mat');

% test set (1)
[Yte2,Tte2,Xte2] = compile_jango_neuraldata(whichtarg,numS,numD,'binnedData_0807.mat');
Yte2 = downsamp_nd(Yte2,2);

% test set (2)
[Yte3,Tte3,Xte3] = compile_jango_neuraldata(whichtarg,numS,numD,'binnedData_0819.mat');
Yte3 = downsamp_nd(Yte3,2);

[Yte4,Tte4,Xte4] = compile_jango_neuraldata(whichtarg,numS,numD,'binnedData_0901.mat');
Yte4 = downsamp_nd(Yte4,2);

%%% Train 01 - Test 07 (R2 = 0.4647 for Xrec)
%%% Train 07 - test 01 (R2 = 0.4007 for Xrec)
%%% Train 01 - Test 19 (R2 = 0.1932 for Vout)
%%% Train 07 - Test 19 (R2 = 0.3787 , FA)

% DAD - on test set (day 2)
opts.dimred_method = 'PCA';
opts.gridsz = 10;
opts.numT = 60;
[Xrec2,Vflip2,Vr2] = runDAD3d(Xtr,Yte2,opts);
Hinv = Xrec2(:,1:2)'*pinv(Yte2)';

%%%%% DAD - on second test set (day 3)
dimred_method = 'PCA';
[Xrec3,Vflip3,Vr3] = runDAD3d(Xtr,Yte3,dimred_method);
[Xrot3,id3] = find_closest_rot(Vflip3,Yte3,Hinv);

%%%%% DAD - on second test set (day 3)
dimred_method = 'Isomap';
[Xrec4,Vflip4,Vr4] = runDAD3d(Xtr,Yte4,dimred_method);
[Xrot4,id] = find_closest_rot(Vflip4,Yte4,Hinv);

visualize_performance_DAD(Xrec2,Xte2,Yte2,Tte2,Vr2,Xtr,Ttr);
visualize_performance_DAD(Xrec3,Xte3,Yte3,Tte3,Xrot3,Xtr,Ttr);
visualize_performance_DAD(Xrec4,Xte4,Yte4,Tte4,Xrot4,Xtr,Ttr);

%%
display('Xrec2')
evalR2(Xrec2,normal(Xte2(:,1:2)))
display('Xrec3')
evalR2(Xrec3,normal(Xte3(:,1:2)))
display('Xrec4')
evalR2(Xrec4,normal(Xte4(:,1:2)))
display('Xrot3')
evalR2(Xrot3,normal(Xte3(:,1:2)))
display('Xrot4')
evalR2(Xrot4,normal(Xte4(:,1:2)))

