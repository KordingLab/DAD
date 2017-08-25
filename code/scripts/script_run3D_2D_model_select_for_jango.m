% model selection for Jango's data

filename = '~/Documents/repos/DAD/data/Jango/binnedData_0807.mat';
filename0 = '~/Documents/repos/DAD/data/Jango/binnedData_0801.mat';

keep_targets = [1, 2, 3, 6]; % which targets to select reaches from
numDelays = [1,2,3,4];
numSamples = [4,5,6,7,8,9,10];
SmoothingFac = [2,4,6];
clear M1,
M1{1} = 'PCA'; 
M1{2} = 'FA';
M1{3} = 'Isomap';
numDR = length(M1);
numParams = length(numDelays)*length(numSamples)*length(SmoothingFac)*numDR;
numIter=1;

% 3D model parameters
k = 3; % run in 3D (k=3), or 2D (k=2)
gridszA = 7; % gridsz^3 angles to search over in 3D
numT = 0; % number of translations to search over for each angle
check2D = 1; % compare 2D and 3D in terms of min KL

% training dataset (selected manually to ensure we dont have too many samples at origin)
numS0 = 2; numD0 = 4; 
[~,T0,Vel0] = compile_jango_neuraldata(keep_targets,numS0,numD0,filename0);

% search over hyperparameters
R2val = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR,numIter);
Pcorr_vel = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR,numIter);
MSEval = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR,numIter);
KLmin = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR,numIter);
KLmedian = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR,numIter);
Xrec_all = cell(length(numDelays),length(numSamples),length(SmoothingFac),numDR,numIter);

count=0;
for iter=1:numIter
for k1=1:length(numDelays)
    numD=numDelays(k1);
    
    for k2=1:length(numSamples)
        numS=numSamples(k2);
        
        % found 300-500 ms was optimal for numD to minimize KL divergence (unsupervised)
        [Y1,T1,Vel] = compile_jango_neuraldata(keep_targets,numS,numD,filename);
        
        for i=1:length(SmoothingFac)
            sfac = SmoothingFac(i);
            [V,Methods,~] = computeV(downsamp_nd(Y1,sfac), 3, M1);
    
            for j=1:numDR
               Vcurr = V{j}(:,1:k);
               
                if k==2
                     [Vout,~, yKL, flipInd] = rotated_KLmin(Vcurr,Vel0(:,1:k),90);
                     KLmin(k1,k2,i,j,iter) = min(yKL);
                     KLmedian(k1,k2,i,j,iter) = median(yKL(flipInd));
                elseif k==3
                     tic, [Vout,~,~,yKL] = DAD_3Dsearch(Vel0(:,1:k),Vcurr,gridszA,numT,check2D); toc
                     KLmin(k1,k2,i,j,iter) = min(yKL);
                     KLmedian(k1,k2,i,j,iter) = median(yKL);
                end
                
                R2val(k1,k2,i,j,iter) = evalR2(Vel(:,1:2),normal(Vout));
                MSEval(k1,k2,i,j,iter) = sum(sum((normal(Vel(:,1:2)) - normal(Vout(:,1:2))).^2))./numel(Vel(:,1:2));
                Pcorr_vel(k1,k2,i,j,iter) = evalCorrectTargets(normal(Vout),normal(Vel(:,1:2)),T1);
                Xrec_all{k1,k2,i,j,iter} = Vout;
                display(['numD = ', int2str(numD),...
                         ', numS = ', int2str(numS), ...
                         ', winsz = ', int2str(sfac),...
                         ', Method = ', Methods{j},...
                         ', KL div = ', num2str(KLmin(k1,k2,i,j,iter),2), ...
                         ', R2 = ', num2str(R2val(k1,k2,i,j,iter),2), ...
                         ', MSE = ', num2str(MSEval(k1,k2,i,j,iter),2), ...
                         ', Pcorr_vel = ', num2str(Pcorr_vel(k1,k2,i,j,iter),2)])
                     count=count+1;
                     display(['Number of Parameters Remaining = ', int2str(numel(KLmin)-count)])
            end % end j
        end % end i
    end % end k2
