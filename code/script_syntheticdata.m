%% prepare data
C = setinputparams();
Ts=.2;
Data = preparedata_chewiemihi(Ts);
Data2x = preparedata_chewiemihi(Ts/2);

removedir = [0,2,7];
[Xtest,Ytest,Ttest,Xtrain,~,Ttrain] = removedirdata(Data,removedir);
XteN = normal(Xtest);
[Xtest2x,Ytest2x,Ttest2x,Xtrain2x,~,Ttrain2x] = removedirdata(Data2x,removedir);

%% find embeddings for different num of neurons (N)
bsz = 50; k = 5; 
numA = 100; numS = 20;
svec = 0.8:(1.2-0.8)/(numS-1):1.2; 
avec = -pi:2*pi/(numA):pi;
N = 100:100:1000;

Results_new = cell(length(N),20);
R2val = zeros(length(N),20);

for j=68:100
    for i=1:length(N)
        Results_new{i,j} = runsynthexpt(Xtest,Ttest,Xtrain,avec,svec,5,N(i));  
        tmp = Results_new{i,j}.R2val,
        R2val(i,j) = tmp;
    end
    j,
end

% now calculate R2 for training on 2x data
Results_new2x = cell(length(N),50);
R2val2x = zeros(length(N),50);
for j=1:13
    for i=1:length(N)
        Results_new2x{i,j} = runsynthexpt(Xtest,Ttest,Xtrain2x,avec,svec,5,N(i));  
        tmp = Results_new2x{i,j}.R2val,
        R2val2x(i,j) = tmp;
    end
    j,
end

%%
dMatX=getDist(normal(Xtrain),normal(Xtrain));
sdMatX=sort(dMatX);
rhoX=sdMatX(k,:);

[YrKL, minVal, KLD, KLS, YLr, YLsc,RM,sconst] = minKL_grid(Ytest,Xtrain,C,'L2',5);

