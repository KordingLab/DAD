%%%%% script to test DAD for different hyperparameters and create Fig. 3E panel
% max R2 (25,35,Isomap,8) = 0.5516
% min KL (10,35,Isomap,8) = 0.4204
% smooth KL (15,30,Isomap,8) = 0.3941 (same params as sequential approach)
% Kalman Filter = 0.4909
% Supervised = 0.5399
% Oracle = 0.6186

numIter = 1; % only one iteration for now
psamp = 0.2:0.2:0.8; % amount of data used for training

% load chewie train (movements) and testing datasets
load('~/Documents/GitHub/DAD/data/data/Chewie/Chewie_CO_FF_2016_10_07.mat')
remove_dir = [0,4,6,7];
[~,~,T0,Pos0,Vel0,~,~,~] = compile_reaching_data(trial_data,20,30,'go',remove_dir); 
load('~/Documents/GitHub/DAD/data/data/Chewie/Chewie_CO_FF_2016_10_11.mat')

% define hyper parameters based upon maxR2 parameters
numD = 25;
numS = 35;
sFac = 8;  %SmoothingFac = 8; % optimized through finding min-KL
clear M1
M1{1} = 'Isomap';

% compile data
[Y1,~,T1,Pos,Vel,~,~,~] = compile_reaching_data(trial_data,numD,numS,'go',remove_dir);

count=1;
for i=1:length(psamp)
    num1 = round(psamp(i)*length(T1));
    tmp = find(diff(T1));
    [~,idd] = min(abs(tmp - ones(length(tmp),1)*num1 ));
    whichID = tmp(idd);
    
    % split dataset into train and test
    Y_train = downsamp_nd(Y1(1:whichID,:),sFac);
    Y_test = downsamp_nd(Y1(whichID+1:end,:),sFac);
    
    % run DAD
    [V,~,~] = computeV(Y_train, 3, M1);
    Vcurr = V{1}(:,1:2);
    [Vout,~, yKL, ~] = rotated_KLmin(Vcurr,Vel0,90);
    
    % oracle decoder
    Xr = LSoracle(Vel(1:whichID,1:2),Y_train);

    % kalman filter
    [A, C, Q, R] = train_kf(Vel(1:whichID,:),Y_train);

    % supervised linear decoder
    [W, ~, ~, ~]= crossVaL(Y_train, Vel(1:whichID,:), 500, 100);

    % evaluate oracle errors (train/test on train)
    R2_Oracle(i,count) = evalR2(Xr,Vel(1:whichID,:));  
    Pcorr_Oracle(i,count) = evalTargetErr(Xr,normal(Vel(1:whichID,:)),T1(1:whichID));
    MSE_Oracle(i,count) = evalMSE(Xr,normal(Vel(1:whichID,:)));
    
     % evaluate KF errors (train / test)
    [Xkf, ~, ~, ~] = kalman_filter(Y_test', A, C, Q, R, zeros(2,1), eye(2));
    R2_KF(i,count) = evalR2(Xkf',Vel(whichID+1:end,:));  
    Pcorr_KF(i,count) = evalTargetErr(Xkf',normal(Vel(whichID+1:end,:)),T1(whichID+1:end));
    MSE_KF(i,count) = evalMSE(Xkf,normal(Vel(whichID+1:end,:)));

    % supervised
    Xsup = [Y_test, ones(size(Y_test,1),1)]*W;
    R2_Sup(i,count) = evalR2(Xsup,Vel(whichID+1:end,:)); 
    Pcorr_Sup(i,count) = evalTargetErr(Xsup,Vel(whichID+1:end,:),T1(whichID+1:end));
    MSE_Sup(i,count) = evalMSE(Xsup,Vel(whichID+1:end,:));

    % DAD
    [~,Hinv] = LSoracle(Vout,Y_train);
    Xr_DAD = (Hinv*Y_test')'; 
    
    R2_DAD(i,count) = evalR2(Vel(1:whichID,1:2),Vout(:,1:2));
    Pcorr_DAD(i,count) = evalTargetErr(normal(Vout),normal(Vel(1:whichID,1:2)),T1(1:whichID));
    KLmin_DAD(i,count) = min(yKL);     
end % 



%%
%%%% to create Fig. 3F in paper
% figure,
% subplot(4,5,[1,6]), colorData(Vel0,T0), axis tight
% subplot(4,5,[11,16]), colorData(Vel,T1), axis tight
% subplot(4,5,2), bar([R2Oracle,Pcorr_vel_Oracle,Pcorr_pos_Oracle]), ylim([0 0.72])
% subplot(4,5,3), bar([R2DAD,Pcorr_vel_DAD,Pcorr_pos_DAD]), ylim([0 0.72])
% subplot(4,5,4), bar([R2KF,Pcorr_vel_KF,Pcorr_pos_KF]), ylim([0 0.72])
% subplot(4,5,5), bar([R2Sup,Pcorr_vel_Sup,Pcorr_pos_Sup]), ylim([0 0.72])
% 
% subplot(4,5,[7,12,17]), colorData(Xr(1500:end,:),T1(1500:end)), axis tight, title('Oracle')
% subplot(4,5,[8,13,18]), colorData(Vout(1500:end,:),T1(1500:end)), axis tight, title('DAD')
% subplot(4,5,[9,14,19]), colorData(normal(Xkf'),T1(1500:end)), axis tight, title('Kalman Filter')
% subplot(4,5,[10,15,20]), colorData(normal(Xsup),T1(1500:end)), axis tight, title('Supervised')
