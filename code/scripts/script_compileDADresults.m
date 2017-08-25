% Model selection methods = 
% (1) minimum KL, (2) maxR2, (3) KLsmooth , (4) maxTargets

%% 0. parameters / input

%param_savename = 'optimal_parameters_chewie_optimize_D1'; % train D2, optimize D1
load(param_savename)
Results.whichtest = 1;

% input parameters
if isfield(Results,'whichtest')
    whichtest = Results.whichtest; % test model on this dataset (only 1 in this case)
else
    whichtest=1;
end

model1 = 2;
model2 = 3; 
model3 = 1;
numang_steps = 8; % CHANGE THIS. JUST TO TEST FOR NOW.

%% 1. Run DAD for selected model parameters (model 1, 2, 3)

if strcmp(Results.monkey,'chewie')||strcmp(Results.monkey,'jango')||strcmp(Results.monkey,'mihi2D')       
    ResultsM1 = apply_2Dmodelresults(Results,model1,param_savename);
    ResultsM2 = apply_2Dmodelresults(Results,model2,param_savename);
    ResultsM3 = apply_2Dmodelresults(Results,model3,param_savename);
elseif strcmp(Results.monkey,'mihi')
    ResultsM1 = apply_mihimodelresults(Results,model1,param_savename); % need to fix this function
    ResultsM2 = apply_mihimodelresults(Results,model2,param_savename); % need to fix this function
    ResultsM3 = apply_mihimodelresults(Results,model3,param_savename); % need to fix this function
end

%% 4. Compare with supervised methods (on Model 1 data)

ResultsSup = run_supmethods(ResultsM1.Yte{whichtest} ,ResultsM1.Xte{whichtest}(:,1:2),ResultsM1.Tte{whichtest});

%% 5. Evaluate error for all models

ResultsM1 = evalerror_from_results(ResultsM1,whichtest);
ResultsM2 = evalerror_from_results(ResultsM2,whichtest);
ResultsM3 = evalerror_from_results(ResultsM3,whichtest);

%% 6. Visualize results (Figure 4 in paper)

title1 = whichmodel_text(model1);
title2 = whichmodel_text(model2);
title3 = whichmodel_text(model3);
daytxt = ['(Day ',int2str(whichtest),')'];

if strcmp(Results.monkey,'chewie')
    daytxt2 = ['(Chewie, Day ',int2str(whichtest),')'];
elseif strcmp(Results.monkey,'jango')
    daytxt2 = ['(Jango, Day ',int2str(whichtest),')'];
elseif strcmp(Results.monkey,'mihi')
    daytxt2 = ['(Mihi, Day ',int2str(whichtest),')'];
elseif strcmp(Results.monkey,'mihi2D')
    daytxt2 = ['(Mihi2D, Day ',int2str(whichtest),')'];
end

minx=min(ResultsM2.Xte{whichtest}(:,1)); 
maxx=max(ResultsM2.Xte{whichtest}(:,1)); 
miny=min(ResultsM2.Xte{whichtest}(:,2)); 
maxy=max(ResultsM2.Xte{whichtest}(:,2)); 

figure,

subplot(3,15,[1:3,16:18,31:33])
colorData(ResultsM2.Xte{whichtest},ResultsM2.Tte{whichtest}), 
title(['Ground Truth ',daytxt2])
xlim([miny maxy]), ylim([miny maxy])

% bar plot with R2 and other metrics
Tmp=[[ResultsSup.R2Oracle, ResultsSup.MSEOracle, ResultsSup.Pcorr_vel_Oracle]; ...
    [ResultsSup.R2Sup, ResultsSup.MSESup, ResultsSup.Pcorr_vel_Sup];...
    [ResultsSup.R2KF, ResultsSup.MSEKF, ResultsSup.Pcorr_vel_KF];
    [ResultsM1.R2, ResultsM1.MSE, ResultsM1.Pcorr];...
    [ResultsM2.R2, ResultsM2.MSE, ResultsM2.Pcorr];...
    [ResultsM3.R2, ResultsM3.MSE, ResultsM3.Pcorr]];
MSEscaling = max(Tmp(:,2));
Tmp(:,2) = Tmp(:,2)./max(Tmp(:,2));
subplot(3,15,4:15)
bar(Tmp);
legend('R^2 Value',['Mean accuracy (max = ',num2str(MSEscaling,3),')'],'Target accuracy')
ylim([0 1.05])

subplot(3,15,[19:20,34:35])
colorData(ResultsSup.Xoracle,ResultsM1.Tte{whichtest}), 
title(['Oracle Solution ',daytxt])
xlim([miny maxy]), ylim([miny maxy])

subplot(3,15,[21:22,36:37])
colorData(ResultsSup.Xsup,ResultsM1.Tte{whichtest}), 
title(['Supervised Solution ',daytxt])
xlim([miny maxy]), ylim([miny maxy])

subplot(3,15,[23:24,38:39])
tmpid = find(norms(ResultsSup.Xkalman')<30);
colorData(ResultsSup.Xkalman(tmpid,:),ResultsM1.Tte{whichtest}(tmpid)),
title(['Kalman Filter Solution ',daytxt]), 
xlim([miny maxy]), ylim([miny maxy])

Res2 = rescale_mat(ResultsM1.Vout{whichtest}, ResultsM1.Xtr);
subplot(3,15,[25:26,40:41])
colorData(Res2,ResultsM1.Tte{whichtest}),
title([title1,' Solution ',daytxt])
xlim([miny maxy]), ylim([miny maxy])

Res2 = rescale_mat(ResultsM2.Vout{whichtest}, ResultsM2.Xtr);
subplot(3,15,[27:28,42:43])
colorData(Res2,ResultsM2.Tte{whichtest}),
title([title2,' Solution ',daytxt])
xlim([miny maxy]), ylim([miny maxy])

Res2 = rescale_mat(ResultsM3.Vout{whichtest}, ResultsM3.Xtr);
subplot(3,15,[29:30,44:45])
colorData(Res2,ResultsM3.Tte{whichtest}),
title([title3,' Solution ',daytxt])
xlim([miny maxy]), ylim([miny maxy])
