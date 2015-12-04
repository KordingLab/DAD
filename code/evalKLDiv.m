function KLD = evalKLDiv(W,Xtrain,Ytest,k,rhoX,S1)
if nargin<6
    S1=[];
end

ydim= size(Ytest, 2);
xdim= size(Xtrain, 2);
Y = Ytest*W;
dMatT=getDist([Xtrain;S1],Y);
[sdMatT,~]=sort(dMatT);
sdMat=sdMatT;
rhoY=sdMat(k,:);
KLD = mean( log( rhoY ./ rhoX ) );

end