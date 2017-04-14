%script_run3D_DAD_Mihi

removedir = [0,1,2,6];
Data = prepare_superviseddata(0.2,'chewie1','mihi',[],0);
[Xte,Yte,Tte,Xtr,Ytr,Ttr,Nte,Ntr] = removedirdata(Data,removedir);
Yte2 = downsamp_nd(Yte,2);

[Xrec,Vflip,Vr,tmp] = runDAD3d(Xtr,Yte,'FA');
R2valDAD(1) = evalR2(Xrec,Xte);
PcorrDAD(1) = evalTargetErr(Xrec,Xte,Tte);
minKLDAD(1) = min(tmp);

[Xrec,~,~,tmp] = runDAD3d(Xtr,Yte,'PCA');
R2valDAD(2) = evalR2(Xrec,Xte);
PcorrDAD(2) = evalTargetErr(Xrec,Xte,Tte);
minKLDAD(2) = min(tmp);

[Xrec,~,~,tmp] = runDAD3d(Xtr,Yte,'Isomap');
R2valDAD(3) = evalR2(Xrec,Xte);
PcorrDAD(3) = evalTargetErr(Xrec,Xte,Tte);
minKLDAD(3) = min(tmp);


%%%% Supervised methods (run oracle and kalman filter)
Xr = LSoracle(Xte,Yte);
R2Oracle = evalR2(Xr,Xte);  
PcorrOracle = evalTargetErr(Xr,Xte,Tte);

[~,~,tmp,~] = rotated_KLmin(Xr,Xtr,90);
minKLOracle = min(tmp);

[W, Xsup, R2Max, lamc]= crossVaL(Yte, Xte, 500, 100);
R2Sup = evalR2(Xsup,Xte); 
PcorrSup = evalTargetErr(Xsup,Xte,Tte);

[~,~,tmp,~] = rotated_KLmin(Xsup,Xtr,90);
minKLSup = min(tmp);

figure, 
bar([[R2Oracle, R2Sup, R2valDAD]; [PcorrOracle, PcorrSup, PcorrDAD]; ...
    [minKLOracle, minKLSup, minKLDAD]]' )
