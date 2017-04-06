%script_run3D_DAD_Mihi

removedir = [0,1,2,6];
Data = prepare_superviseddata(0.2,'chewie1','mihi',[],0);
[Xte,Yte,Tte,Xtr,Ytr,Ttr,Nte,Ntr] = removedirdata(Data,removedir);
Yte2 = downsamp_nd(Yte,2);
[Xrec,Vflip,Vr] = runDAD3d(Xtr,Yte,'FA');
errDAD = evalR2(Xrec,Xte);

%%%% Supervised methods (run oracle and kalman filter)
Xr = LSoracle(Xte,Yte);
errOracle = evalR2(Xr,Xte);  

[W, Xsup, R2Max, lamc]= crossVaL(Yte, Xte, 500, 100);
errSup = evalR2(Xsup,Xte);
