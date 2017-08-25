% create Jango figure - use model selection and run on Day 2
% for now, we are testing on day 2 - "train" on day 1 
% Model selection methods = (1) minimum KL, (2) maxR2, (3) KLsmooth , (4) maxTargets

%% 0. parameters / input

%param_savename = 'optimal_parameters_chewie_optimize_D2'; % train D2, optimize D1
whichtest = 1; % test mdel on this dataset
model1 = 4; % min KL
model2 = 2; % maximum R2
load(param_savename)

if model1==1
    title1 = 'minKL ';
elseif model1==2
    title1 = 'maxR2 ';
elseif model1==3
    title1 = 'SmoothKL ';
elseif model1==4
    title1 = 'maxTarg ';
end

if model2==1
    title2 = 'minKL ';
elseif model2==2
    title2 = 'maxR2 ';
elseif model2==3
    title2 = 'SmoothKL ';
elseif model2==4
    title2 = 'maxTarg ';
end
daytxt = ['(Day ',int2str(whichtest),')'];

%% 1. Apply first model

ResultsM1 = apply_2Dmodelresults(Results,model1,param_savename);

%% 2. Apply next model

ResultsM2 = apply_2Dmodelresults(Results,model2,param_savename);

%% 2. Apply next model

ResultsM3 = apply_2Dmodelresults(Results,model3,param_savename);

%% 3. Compare with supervised methods

ResultsSup = run_supmethods(ResultsM2.Yte{whichtest},ResultsM2.Xte{whichtest}(:,1:2),ResultsM2.Tte{whichtest});

%% 4. Evaluate error
ResultsM1 = evalerror_from_results(ResultsM1,whichtest);
ResultsM2 = evalerror_from_results(ResultsM2,whichtest);
ResultsM3 = evalerror_from_results(ResultsM3,whichtest);

%% 5. Visualize

figure,

subplot(3,8,[2:3,10:11,18:19])
colorData(ResultsM2.Xte{whichtest},ResultsM2.Tte{whichtest}), axis normal
title(['Ground Truth ',daytxt])

subplot(3,8,4:8)
bar([[ResultsSup.R2Oracle, 1- ResultsSup.MSEOracle, ResultsSup.Pcorr_vel_Oracle]; ...
    [ResultsSup.R2Sup, 1- ResultsSup.MSESup, ResultsSup.Pcorr_vel_Sup];...
    [ResultsSup.R2KF, 1- ResultsSup.MSEKF, ResultsSup.Pcorr_vel_KF];
    [ResultsM2.R2, 1 - ResultsM2.MSE, ResultsM2.Pcorr];...
    [ResultsM1.R2, 1 - ResultsM1.MSE, ResultsM1.Pcorr]]);
legend('R^2 Value','Decoding accuracy','Target accuracy')
ylim([0 0.9])

subplot(3,8,[12,20])
colorData(ResultsSup.Xoracle,ResultsM2.Tte{whichtest}), axis normal
title(['Oracle Solution ',daytxt])

subplot(3,8,[13,21])
colorData(ResultsSup.Xsup,ResultsM2.Tte{whichtest}), axis normal
title(['Supervised Solution ',daytxt])

subplot(3,8,[14,22])
colorData(ResultsSup.Xkalman,ResultsM2.Tte{whichtest}), axis normal
title(['Kalman Filter Solution ',daytxt])

subplot(3,8,[15,23])
colorData(ResultsM2.Vout{whichtest},ResultsM2.Tte{whichtest}), axis normal
title([title2,' Solution ',daytxt])

subplot(3,8,[16,24])
colorData(ResultsM1.Vout{whichtest},ResultsM1.Tte{whichtest}), axis normal
title([title1,' Solution ',daytxt])
