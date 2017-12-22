%% Prepare dataset

% parameters to use for Chewie's data
numDfinal = 15;
numSfinal = 30;
drmethod_final = 'Isomap';
sfacfinal = 8;
remove_dir = [0,4,6,7];
load chewie_demo

%% Run DAD

% To run DAD in 3D
%opts.check2D = 1;
%opts.gridsz = 8; % specifies the number of angles to search over when aligning prior and neural activities
%opts.dimred_method = drmethod_final; % use factor analysis to reduce the dimensionality
%Xrec = runDAD3d(Vel0,Y2,opts);

[Vout, yKL] = runDAD2d(Yte,Xtr,drmethod_final);
R2DAD = evalR2(Vout,Xte);  
Pcorr_vel_DAD = evalTargetErr(Vout,normal(Xte),Tte);

% oracle
Xr = LSoracle(Xte,Yte);
R2Oracle = evalR2(Xr,Xte);  
Pcorr_vel_Oracle = evalTargetErr(Xr,Xte,Tte);

% kalman filter
[A, C, Q, R] = train_kf(Xtr,Ytr);
[Xkf, ~, ~, ~] = kalman_filter(Yte', A, C, Q, R, zeros(2,1), eye(2));
R2KF = evalR2(Xkf',Xte);  
Pcorr_vel_KF = evalTargetErr(Xkf',Xte,Tte);

% supervised linear decoder
[W, ~, ~, ~]= crossVaL(Ytr, Xtr, 500, 100);
Xsup = [Yte, ones(size(Yte,1),1)]*W;
R2Sup = evalR2(Xsup,Xte); 
Pcorr_vel_Sup = evalTargetErr(Xsup,Xte,Tte);

%% Visualize results

figure,
subplot(4,5,[1,6]), colorData(Xtr,Ttr),  ylim([-25 25]),  xlim([-25 25]), title('Training set')
subplot(4,5,[11,16]), colorData(Xte,Tte),  ylim([-25 25]),  xlim([-25 25]), title('Testing set')
subplot(4,5,2), bar([R2Oracle,Pcorr_vel_Oracle]), ylim([0 0.72]), title('(L) R2 and (R) Target accuracy')
subplot(4,5,3), bar([R2DAD,Pcorr_vel_DAD]), ylim([0 0.72]), title('(L) R2 and (R) Target accuracy')
subplot(4,5,4), bar([R2KF,Pcorr_vel_KF]), ylim([0 0.72]), title('(L) R2 and (R) Target accuracy')
subplot(4,5,5), bar([R2Sup,Pcorr_vel_Sup]), ylim([0 0.72]), title('(L) R2 and (R) Target accuracy')

subplot(4,5,[7,12,17]), colorData(Xr,Tte), axis tight, title('Oracle')
subplot(4,5,[8,13,18]), colorData(Vout,Tte), axis tight, title('DAD')
subplot(4,5,[9,14,19]), colorData(normal(Xkf'),Tte), axis tight, title('Kalman Filter')
subplot(4,5,[10,15,20]), colorData(normal(Xsup),Tte), axis tight, title('Supervised')
