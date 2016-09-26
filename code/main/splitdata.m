function [Ytr,Yte,Xtr,Xte,Ttr,Tte] = splitdata(Y,X,T,samp)
% samp = percentage of data for training

if nargin<4
    samp = 0.5;
end

Ns = size(Y,1);
changeids = find(diff(T)~=0);

idx{1} = 1:changeids(1); 
for i=1:length(changeids)-1, 
    idx{i+1} = changeids(i)+1:changeids(i+1); 
end
idx{length(changeids)+1} = changeids(end)+1:length(T);

L= length(changeids)+1;
ntr = ceil(L*samp);
shuff = randperm(L);

trset = shuff(1:ntr);
teset = shuff(ntr+1:end);

train_set=[];
for i=1:length(trset)
    train_set = [train_set,idx{trset(i)}];
end

test_set=[];
for i=1:length(teset)
    test_set = [test_set,idx{teset(i)}];
end


Ttr = T(train_set);
Tte = T(test_set);
Ytr = Y(train_set,:);
Yte = Y(test_set,:);
Xtr = X(train_set,:);
Xte = X(test_set,:);

end