% Create Jango figure - across days - model selection
% Models:  minimum KL (1), maxR2 (2), KLsmooth (3), maxTargets (4) 

whichtrain = 1; model_select =1; 
load('optimal_parameters_jango_optimize_D1.mat')
Results.monkey='jango';
Results = apply_2Dmodelselect(Results,model_select);


R2vals_DAD(1,1) = evalR2(Vout1,Xte1(:,1:2));
R2vals_DAD(1,2) = evalR2(Vout2,Xte2(:,1:2));
R2vals_DAD(1,3) = evalR2(Vout3,Xte3(:,1:2));
R2vals_DAD(1,4) = evalR2(Vout4,Xte4(:,1:2));

figure (10),
subplot(3,4,1)
colorData(Xte1,Tte1)
title('Ground truth (D1)')

subplot(3,4,2)
colorData(Xte2,Tte2)
title('Ground truth (D2)')

subplot(3,4,3)
colorData(Xte3,Tte3)
title('Ground truth (D3)')

subplot(3,4,4)
colorData(Xte4,Tte4)
title('Ground truth (D4)')

subplot(3,4,5)
colorData(Vout1,Tte1)
title(['SmoothKL (D1), R2 = ',num2str(R2vals_DAD(1,1),2)])

subplot(3,4,6), colorData(Vout2,Tte2), 
title(['SmoothKL (D2), R2 = ',num2str(R2vals_DAD(1,2),2)])

subplot(3,4,7), colorData(Vout3,Tte3), 
title(['SmoothKL (D3), R2 = ',num2str(R2vals_DAD(1,3),2)])

subplot(3,4,8), colorData(Vout4,Tte4), 
title(['SmoothKL (D4), R2 = ',num2str(R2vals_DAD(1,4),2)])

Vout1_smooth = Vout1;
Vout2_smooth = Vout2;
Vout3_smooth = Vout3;
Vout4_smooth = Vout4;

%% next model

model_select=2; % maximum R2
script_run2D_jango_applymodelselection

R2vals_DAD(2,1) = evalR2(Vout1,Xte1(:,1:2));
R2vals_DAD(2,2) = evalR2(Vout2,Xte2(:,1:2));
R2vals_DAD(2,3) = evalR2(Vout3,Xte3(:,1:2));
R2vals_DAD(2,4) = evalR2(Vout4,Xte4(:,1:2));

subplot(3,4,9), colorData(Vout1,Tte1)
title(['maxR2 (D1), R2 = ',num2str(R2vals_DAD(2,1),2)])
subplot(3,4,10), colorData(Vout2,Tte2), 
title(['maxR2 (D2), R2 = ',num2str(R2vals_DAD(2,2),2)])
subplot(3,4,11), colorData(Vout3,Tte3), 
title(['maxR2 (D3), R2 = ',num2str(R2vals_DAD(2,3),2)])
subplot(3,4,12), colorData(Vout3,Tte3), 
title(['maxR2 (D4), R2 = ',num2str(R2vals_DAD(2,4),2)])


%%
% now compare with supervised methods
Results = run_supmethods(Yte2,Xte2(:,1:2),Tte2);

%%
%Results.Vout1_max = Vout1;
Results.Vout2_max = Vout2;
%Results.Vout3_max = Vout3;
%Results.Vout4_max = Vout4;

%Results.Vout1_smooth = Vout1_smooth;
Results.Vout2_smooth = Vout2_smooth;
%Results.Vout3_smooth = Vout3_smooth;
%Results.Vout4_smooth = Vout4_smooth;

Results.R2DAD_maxR2 = evalR2(Vout2_max(Results.testid,:),Xte2(Results.testid,1:2));
Results.MSEDAD_maxR2 = evalMSE(Vout2_max(Results.testid,:),Xte2(Results.testid,1:2));
Results.Pcorr_vel_DAD_maxR2 = evalCorrectTargets(Vout2_max(Results.testid,:),Xte2(Results.testid,1:2),Tte2(Results.testid));

Results.R2DAD_smooth = evalR2(Vout2_smooth(Results.testid,:),Xte2(Results.testid,1:2));
Results.MSEDAD_smooth = evalMSE(Vout2_smooth(Results.testid,:),Xte2(Results.testid,1:2));
Results.Pcorr_vel_DAD_smooth = evalCorrectTargets(Vout2_smooth(Results.testid,:),Xte2(Results.testid,1:2),Tte2(Results.testid));

%%
% jango plot (Fig 4)
figure,
colorData(Xte2,Tte2)
title('Ground Truth (D2)')

%%
figure,

subplot(3,5,1:5)
bar([[Results.R2Oracle, 1- Results.MSEOracle, Results.Pcorr_vel_Oracle]; ...
    [Results.R2Sup, 1- Results.MSESup, Results.Pcorr_vel_Sup];...
    [Results.R2KF, 1- Results.MSEKF, Results.Pcorr_vel_KF];
    [Results.R2DAD_maxR2, 1 - Results.MSEDAD_maxR2, Results.Pcorr_vel_DAD_maxR2];...
    [Results.R2DAD_smooth, 1 - Results.MSEDAD_smooth, Results.Pcorr_vel_DAD_smooth]]);
legend('R^2 Value','Decoding accuracy','Target accuracy')

subplot(3,5,[6,11])
colorData(Results.Xoracle,Tte2)
title('Oracle Solution (D2)')

subplot(3,5,[7,12])
colorData(Results.Xsup,Tte2)
title('Supervised Solution (D2)')

subplot(3,5,[8,13])
colorData(Results.Xkalman,Tte2)
title('Kalman Filter Solution (D2)')

subplot(3,5,[9,14])
colorData(Results.Vout2_max,Tte2)
title('MaxR2 Solution (D2)')

subplot(3,5,[10,15])
colorData(Results.Vout2_smooth,Tte2)
title('SmoothKL Solution (D2)')

    
