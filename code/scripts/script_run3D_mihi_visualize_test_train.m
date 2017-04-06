% script to run 3D KL on Mihi Data

%%%% script to run 3D alignment (run DAD on real datasets)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1. Setup experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%setuppath
%numA = 90; %every 2 deg
Ts=.20;
percent_test = 1;
% numsteps=length(percent_test);
% randseed = randi(100,1);
% rng(randseed)
removedir = [0, 1, 2];
% Ntot = 1027;
% numIter = 20;
M1{1} = 'FA'; % dont need dr toolbox for factor analysis 

% parameters for DAD
% opts.gridsz = 3;
% opts.method = 'KL';
% opts.nzvar=0;
% opts.rfac=0;

%%%%% user input
percent_samp = input('Amount to train on (scalar between 0,1): ');
supmethod = input('Enter 1 if you want to run the supervised method: '); 

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2. Prepare training and test datasets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute firing rates and remove directions 
Data0 = prepare_superviseddata(Ts,'chewie1','mihi',[]);
Data = prepare_superviseddata(Ts,'mihi','mihi',[],0);
[~,~,~,XtrC0,YtrC0,TtrC0,~,NtrC0] = removedirdata(Data0,removedir);
[~,~,~,Xtrain,Ytrain,Ttrain,~,Ntrain] = removedirdata(Data,removedir);
%clear Data Data0

[XtrC,YtrC,TtrC,XteC,YteC,TteC,trainidC,testidC] = splitdataset(XtrC0,YtrC0,TtrC0,NtrC0,percent_samp); 
[Xtr,Ytr,Ttr,Xte,Yte,Tte,trainid,testid] = splitdataset(Xtrain,Ytrain,Ttrain,Ntrain,percent_samp); 
  
% run 3D DAD
[Xrec_chewie,Vflip_chewie,Vr_chewie,minKL_chewie] = runDAD3d(normal(mapX3D(Xtr)),Yte,[]);

%[Vout,Vflip, yKL, flipInd] = rotated_KLmin(Xte,Xtr,90);

% Figure (3) - Visualization of 2D Rotation Aligment
figure; 
subplot(1,6,1); colorData(Xte,Tte); title('Ground truth'), 

for i=1:5
   R2 = evalR2(Xte,Xrec_chewie{i});
   subplot(1,6,1+i), colorData(Xrec_chewie{i},Tte); 
   title(['R2 =', num2str(R2)]), 
end

subplot(2,6,7:12),
plot(yKL(1:end-15),'LineWidth',3)
axis tight
