function [Xtest,Ytest,Ttest,Xtrain,Ytrain,Ttrain,Ntest,Ntrain] = removedirdata(Data,removedir,numSamp,numDelay)

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

if nargin>2
    
    Ytrain = sample_after_gocue(Ytrain,Ttrain,numSamp,numDelay);
    Xtrain = sample_after_gocue(Xtrain,Ttrain,numSamp,numDelay);
    Ntrain = sample_after_gocue(Ntrain,Ttrain,numSamp,numDelay);
    Ttrain = sample_after_gocue(Ttrain,Ttrain,numSamp,numDelay);
        
    Ytest = sample_after_gocue(Ytest,Ttest,numSamp,numDelay);
    Xtest = sample_after_gocue(Xtest,Ttest,numSamp,numDelay);
    Ntest = sample_after_gocue(Ntest,Ttest,numSamp,numDelay);
    Ttest = sample_after_gocue(Ttest,Ttest,numSamp,numDelay);
end

end