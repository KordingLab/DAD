% Create new Fig 5 - across-subject comparison (for M+C and C+M)

%% Mihi Neural Data

% Mihi testing data (neural)
removedir = [0,1,2,6];
load optimal_parameters_mihi
Data = prepare_superviseddata(binsz_maxR2,'chewie1','mihi',[],0);
[X_m1,Y_m1,T_m1,~,~,~,~,~] = removedirdata(Data,removedir);
Ymihi = downsamp_nd(Y_m1,sfac_maxR2);

%%
% Chewie kinematics (training)

load('~/Documents/repos/DAD/data/Chewie/Chewie_CO_FF_2016-10-11.mat')
load optimal_parameters_chewie_removedir_0126
[~,~,T_c1,~,X_c1,~,~,~] = compile_reaching_data(trial_data,20,30,'go',removedir); 

%%

% Mihi training kinematics
load('optimal_parameters_mihi_optimize_D1_1.mat')
opts.dimred_method = Results.drmethod_maxR2;
opts.gridsz = 10;
Results2 = apply_mihimodelresults(Results,2,'optimal_parameters_mihi_optimize_D1_1.mat'); 



[Xrec1,~,~,~,~] = runDAD3d(Params.Xtr,Results.Yte_maxR2,opts); 
R2val_mihi_modelopt = evalR2(X_m1,Xrec1);


%% Chewie Neural Data

%%%%% chewie neural data parameters

% 1. Prepare Chewie's neural Data
load optimal_parameters_chewie_removedir_0126
%removedir = [1,5,6,7];
numDfinal = numD_seqopt;
numSfinal = numS_seqopt;
drmethod_final = drmethod_seqopt;
sfacfinal = sfac_seqopt;
opts.dimred_method = drmethod_seqopt;
load('~/Documents/repos/DAD/data/Chewie/Chewie_CO_FF_2016-10-11.mat')
[Y_c2,~,T_c2,~,X_c2,~,~,~] = compile_reaching_data(trial_data,numDfinal,numSfinal,'go',removedir); 
Ychewie = downsamp_nd(Y_c2,sfacfinal);

%%
% 2. Prepare Mihi's training data
load optimal_parameters_mihi
Data = prepare_superviseddata(binsz_maxR2,'chewie1','mihi',[],0);
[X_m2,Y_m2,T_m2,~,~,~,N_m2,~] = removedirdata(Data,removedir);

%%
% 3. Run DAD 
opts.gridsz = 10;
opts.check2D = 1;
[Xrec2,Vflip,Vout,~,tmp] = runDAD3d(X_m2,Ychewie,opts); 
[Xrec3,~, yKL, flipInd] = rotated_KLmin(Xrec2,X_m2,180);

R2val_chewie_modelopt = evalR2(X_c2,Xrec2);

%%

% Plot performance (Chewie test, Mihi train)
figure, 
subplot(1,3,1),
colorData(X_m2,T_m2), title('Training (Mihi)')
subplot(1,3,2),
colorData(X_c2,T_c2), title('Test (Chewie)')
subplot(1,3,3),
colorData(Xrec2,T_c2), title('Alignment')


%%

% Plot performance (Mihi test, Chewie train)
figure, 
subplot(1,3,1),
colorData(X_c1,T_c1), title('Training (Chewie)')
subplot(1,3,2),
colorData(X_m1,T_m1), title('Test (Mihi)')
subplot(1,3,3),
colorData(Xrec1,T_m1), title('Alignment')

save results_script_runchewiemihi_optimal_modelselect_july_4_2017_2

