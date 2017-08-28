%%%%% script to test DAD for different hyperparameters and create Fig. 3E panel
% max R2 (25,35,Isomap,8) = 0.5516
% min KL (10,35,Isomap,8) = 0.4204
% smooth KL (15,30,Isomap,8) = 0.3941 (same params as sequential approach)
% Kalman Filter = 0.4909
% Supervised = 0.5399
% Oracle = 0.6186


load('~/Documents/GitHub/DAD/data/data/Chewie/Chewie_CO_FF_2016_10_07.mat')
remove_dir = [0,4,6,7];
[~,~,T0,Pos0,Vel0,~,~,~] = compile_reaching_data(trial_data,20,30,'go',remove_dir); 

% script to run new data (chewie)
load('~/Documents/GitHub/DAD/data/data/Chewie/Chewie_CO_FF_2016_10_11.mat')

% define hyper parameters
numDelays = [5, 10, 15, 20, 25];
numSamples = [10, 15, 20, 25, 30, 35, 40];

% fix smoothing factor and dim red method
SmoothingFac = [4, 6, 8];  %SmoothingFac = 8; % optimized through finding min-KL
clear M1
M1{1} = 'PCA'; 
M1{2} = 'Isomap';
M1{3} = 'FA';

numDR = length(M1);
numParams = length(numDelays)*length(numSamples)*length(SmoothingFac)*numDR;
numIter=1;

% search over hyperparameters
R2val = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR,numIter);
Pcorr_vel = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR,numIter);
Pcorr_pos = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR,numIter);
KLmin = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR,numIter);
KLmedian = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR,numIter);
Vout_all = cell(length(numDelays),length(numSamples),length(SmoothingFac),numDR,numIter);

count=0;
for iter=1:numIter
for k1=1:length(numDelays)
    numD=numDelays(k1);
    
    for k2=1:length(numSamples)
        numS=numSamples(k2);
        
        % found 300-500 ms was optimal for numD to minimize KL divergence (unsupervised)
        [Y1,~,T1,Pos,Vel,~,~,~] = compile_reaching_data(trial_data,numD,numS,'go',remove_dir);
        
        for i=1:length(SmoothingFac)
            sfac = SmoothingFac(i);
            [V,Methods,~] = computeV(downsamp_nd(Y1,sfac), 3,M1);
    
            for j=1:numDR
                Vcurr = V{j}(:,1:2);
                tic,
                [Vout,~, yKL, flipInd] = rotated_KLmin(Vcurr,Vel0,90);
                toc
                R2val(k1,k2,i,j,iter) = evalR2(Vel(:,1:2),Vout(:,1:2));
                Pcorr_vel(k1,k2,i,j,iter) = evalTargetErr(normal(Vout),normal(Vel),T1);
                Pcorr_pos(k1,k2,i,j,iter) = evalTargetErr(normal(Vout),normal(Pos),T1);
                KLmin(k1,k2,i,j,iter) = min(yKL);
                KLmedian(k1,k2,i,j,iter) = median(yKL(flipInd));
                Vout_all{k1,k2,i,j,iter}=Vout;
                display(['numD = ', int2str(numD),...
                         ', numS = ', int2str(numS), ...
                         ', winsz = ', int2str(sfac),...
                         ', Method = ', Methods{j},...
                         ', KL div = ', num2str(KLmin(k1,k2,i,j,iter),2), ...
                         ', R2 = ', num2str(R2val(k1,k2,i,j,iter),2), ...
                         ', Pcorr_vel = ', num2str(Pcorr_vel(k1,k2,i,j,iter),2), ...
                         ', Pcorr_pos = ', num2str(Pcorr_pos(k1,k2,i,j,iter),2)])
                count=count+1;
                display(['Number iterations left = ', int2str(numel(Pcorr_vel)-count)])
            end % end j
        end % end i
    end % end k2
end % end k1
end % end numIter



%% minKL - model selection - find model with smallest KL (min-KL)

tmp = KLmin;
[~,idd] = min(tmp(:));
[i1,i2,i3,i4] = ind2sub(size(tmp),idd);

numDhat = numDelays(i1);
numShat = numSamples(i2);
sfachat = SmoothingFac(i3);
drmethod_hat = M1(i4);
R2val_hat = R2val(i1,i2,i3,i4); % final R2 for best solution (min KL)

[Y1,~,T1,~,Vel,~,~,~] = compile_reaching_data(trial_data,numDhat,numShat,'go',remove_dir);
Y2= downsamp_nd(Y1,sfachat);
[V,~,~] = computeV(Y2, 3, drmethod_hat);
Vcurr = V{1}(:,1:2); 
[Vout,~, ~, ~] = rotated_KLmin(Vcurr,normal(Vel0),90);
Pcorrtarg_hat = evalTargetErr(Vout,normal(Vel),T1);

%%
figure, 
subplot(1,2,1), colorData(normal(Vel0),T0), title('Test Data (ground truth)')
subplot(1,2,2), colorData(Vout,T1), title(['Result from 2D-DAD (R2 = ',...
                                           num2str(evalR2(Vout,Vel),2)])
                               
                                       
%% Run DAD with sequential model selection method

numDfinal = 15;
numSfinal = 30;
drmethod_final = 'Isomap';
sfacfinal = 8;

[Y1,~,T1,Pos,Vel,~,~,~] = compile_reaching_data(trial_data,numDfinal,numSfinal,'go',remove_dir);

