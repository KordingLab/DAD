function [R2Vals, PcorrVals, MSEVals] = run_supervisedmethods(Xtrain,Xtest,Ytrain,Ytest,Ttrain,Ttest)

%% run supervised methods (oracle, kalman, linear decoder)

% oracle decoder
Xr = LSoracle(Xtrain,Ytrain);
Xr2 = LSoracle(Xtest,Ytest);

% kalman filter
[A, C, Q, R] = train_kf(Xtrain,Ytrain);
[Xkf, ~, ~, ~] = kalman_filter(Ytrain', A, C, Q, R, zeros(2,1), eye(2));
[Xkf2, ~, ~, ~] = kalman_filter(Ytest', A, C, Q, R, zeros(2,1), eye(2));

% supervised linear decoder
[W, ~, ~, ~]= crossVaL(Ytrain, Xtrain, 500, 100);
Xsup = [Ytrain, ones(size(Ytrain,1),1)]*W;
Xsup2 = [Ytest, ones(size(Ytest,1),1)]*W;

%%
% evaluate error metrics (on train and test)
R2Vals = [ [evalR2(Xr,Xtrain), evalR2(Xr2,Xtest)], [evalR2(Xkf',Xtrain), evalR2(Xkf2',Xtest)], [evalR2(Xsup,Xtrain), evalR2(Xsup2,Xtest)] ];
PcorrVals = [ [evalTargetErr(Xr,normal(Xtrain),Ttrain), evalTargetErr(Xr2,normal(Xtest),Ttest)], [evalTargetErr(Xkf',normal(Xtrain),Ttrain), evalTargetErr(Xkf2',normal(Xtest),Ttest)], [evalTargetErr(Xsup,normal(Xtrain),Ttrain), evalTargetErr(Xsup2,normal(Xtest),Ttest)] ];
MSEVals = [ [evalMSE(Xr,Xtrain), evalMSE(Xr2,Xtest)], [evalMSE(Xkf',Xtrain), evalMSE(Xkf2',Xtest)], [evalMSE(Xsup,Xtrain), evalMSE(Xsup2,Xtest)] ];


end
