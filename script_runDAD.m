%% 1. Run DAD w/ factor analysis for dimensionality reduction
% opts.dimred_method = 'PCA'; % to apply PCA instead of FA

load mihi_demo
opts.gridsz = 8; % specifies the number of angles to search over when aligning prior and neural activities
opts.dimred_method = 'FA'; % use factor analysis to reduce the dimensionality
Xrec = runDAD3d(Xtr,Yte,opts);
R2valDAD = evalR2(Xrec,Xte); % compute the R2
disp('Finished running DAD...')

%% Compare with the Oracle linear decoder

[Xr,Hinv] = LSoracle(Xte,Yte);
R2valOracle = evalR2(Xr,Xte); % compute the R2

%%

figure,
subplot(1,4,1),
colorData(Xtr,Ttr), title('Training')
subplot(1,4,2),
colorData(Xte,Tte), title('Test')
subplot(1,4,3),
colorData(Xr,Tte), title(['Oracle (R2 = ', num2str(R2valOracle,2), ')'])
subplot(1,4,4),
colorData(Xrec,Tte), title(['DAD (R2 = ', num2str(R2valDAD,2), ')'])