Y2= downsamp_nd(Y1,sfacfinal);
Mfinal{1} = drmethod_final; 
[V,Methods,~] = computeV(Y2, 3, Mfinal);
Vcurr = V{1}(:,1:2); 
[Vout,Vflip, yKL, flipInd] = rotated_KLmin(Vcurr,Vel0,90);

R2DAD = evalR2(Vout(1500:end,:),Vel(1500:end,:));  
Pcorr_vel_DAD = evalTargetErr(Vout(1500:end,:),normal(Vel(1500:end,:)),T1(1500:end));
Pcorr_pos_DAD = evalTargetErr(Vout(1500:end,:),normal(Pos(1500:end,:)),T1(1500:end));

%% Supervised methods

%%% oracle decoder
Xr = LSoracle(Vel,Y2);
R2Oracle = evalR2(Xr(1500:end,:),Vel(1500:end,:));  
Pcorr_vel_Oracle = evalTargetErr(Xr(1500:end,:),normal(Vel(1500:end,:)),T1(1500:end));
Pcorr_pos_Oracle = evalTargetErr(Xr(1500:end,:),normal(Pos(1500:end,:)),T1(1500:end));

% kalman filter
[A, C, Q, R] = train_kf(Vel(1:1200,:),Y2(1:1200,:));
[Xkf, ~, ~, ~] = kalman_filter(Y2(1500:end,:)', A, C, Q, R, zeros(2,1), eye(2));
R2KF = evalR2(Xkf',Vel(1500:end,:));  
Pcorr_vel_KF = evalTargetErr(Xkf',normal(Vel(1500:end,:)),T1(1500:end));
Pcorr_pos_KF = evalTargetErr(Xkf',normal(Pos(1500:end,:)),T1(1500:end));

% supervised linear decoder
[W, ~, ~, ~]= crossVaL(Y2(1:1200,:), Vel(1:1200,:), 500, 100);
Xsup = [Y2(1500:end,:), ones(size(Y2(1500:end,:),1),1)]*W;
R2Sup = evalR2(Xsup,Vel(1500:end,:)); 
Pcorr_vel_Sup = evalTargetErr(Xsup,Vel(1500:end,:),T1(1500:end));
Pcorr_pos_Sup = evalTargetErr(Xsup,Pos(1500:end,:),T1(1500:end));


%%
%%%% to create Fig. 3F in paper
figure,
subplot(4,5,[1,6]), colorData(Vel0,T0), axis tight
subplot(4,5,[11,16]), colorData(Vel,T1), axis tight
subplot(4,5,2), bar([R2Oracle,Pcorr_vel_Oracle,Pcorr_pos_Oracle]), ylim([0 0.72])
subplot(4,5,3), bar([R2DAD,Pcorr_vel_DAD,Pcorr_pos_DAD]), ylim([0 0.72])
subplot(4,5,4), bar([R2KF,Pcorr_vel_KF,Pcorr_pos_KF]), ylim([0 0.72])
subplot(4,5,5), bar([R2Sup,Pcorr_vel_Sup,Pcorr_pos_Sup]), ylim([0 0.72])

subplot(4,5,[7,12,17]), colorData(Xr(1500:end,:),T1(1500:end)), axis tight, title('Oracle')
subplot(4,5,[8,13,18]), colorData(Vout(1500:end,:),T1(1500:end)), axis tight, title('DAD')
subplot(4,5,[9,14,19]), colorData(normal(Xkf'),T1(1500:end)), axis tight, title('Kalman Filter')
subplot(4,5,[10,15,20]), colorData(normal(Xsup),T1(1500:end)), axis tight, title('Supervised')

%% Smoothed Model Estimate

%%%% smoothed KL divergence
Vals = smooth(KLmin(:));
[~,id] = min(Vals);
tmp1=id-2:id+2; 
[~,idd] = min(KLmin(tmp1)); 
minID = tmp1(idd);

[i1,i2,i3,i4] = ind2sub(size(R2val),minID);
numD_smooth = numDelays(i1);
numS_smooth = numSamples(i2);
sfac_smooth = SmoothingFac(i3);
drmethod_smooth = M1(i4);
R2val_smooth = R2val(i1,i2,i3,i4); % final R2 for best solution (min KL)


%% Max R2

[~,idd] = max(R2val(:));
[i1,i2,i3,i4] = ind2sub(size(R2val),idd);
numD_maxR2 = numDelays(i1);
numS_maxR2 = numSamples(i2);
sfac_maxR2 = SmoothingFac(i3);
drmethod_maxR2 = M1(i4);
R2val_maxR2 = R2val(i1,i2,i3,i4); % final R2 for best solution (min KL)



%% create box plots in Fig 3

% look at spread as function of DR method
figure,
tmp = KLmin(:,:,:,1,:);
tmp2 = KLmin(:,:,:,2,:);
tmp3 = KLmin(:,:,:,3,:);
subplot(1,3,1), boxplot([tmp2(:),tmp(:),tmp3(:)])

% look at spread as fn of smoothing kernel width
tmp = KLmin(:,:,1,:,:);
tmp2 = KLmin(:,:,2,:,:);
tmp3 = KLmin(:,:,3,:,:);
subplot(1,3,2), boxplot([tmp3(:),tmp2(:),tmp(:)])

tmp_total=[];
for i=7:-1:1
    tmp = KLmin(:,i,:,:,:);
    tmp_total = [tmp_total,tmp(:)];
end
subplot(1,3,3), boxplot(tmp_total)









