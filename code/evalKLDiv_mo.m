function KLD = evalKLDiv_mo(W,X,Y,k,rhoY)

xdim= size(X, 2);
ydim= size(Y, 2);

WMat= reshape(W, xdim, ydim);
Yhat = X*WMat;
%dMatT=getDist(Y,Yhat);
%[sdMatT,~]=sort(dMatT);

[~,sdMat]= knnsearch( Yhat, Y, 'K', k);

rhoYhat=sdMat(:,end);
KLD = mean( log( rhoYhat ./ rhoY ) );

end