end % end k1
end % end numIter

%% Model Selection Step %%
%%%% 
% Model selection
% 1. Dimensionality reduction (4)
% 2. Smoothing Factor (3)
% 3. Num samples (2)
% 4. Num delays (1)

clear tmp,
for i=1:size(KLmin,4)
    tmp1=KLmin(:,:,:,i);
    tmp(i)=median(tmp1(:));
end
[~,idd1] = min(tmp);    
drmethod_KLmin = M1{idd1};

clear tmp,
for i=1:size(KLmin,3)
    tmp1=KLmin(:,:,i,idd1);
    tmp(i)=median(tmp1(:));
end
[~,idd2] = min(tmp);    
SmoothingFac_KLmin = SmoothingFac(idd2);

clear tmp,
for i=1:size(KLmin,2)
    tmp1=KLmin(:,:,idd2,idd1);
    tmp(i)=median(tmp1(:));
end
[~,idd3] = min(tmp);    
numSamples_KLmin = numSamples(idd3);

tmp1=KLmin(:,idd3,idd2,idd1);
[~,idd4] = min(tmp1);    
numDelays_KLmin = numDelays(idd4);

R2val_hat = R2val(idd4,idd3,idd2,idd1); % final R2 for best solution (min KL)

%% Apply final model selection parameters 

[Y1,T1,Vel] = compile_jango_neuraldata(keep_targets,numSamples_KLmin,numDelays_KLmin,filename);
Y2 = downsamp_nd(Y1,SmoothingFac_KLmin);
Mtmp{1}=drmethod_KLmin;
[V,Methods,~] = computeV(Y2, k, Mtmp);
Vcurr = V{1}(:,1:k); 
[Vout,~,~,yKL] = DAD_3Dsearch(Vel0,Vcurr,10,0,check2D); % run higher-res search

% compute errors
R2DAD = evalR2(Vout,Vel(:,1:size(Vout,2)));  
Pcorr_vel_DAD = evalCorrectTargets(Vout,normal(Vel(:,1:size(Vout,2))),T1);






% supervised linear decoder
% [W, ~, ~, ~]= crossVaL(Y2(1:1200,:), Vel(1:1200,1:2), 500, 100);
% Xsup = [Y2(1500:end,:), ones(size(Y2(1500:end,:),1),1)]*W;
% R2Sup = evalR2(Xsup,Vel(1500:end,1:k)); 
% Pcorr_vel_Sup = evalCorrectTargets(Xsup,Vel(1500:end,1:k),T1(1500:end));
% 
% 
% %%%%%%% Compare R2 and Target Errs
% figure,
% subplot(4,5,[1,6]), colorData(Vel0,T0), axis tight
% subplot(4,5,[11,16]), colorData(Vel,T1), axis tight
% subplot(4,5,2), bar([R2Oracle,Pcorr_vel_Oracle]), ylim([0 0.72])
% subplot(4,5,3), bar([R2DAD,Pcorr_vel_DAD]), ylim([0 0.72])
% subplot(4,5,4), bar([R2KF,Pcorr_vel_KF]), ylim([0 0.72])
% subplot(4,5,5), bar([R2Sup,Pcorr_vel_Sup]), ylim([0 0.72])
% 
% subplot(4,5,[7,12,17]), colorData(Xr(1500:end,1:k),T1(1500:end)), axis tight, title('Oracle')
% subplot(4,5,[8,13,18]), colorData(Vout(1500:end,1:k),T1(1500:end)), axis tight, title('DAD')
% subplot(4,5,[9,14,19]), colorData(normal(Xkf'),T1(1500:end)), axis tight, title('Kalman Filter')
% subplot(4,5,[10,15,20]), colorData(normal(Xsup),T1(1500:end)), axis tight, title('Supervised')
% 

