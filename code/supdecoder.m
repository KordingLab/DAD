function [Wsup,trainset,testset] = supdecoder(X,Y,trsz)

permz = randperm(size(X,1));

trainset = permz(1:trsz);
testset = permz(trsz+1:end);

Ytrain= Y(trainset,:);
Ytest= Y(testset,:);
Xtrain=normal(X(trainset,:));
Xtest=normal(X(testset,:));

fldnum=10;
lamnum=500;

[Wsup, ~, ~, ~]= crossVaL(Ytrain, Xtrain, Ytest, lamnum, fldnum);

end

