
delT=0.2;
winSz=1.1;
thresh=0.8;
EigRatio=1e-7;
winszh=20;

C.gnum=200;
C.anum= 20 ;
C.pig=linspace(-pi,pi,C.gnum);
C.scg=linspace(0.8, 1.2, C.anum);


th1lsz=1;
th1usz=1;
th2lsz=1;
th2usz=1;


th1l=1;
th1u=inf;
th2l=1;
th2u=inf;

load Mihi_small;
Dte=out_struct;


ttte = ff_trial_table_co(Dte);
[  Y   , X ,  T,  N]=  getFR(   Dte,  delT,  ttte );


dsz=size(Y,1);
dsz1=round(dsz/3);
Ytr=Y(1:dsz1,:);
Xtr=X(1:dsz1,:);
Ttr=T(1:dsz1,:);
Ntr=N(1:dsz1,:); 

Yte=Y(dsz1+1:end,:);
Xte=X(dsz1+1:end,:);
Tte=T(dsz1+1:end,:);
Nte=N(dsz1+1:end,:);

dimte=size(Yte,2);



tindte= (Tte ~=7 & Tte ~= 0  & Tte~=2);
tindtr= (Ttr ~=7 & Ttr ~= 0  & Ttr~=2);

Ttr=Ttr(tindtr);
Ytr=Ytr(tindtr,:);
Xtr=Xtr(tindtr,:);
Ntr=Ntr(tindtr,:);

Tte=Tte(tindte);
Yte=Yte(tindte,:);
Xte=Xte(tindte,:);
Nte=Nte(tindte,:);

XteN=normal(Xte);
XtrN=normal(Xtr);
lamnum=2000;
fldnum=10;
[W, Xhat, R2Max]= crossVaL(Ytr, XtrN, Yte, lamnum, fldnum);
XhatN= normal(Xhat);
sstot = sum( var(XteN) );
ssKL = sum( mean((XteN - XhatN).^2) );
R2Sup =   1-ssKL/sstot;
save ResSup  R2Sup  XhatN Xte XteN Xtr XtrN  Tte Nte  Ntr Ttr  Yte Ytr W 
               
return;