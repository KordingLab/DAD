function KLD = evalKLDiv(W,Xtrain,Ytest,k,rhoX)

Y = Ytest*W;
dMatT=getDist(Xtrain,Y);
[sdMatT,~]=sort(dMatT);
sdMat=sdMatT;
rhoY=sdMat(k,:);
KLD = mean( log( rhoY ./ rhoX ) );

end