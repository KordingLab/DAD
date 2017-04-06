%script_run3D_DAD_Mihi

removedir = [0,1,2,6];
Data = prepare_superviseddata(0.2,'chewie1','mihi',[],0);
[Xte,Yte,Tte,Xtr,Ytr,Ttr,Nte,Ntr] = removedirdata(Data,removedir);
Yte2 = downsamp_nd(Yte,2);
[Xrec,Vflip,Vr] = runDAD3d(Xtr,Yte,'FA');
errDAD = evalR2(Xrec,Xte);

figure,
subplot(1,3,1),
colorData(Xte,Tte),
title('Ground truth')

subplot(1,2,2),
colorData(Xrec,Tte)
title(['DAD estimate (R2 = ', num2str(errDAD,3),')'])