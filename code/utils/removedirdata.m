function [Xtest,Ytest,Ttest,Xtrain,Ytrain,Ttrain,Ntest,Ntrain] = removedirdata(Data,removedir)

testid=[]; trainid =[];
for i=1:length(removedir)
    testid = [testid; find(Data.Ttest==removedir(i))];
    trainid = [trainid; find(Data.Ttrain==removedir(i))];
end
Ytest = Data.Ytest; Ytest(testid,:)=[];
Xtest = Data.Xtest; Xtest(testid,:)=[];
Ttest = Data.Ttest; Ttest(testid)=[];
Ntest = Data.Ntest; Ntest(testid)=[];

Ttrain = Data.Ttrain; Ttrain(trainid)=[];
Xtrain = Data.Xtrain; Xtrain(trainid,:)=[];
Ntrain = Data.Ntrain; Ntrain(trainid,:)=[];

if isfield(Data,'Ytrain')
    Ytrain = Data.Ytrain; 
    Ytrain(trainid,:)=[];
else
    Ytrain = 0;
end

end