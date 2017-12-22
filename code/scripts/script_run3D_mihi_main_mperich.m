% Run DAD on Mihili data using different dim reduction methods (FA, PCA, Isomap)
% Compare DAD's performance with supervised and oracle decoders

%% Prepare firing rate data

removedir = [0,1,2,6];
opts.gridsz = 8;

Data = prepare_superviseddata(0.2,'chewie1','mihi',[],0);
[Xte,Yte,Tte,Xtr,Ytr,Ttr,Nte,Ntr] = removedirdata(Data,removedir);

%%
opts.dimred_method = 'FA';
[Xrec1,~,~,~,tmp] = runDAD3d(Xtr,Yte,opts);
R2valDAD(1) = evalR2(Xrec1,Xte); % Decoding error 
PcorrDAD(1) = evalTargetErr(Xrec1,Xte,Tte); % Percentage of correctly classified targets 
minKLDAD(1) = min(tmp(:));

%% Run DAD with PCA

opts.dimred_method = 'PCA';
[Xrec2,~,~,~,tmp] = runDAD3d(Xtr,Yte,opts);
R2valDAD(2) = evalR2(Xrec2,Xte);
PcorrDAD(2) = evalTargetErr(Xrec2,Xte,Tte);
minKLDAD(2) = min(tmp(:));

%% Run DAD with Isomap

opts.dimred_method = 'Isomap';
[Xrec3,~,~,~,tmp] = runDAD3d(Xtr,Yte,opts);
R2valDAD(3) = evalR2(Xrec3,Xte);
PcorrDAD(3) = evalTargetErr(Xrec3,Xte,Tte);
minKLDAD(3) = min(tmp(:));

%% Run supervised methods (run oracle and supervised linear decoder)

Xr = LSoracle(Xte,Yte);
R2Oracle = evalR2(Xr,Xte);  
PcorrOracle = evalTargetErr(Xr,Xte,Tte);
[~,~,tmp,~] = rotated_KLmin(Xr,Xtr,90);
minKLOracle = min(tmp(:));

%% Visualize results

figure,
subplot(1,6,1),
colorData(Xtr,Ttr), title('Training')
subplot(1,6,2),
colorData(Xte,Tte), title('Test')
subplot(1,6,3),
colorData(Xr,Tte), title(['Oracle (R2 = ', num2str(R2Oracle,2), ')'])
subplot(1,6,4),
colorData(Xrec1,Tte), title(['DAD-FA (R2 = ', num2str(R2valDAD(1),2), ')'])
subplot(1,6,5),
colorData(Xrec2,Tte), title(['DAD-PCA (R2 = ', num2str(R2valDAD(2),2), ')'])
subplot(1,6,6),
colorData(Xrec3,Tte), title(['DAD-Isomap (R2 = ', num2str(R2valDAD(3),2), ')'])

figure, 
bar([[R2Oracle, R2valDAD]; [PcorrOracle, PcorrDAD]; ...
    [minKLOracle, minKLDAD]]' )
