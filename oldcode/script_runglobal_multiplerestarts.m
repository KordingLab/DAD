load('supresult-chewie-716.mat')

idremove = find(sum(abs(W'))<1e-5); 
W2 = W; W2([idremove,183],:)=[];
Y2 = Y; Y2([idremove,183],:)=[];
Xrec0 = Y0(:,setdiff(1:size(Y0,2),idremove))*W2;
R2sup = evalR2(Xrec0,Xtest);

options = optimoptions('fminunc','Algorithm','quasi-newton',...
    'MaxIter',2000,'MaxFunEvals',50000,'GradObj','off',...
    'Display','iter-detailed','TolX',5e-6);


%%%%%%% find best k
kk = [2,3,5,10,13];

for i=1:5
    k = kk(i);
    dMatX=getDist(Xtrain,Xtrain);
    sdMatX=sort(dMatX);
    rhoX=sdMatX(k,:);

    fKL = @(W)evalKLDiv(W,Xtrain,Y2,k,rhoX);

    [W2hat{i},FVAL2] = fminunc(fKL,W2,options);
    Xrec2 = Y0(:,setdiff(1:size(Y0,2),idremove))*W2hat{i};
    R2new(i) = evalR2(Xrec2,Xtest)
end

[~,whichk] = min(R2new);
k = kk(whichk);

%%%%%%
for i=1:10; 
    Wstart{i} = sprandn(137,2,0.1)*0.01; 
    [What{i},FVAL(:,i)] = fminunc(fKL,Wstart{i},options);
    Xrec2 = Y0(:,setdiff(1:size(Y0,2),idremove))*What{i};
    figure(i); subplot(1,3,1); colorData2014(Xrec0,Ttest);
    subplot(1,3,2); colorData2014(Xrec2,Ttest)
    subplot(1,3,3); colorData2014(Xtrain,Ttrain)
end