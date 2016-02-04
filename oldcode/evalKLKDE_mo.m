function L   = evalKLKDE_mo(W,X, ydim, p1)

xdim= size(X, 2);

WMat= reshape(W, xdim, ydim);
Yhat= normal(X*WMat);
%tic
L= -evalAvgLogL(p1, Yhat');
%toc
%vy= var(Yhat);
%tic
%p2= kde(Yhat', (vy/10)');
%toc
%tic
%p2= ksize(p2, 'lcv');
%toc
%tic
%p2= reduce(p2);
% %toc
% tic
% KL= kld(p1, p2);
% toc

return;