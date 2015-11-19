
k=ceil(size(Xtrain,1)^0.3);
dMatX=getDist(Xtrain,Xtrain);
sdMatX=sort(dMatX);
rhoX=sdMatX(k,:);

% remove idx that have zero weights for supervised estimate
idremove = find(sum(abs(W'))<1e-5); 
W2 = W; W2([idremove,183],:)=[];

Y2 = Ytest; Y2(:,idremove)=[];
Nneurons = size(Y2,2); 
W0 = sprandn(Nneurons,2,0.5);

fKL = @(W)evalKLDiv(W,Xtrain,Y2,10,rhoX);
options = optimoptions('fminunc','Algorithm','quasi-newton','GradObj','off','Display','iter-detailed');

[X,FVAL] = fminunc(fKL,W2,options);