% script to run DAD on new datasets

[Y,T,X] = compile_neuraldata([1,5,6,7],20);
Ns = size(Y,1);

changeids = find(diff(T)~=0);
[~,which ] = min(abs(changeids-Ns/2));

Ttr = T(1:changeids(which));
Tte = T(changeids(which)+1:end);

Ytr = Y(1:changeids(which),:);
Yte = Y(changeids(which)+1:end,:);

Xtr = X(1:changeids(which),:);
Xte = X(changeids(which)+1:end,:);


Res = runDAD(Yte,Xtr,30,Tte,Xte,'FA',1);

