
%setuppath
%numA = 90; %every 2 deg
Ts=.20;
percent_test = 1;
removedir = [0, 1, 2];
M1{1} = 'FA'; % dont need dr toolbox for factor analysis 
%%%%% user input
percent_samp = 0.5;
supmethod = 1; 

%% Chewie and Mihi Data
Data0 = prepare_superviseddata(Ts,'chewie1','mihi',[]);
Data = prepare_superviseddata(Ts,'mihi','mihi',[],0);
[~,~,~,XtrC0,YtrC0,TtrC0,~,NtrC0] = removedirdata(Data0,removedir);
[~,~,~,Xtrain,Ytrain,Ttrain,~,Ntrain] = removedirdata(Data,removedir);

[XtrC,YtrC,TtrC,XteC,YteC,TteC,trainidC,testidC] = splitdataset(XtrC0,YtrC0,TtrC0,NtrC0,percent_samp); 
[XtrM,YtrM,TtrM,XteM,YteM,TteM,trainidM,testidM] = splitdataset(Xtrain,Ytrain,Ttrain,Ntrain,percent_samp); 
  
%% Jango Data
whichtarg = [2,5,6,8]; % which targets to select reaches from
numD = [2,2,2,2];
numS = [4,4,4,4];

% training set
[YtrJ,TtrJ,XtrJ] = compile_neuraldata(whichtarg,numS,numD,'binnedData_0801.mat');

% test set (1)
[YteJ2,TteJ2,XteJ2] = compile_neuraldata(whichtarg,numS,numD,'binnedData_0807.mat');
YteJ2 = downsamp_nd(YteJ2,2);

% test set (2)
[YteJ3,TteJ3,XteJ3] = compile_neuraldata(whichtarg,numS,numD,'binnedData_0819.mat');
YteJ3 = downsamp_nd(YteJ3,2);

[YteJ4,TteJ4,XteJ4] = compile_neuraldata(whichtarg,numS,numD,'binnedData_0901.mat');
YteJ4 = downsamp_nd(YteJ4,2);


%% run DAD on all 5 datasets

[XrecM,VflipM,VrM,minKLM,meanresM] = runDAD3d(mapX3D(XtrM),YteM,[]);
[XrecC,VflipC,VrC,minKLC,meanresC] = runDAD3d(mapX3D(XtrM),YtrC0,[]);
[XrecJ2,VflipJ2,VrJ2,minKLJ2,meanresJ2] = runDAD3d(XtrJ,YteJ2,[]);
[XrecJ3,VflipJ3,VrJ3,minKLJ3,meanresJ3] = runDAD3d(XtrJ,YteJ3,[]);
[XrecJ4,VflipJ4,VrJ4,minKLJ4,meanresJ4] = runDAD3d(XtrJ,YteJ4,[]);

Methods{1} = 'PCA';
Methods{2} = 'MDS';
Methods{3} ='FA';
Methods{4} = 'ProbPCA';
Methods{5}='Isomap';

%% compute R2 values

R2_alldata = zeros(5,5);
for i=1:5, 
    R2_alldata(1,i) = evalR2(XteM(:,1:2),XrecM{i}); 
    R2_alldata(2,i) = evalR2(XtrC0(:,1:2),XrecC{i}); 
    R2_alldata(3,i) = evalR2(XteJ2(:,1:2),XrecJ2{i}); 
    R2_alldata(4,i) = evalR2(XteJ3(:,1:2),XrecJ3{i}); 
    R2_alldata(5,i) = evalR2(XteJ4(:,1:2),XrecJ4{i}); 
end

KL_alldata = zeros(5,5);
for i=1:5, 
    KL_alldata(1,i) =  min(minKLM{i});
    KL_alldata(2,i) =  min(minKLC{i});
    KL_alldata(3,i) =  min(minKLJ2{i});
    KL_alldata(4,i) =  min(minKLJ3{i});
    KL_alldata(5,i) =  min(minKLJ4{i});
end

VarExp_alldata(1,:) =  meanresM;
VarExp_alldata(2,:) =  meanresC;
VarExp_alldata(3,:) =  meanresJ2;
VarExp_alldata(4,:) =  meanresJ3;
VarExp_alldata(5,:) =  meanresJ4;


%figure, 



