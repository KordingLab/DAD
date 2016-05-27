
function  [W, Xhat, R2Max, lamc]= crossVaL(Ytr, Xtr, Yte, lamnum, fldnum)

d= size(Ytr);

YE= [Ytr,ones(d(1),1)];

global lam
R2= zeros(lamnum,1);

NYE= norm(YE'*YE);

lamvect= linspace(1e-5*NYE,1e-2*NYE,lamnum);


f = @LinEst;

for i=1:lamnum;
    
lam= lamvect(i);
 
R2V= crossval(f, YE , Xtr,'kfold',fldnum);
%err2=crossval(LinEst, YtrE , Xtr);

R2(i)= mean(R2V);
R2C= R2(i);

end;

[R2Max,Ind]= max(R2);
lamc= lamvect(Ind);

d=size(YE);
W = pinv(YE'*YE+lamc*eye(d(2))) * YE'*Xtr;

Xhat = YE*W;


return

