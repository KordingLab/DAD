function [Xtest,Ytest,Ttest,Ttrain,Xtrain] = removedirdata(Data,removedir)

testid=[]; trainid =[];
for i=1:length(removedir)
    testid = [testid; find(Data.Ttest==removedir(i))];
    trainid = [trainid; find(Data.Ttrain==removedir(i))];
end
Ytest = Data.Ytest; Ytest(testid,:)=[];
Xtest = Data.Xtest; Xtest(testid,:)=[];
Ttest = Data.Ttest; Ttest(testid)=[];
Ttrain = Data.Ttrain; Ttrain(trainid)=[];
Xtrain = Data.Xtrain; Xtrain(trainid,:)=[];

end