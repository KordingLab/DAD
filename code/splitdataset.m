function [Xtr,Ytr,Ttr,Xte,Yte,Tte,trainid,testid] = splitdataset(X,Y,T,N,percent_samp)    

Ny = size(Y,1);
    
id = find(N);
Lid = length(id);
permz = randperm(Lid);

numselect = ceil(Lid*percent_samp);
trainid = [];
for i=1:numselect
    if permz(i)==Lid
        trainid = [trainid, id(permz(i)):Ny];
    else
        trainid = [trainid, [id(permz(i)):id(permz(i)+1)-1]];
    end
end

testid = setdiff(1:Ny,trainid);

Xte = X(testid,:);
Yte = Y(testid,:);
Tte = T(testid,:);

Xtr = X(trainid,:);
Ytr = Y(trainid,:);
Ttr = T(trainid,:);
    
end