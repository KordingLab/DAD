%script_compare_results_across_subjects

% global parameters for DAD
opts.gridsz=10; 
opts.numT = 80; 
opts.check2D=0; 

%% MIHI
Ts = 0.2; % 200 ms bin size
removedir = [0,1,2,6]; % select targets (3,4,5,7,8)
Data = prepare_superviseddata(Ts,'chewie1','mihi',[],0);
[Xte,Yte,Tte,Xtr,~,~,Nte,Ntr] = removedirdata(Data,removedir);

% run DAD on mihi neural data
tstart = tic;
opts.dimred_method = 'FA'; 
[Xrec_mihi,Vflip_mihi,Vout_mihi,Vr_mihi,minKL_mihi,mean_resid_mihi] = ...
    runDAD3d(Xtr,Yte,opts);
telapsed_mihi = toc(tstart);

% compute errors
R2_mihi = evalR2(Xte,Xrec_mihi);
Pcorr_vel_mihi = evalTargetErr(Xrec_mihi,Xte(:,1:2),Tte);

% visualize
figure, 
subplot(1,2,1), 
colorData(Xte,Tte),
title('Ground truth - Mihi')
subplot(1,2,2), 
colorData(Xrec_mihi,Tte),

%% CHEWIE - 2D

load('~/Downloads/Chewie_CO_FF_2016-10-07.mat')
remove_dir = [0,4,6,7];
[~,~,T0,Pos0,Vel0,~,~,~] = compile_reaching_data(trial_data,20,30,'go',remove_dir); 

% script to run new data (chewie)
load('~/Downloads/Chewie_CO_FF_2016-10-11.mat')

numDfinal = 15;
numSfinal = 30;
drmethod_final = 'Isomap';
sfacfinal = 8;

[Y1,~,T1,Pos,Vel,~,~,~] = compile_reaching_data(trial_data,numDfinal,numSfinal,'go',remove_dir);
Y2= downsamp_nd(Y1,sfacfinal);

tstart = tic;
Mfinal{1} = drmethod_final; [V,Methods,~] = computeV(Y2, 3, Mfinal);
Vcurr = V{1}(:,1:2); [Xrec_chewie,Vflip, yKL, flipInd] = rotated_KLmin(Vcurr,Vel0,90);
telapsed_chewie = toc(tstart);

R2_chewie = evalR2(Xrec_chewie(1500:end,:),Vel(1500:end,:));  
Pcorr_vel_chewie = evalTargetErr(Xrec_chewie(1500:end,:),normal(Vel(1500:end,:)),T1(1500:end));
Pcorr_pos_chewie = evalTargetErr(Xrec_chewie(1500:end,:),normal(Pos(1500:end,:)),T1(1500:end));

figure, 
subplot(1,2,1), 
colorData(Xte,Tte),
title('Ground truth - Chewie')
subplot(1,2,2), 
colorData(Xrec_chewie,T1)


%% JANGO

whichtarg = [2,5,6,8]; % which targets to select reaches from
numD = [2,2,2,2];
numS = [4,4,4,4];

[Ytr,Ttr,Xtr] = compile_jango_neuraldata(whichtarg,numS,numD,'binnedData_0801.mat');
[Yte2,Tte2,Xte2] = compile_jango_neuraldata(whichtarg,numS,numD,'binnedData_0807.mat');
Yte2 = downsamp_nd(Yte2,2);
[Yte3,Tte3,Xte3] = compile_jango_neuraldata(whichtarg,numS,numD,'binnedData_0819.mat');
Yte3 = downsamp_nd(Yte3,2);

tstart = tic;
opts.dimred_method = 'PCA';
[Xrec2,Vflip2,Vout2] = runDAD3d(Xtr,Yte2,opts);
telapsed_jango2 = toc(tstart);
R2_jango2 = evalR2(Xte2(:,1:2),Xrec2);
Pcorr_jango2 = evalTargetErr(Xrec2,Xte2(:,1:2),Tte2);

tstart = tic;
opts.dimred_method = 'PCA';
[Xrec3,Vflip3,Vout3] = runDAD3d(Xtr,Yte3,opts);
telapsed_jango3 = toc(tstart);
R2_jango3 = evalR2(Xte3(:,1:2),Xrec3);
Pcorr_jango3 = evalTargetErr(Xrec3,Xte3(:,1:2),Tte3);

figure, 
subplot(1,3,1), 
colorData(Xtr,Ttr),
title('Training kinematics - Jango(1)')
subplot(1,3,2), 
colorData(Xrec2,Tte2),
title('DAD result - Jango(2)')
subplot(1,3,3), 
colorData(Xrec3,Tte3),
title('DAD result - Jango(3)')
