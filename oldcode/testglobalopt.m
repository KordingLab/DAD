
k=ceil(size(Xtrain,1)^0.3);
k=5;
dMatX=getDist(Xtrain,Xtrain);
sdMatX=sort(dMatX);
rhoX=sdMatX(k,:);

load('supresult-chewie-716.mat')

% remove idx that have zero weights for supervised estimate
idremove = find(sum(abs(W'))<1e-5); 
W2 = W; W2([idremove,183],:)=[];

Y2 = Ytest; Y2(:,idremove)=[];
Nneurons = size(Y2,2); 
W0 = sprandn(Nneurons,2,0.5);

<<<<<<< Updated upstream
fKL = @(W)evalKLDiv(W,Xtrain,Y2,10,rhoX);

options = optimoptions('fminunc','Algorithm','quasi-newton','GradObj','off','Display','iter-detailed');
[X,FVAL] = fminunc(fKL,W2,options);
=======
fKL = @(W)evalKLDiv(W,Xtrain,Y2,round(size(Xtrain,1)^(0.3)),rhoX);
options = optimoptions('fminunc','Algorithm','quasi-newton','MaxIter',2000,'GradObj','off','Display','iter-detailed');
>>>>>>> Stashed changes

