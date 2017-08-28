%script_run3D_DAD_Mihi

removedir = [0,1,2,6];
Data = prepare_superviseddata(0.22,'chewie1','mihi',[],0);
[Xte,Yte,Tte,Xtr,Ytr,Ttr,Nte,Ntr] = removedirdata(Data,removedir);
Yte2 = downsamp_nd(Yte,0);

%%
opts.dimred_method = 'FA';
[Xrec1,~,~,~,tmp] = runDAD3d(Xtr,Yte,opts);
R2valDAD(1) = evalR2(Xrec1,Xte);
PcorrDAD(1) = evalTargetErr(Xrec1,Xte,Tte);
minKLDAD(1) = min(tmp(:));

%%
opts.dimred_method = 'PCA';
[Xrec2,~,~,~,tmp] = runDAD3d(Xtr,Yte,opts);
R2valDAD(2) = evalR2(Xrec2,Xte);
PcorrDAD(2) = evalTargetErr(Xrec2,Xte,Tte);
minKLDAD(2) = min(tmp(:));

%%
opts.dimred_method = 'Isomap';
[Xrec3,~,~,~,tmp] = runDAD3d(Xtr,Yte,opts);
R2valDAD(3) = evalR2(Xrec3,Xte);
PcorrDAD(3) = evalTargetErr(Xrec3,Xte,Tte);
minKLDAD(3) = min(tmp(:));

%%
%%%% Supervised methods (run oracle and kalman filter)
Xr = LSoracle(Xte,Yte);
R2Oracle = evalR2(Xr,Xte);  
PcorrOracle = evalTargetErr(Xr,Xte,Tte);

[~,~,tmp,~] = rotated_KLmin(Xr,Xtr,90);
minKLOracle = min(tmp(:));

[W, Xsup, R2Max, lamc]= crossVaL(Yte, Xte, 500, 100);
R2Sup = evalR2(Xsup,Xte); 
PcorrSup = evalTargetErr(Xsup,Xte,Tte);

[~,~,tmp,~] = rotated_KLmin(Xsup,Xtr,90);
minKLSup = min(tmp(:));


%%

figure,
subplot(1,6,1),
colorData(Xtr,Ttr), title('Training')
subplot(1,6,2),
colorData(Xte,Tte), title('Test')
subplot(1,6,3),
colorData(Xsup,Tte), title(['Supervised (R2 = ', num2str(R2Sup,2), ')'])
subplot(1,6,4),
colorData(Xrec1,Tte), title(['DAD (R2 = ', num2str(R2valDAD(1),2), ')'])
subplot(1,6,5),
colorData(Xrec2,Tte), title(['DAD (R2 = ', num2str(R2valDAD(2),2), ')'])
subplot(1,6,6),
colorData(Xrec3,Tte), title(['DAD (R2 = ', num2str(R2valDAD(3),2), ')'])


%%
figure, 
bar([[R2Oracle, R2Sup, R2valDAD]; [PcorrOracle, PcorrSup, PcorrDAD]; ...
    [minKLOracle, minKLSup, minKLDAD]]' )