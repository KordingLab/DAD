function Data = preparedata_chewiemihi(Dtrain1,Dtrain2,Dtest,delT)

% compute firing rates from spike data
tttr1  = ff_trial_table_co(Dtrain1);
tttr2  = ff_trial_table_co(Dtrain2);
ttte  =  ff_trial_table_co(Dtest);

[Data.Y1   , X1 ,  T1,  N1]  =  getFR(Dtrain1,  delT,  tttr1 );
[Data.Y2   , X2 ,  T2,  N2]  =  getFR(Dtrain2,  delT,  tttr2 );
[Y3   , X3 ,  T3,  N3]  =  getFR(Dtest,   delT,  ttte );
Data.Y3 = Y3;

clear Dtrain1
clear Dtrain2
clear Dtest

XN1=normal(X1);
XN2=normal(X2);
Xtr=[ XN1; XN2 ];
Ttr=[ T1; T2 ];
Ntr=[N1; N2];

dsz=size(Y3,1);
dsz1=round(dsz/3);

Yte=Y3(dsz1+1:end, :);
Xte=X3(dsz1+1:end, :);
Tte=T3(dsz1+1:end, :);
Nte=N3(dsz1+1:end, :);

tindte= (  Tte ~=7 & Tte ~= 0  & Tte~=2);
tindtr= (  Ttr ~=7 & Ttr ~= 0  & Ttr~=2 );

Data.Xtrain= Xtr(tindtr,:);
Data.Ttrain= Ttr(tindtr,:);
Data.Ntrain= Ntr(tindtr,:);

Data.Ttest=Tte(tindte);
Data.Ytest=Yte(tindte,:);
Data.Xtest=Xte(tindte,:);
Data.Ntest=Nte(tindte,:);

end
