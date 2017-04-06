% script to find out which monkeys / datasets provide sufficient embeddings
%removedir = [0, 1, 3, 6];

%%%%%
Data = prepare_superviseddata(0.1,'chewie1','chewie2',[],0);

numIter = 20;
numRemove = 3;
whichtarg = randi(9,numRemove,numIter)-1;
skwVals = zeros(3,numIter,5);
for i=1:numIter
    removedir = unique(whichtarg(:,i));

    figure,    
    for j=1:4
        numS = 6;
        numD = j-1;
        [~,Yte,~,~,~,~,~,~] = removedirdata(Data,removedir,numS,numD);
        Yte2 = downsamp_nd(Yte,2);
        Yr = remove_constcols(Yte2);
        M1{1} = 'FA';
        [Vr,~] = computeV(Yr,3,M1);
    
        skwVals(:,i,j) = skewness(Vr{1});
             
        subplot(5,3,(j-1)*3 +1), hist(Vr{1}(:,1),50), 
        title(num2str(skwVals(1,i,j),2)),
        subplot(5,3,(j-1)*3 +2), hist(Vr{1}(:,1),50), 
        title(num2str(skwVals(2,i,j),2)),
        subplot(5,3,(j-1)*3 +3), hist(Vr{1}(:,1),50), 
        title(num2str(skwVals(3,i,j),2)),
         
    end
end


%%%%%
Data = prepare_superviseddata(0.1,'chewie1','mihi',[],0);
[Xte,Yte,Tte,Xtr,Ytr,Ttr,Nte,Ntr] = removedirdata(Data,removedir);
Yte2 = downsamp_nd(Yte,2);
X3d = normal(mapX3D(Xtr));
Yr = remove_constcols(Yte2);
M1{1} = 'FA';
[Vr,~] = computeV(Yr,3,M1);

subplot(5,3,4), hist(Vr{1}(:,1),50), 
title(num2str(skewness(Vr{1}(:,1)),2)), 
subplot(5,3,5), hist(Vr{1}(:,2),50), 
title(num2str(skewness(Vr{1}(:,2)),2)), 
subplot(5,3,6), hist(Vr{1}(:,3),50), 
title(num2str(skewness(Vr{1}(:,3)),2))


%%

psamp = 0.5; % percentage of data points used for training
numIter = 1; % number os iterations (to compute stats)
whichtarg = [2,5,6,8]; % which targets to select reaches from
numD = [2,2,2,2];
numS = [4,4,4,4];

%%
% training set
[Ytr,Ttr,Xtr] = compile_neuraldata(whichtarg,numS,numD,'binnedData_0801.mat');

% test set (1)
[Yte2,Tte2,Xte2] = compile_neuraldata(whichtarg,numS,numD,'binnedData_0807.mat');
Yte2 = downsamp_nd(Yte2,2);
Yr = remove_constcols(Yte2);
M1{1} = 'FA';
[Vr,~] = computeV(Yr,3,M1);

subplot(5,3,7), hist(Vr{1}(:,1),50), 
title(num2str(skewness(Vr{1}(:,1)),2)), 
subplot(5,3,8), hist(Vr{1}(:,2),50), 
title(num2str(skewness(Vr{1}(:,2)),2)), 
subplot(5,3,9), hist(Vr{1}(:,3),50), 
title(num2str(skewness(Vr{1}(:,3)),2))


% test set (2)
[Yte3,Tte3,Xte3] = compile_neuraldata(whichtarg,numS,numD,'binnedData_0819.mat');
Yte3 = downsamp_nd(Yte3,2);

Yr = remove_constcols(Yte3);
M1{1} = 'FA';
[Vr,~] = computeV(Yr,3,M1);
 
subplot(5,3,10), hist(Vr{1}(:,1),50), 
title(num2str(skewness(Vr{1}(:,1)),2)), 
subplot(5,3,11), hist(Vr{1}(:,2),50), 
title(num2str(skewness(Vr{1}(:,2)),2)), 
subplot(5,3,12), hist(Vr{1}(:,3),50), 
title(num2str(skewness(Vr{1}(:,3)),2))

[Yte4,Tte4,Xte4] = compile_neuraldata(whichtarg,numS,numD,'binnedData_0901.mat');
Yte4 = downsamp_nd(Yte4,2);

Yr = remove_constcols(Yte4);
M1{1} = 'FA';
[Vr,~] = computeV(Yr,3,M1);

subplot(5,3,13), hist(Vr{1}(:,1),50), 
title(num2str(skewness(Vr{1}(:,1)),2)), 
subplot(5,3,14), hist(Vr{1}(:,2),50), 
title(num2str(skewness(Vr{1}(:,2)),2)), 
subplot(5,3,15), hist(Vr{1}(:,3),50), 
title(num2str(skewness(Vr{1}(:,3)),2))





