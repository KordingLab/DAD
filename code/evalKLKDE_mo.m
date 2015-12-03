function KL = evalKLKDE_mo(W,X,Y,p1)

xdim= size(X, 2);
ydim= size(Y, 2);

WMat= reshape(W, xdim, ydim);
Yhat = X*WMat;
vy= var(Yhat);
p2= kde(Yhat', vy/10');
p2=  ksize(p2, 'lcv');

KL= kld(p1,p2);

return;