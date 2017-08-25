% script - synthetic data with different DR techniques (Supp Fig)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1. Setup experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this is slow. comment out if you have already downloaded Data structs
Ts=.10;
Data0 = prepare_superviseddata(Ts,'chewie1','mihi',[]);
Data = prepare_superviseddata(Ts,'mihi','mihi',[],0);

%setuppath
numA = 90; %every 2 deg
percent_test = 1;
numsteps=length(percent_test);
removedir = [0,1,2];
Ntot = 1027;
M1{1} = 'FA'; % dont need dr toolbox for factor analysis 

% parameters for DAD
opts.gridsz = 3;
opts.method = 'KL';
opts.nzvar=0;
opts.rfac=0;

%%%%% user input
%percent_samp = input('Amount to train on (scalar between 0,1): ');

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2. Prepare training and test datasets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~,~,~,XtrC,~,~,~,~] = removedirdata(Data0,removedir);
[~,~,~,Xtrain,Ytrain,Ttrain,~,Ntrain] = removedirdata(Data,removedir);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 3. Run DAD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize variables

supmethod=1;
numNeurons = 2.^(3:10);
numsamp = [0.1,0.2,0.3,0.4];
%numsamp = 0.2;
M2{1} = 'PCA';

numIter=50;
R2vals = zeros(2,length(numNeurons),length(numsamp),numIter);
for nn = 1:numIter
for j=1:length(numsamp)
    [Xtr,~,Ttr,Xte,~,Tte,trainid,testid] = splitdataset(Xtrain,Ytrain,Ttrain,Ntrain,numsamp(j)); 
for i=1:length(numNeurons)
    [Ytr] = simmotorneurons(Xtr,numNeurons(i),'base','exp');
    [Yte] = simmotorneurons(Xte,numNeurons(i),'base','exp');
    [Vr,~] = computeV(Yte,3,M2);
    [Vout,Vflip,y,flipInd] = rotated_KLmin(Vr{1}(:,1:2),Xtr,180);
    warning off, Wls = (Yte\Xte); Xls = Yte*Wls;
    R2vals(1,i,j,nn) = evalR2(Vout,Xte);
    R2vals(2,i,j,nn) = evalR2(Xte,Yte*Wls);  
    display(['Neurons = ', int2str(numNeurons(i))])
    display(['DAD R2 = ', num2str(R2vals(1,i,j,nn),3)]),
    display(['LS R2 = ',num2str(R2vals(2,i,j,nn),3)])
    disp('~~~~~~~~~~~~~~~')
end
end
%save(['embeddings-synthetic-expt-full-8by4-',int2str(69+nn)]),
%Res = cell(length(numNeurons),length(numsamp));
end


figure,
plot(squeeze(median(R2vals(1,:,:,:),4)),'--'), hold on,
plot(squeeze(median(R2vals(2,:,:,:),4)),'-')

%subplot(1,3,1), colorData(Xte,Tte)
%subplot(1,3,2), colorData(Vr{1}(:,1:2),Tte)
%subplot(1,3,3), colorData(Vout,Tte)





