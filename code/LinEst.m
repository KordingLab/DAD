function R2 =LinEst( Ytr, Xtr,   Yte, Xte)

global lam;
d=size(Ytr);
W = pinv(Ytr'*Ytr+lam*eye(d(2))) * Ytr'*Xtr;
%W = pinv(Ytr'*Ytr+lam*eye(d(2)+1)) * Ytr'*Xtr;
Xhat=Yte*W;
XhatN=normal(Xhat);
XteN=normal(Xte);
sstot = sum( var(XteN) );
ssKL = sum( mean((XteN - XhatN).^2) );
R2=   1-ssKL/sstot;

return;