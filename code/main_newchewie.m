
%%%%% Script to run DAD on Mihi's neural data + Chewie's motor data

% initialize parameters
C = setinputparams();

% change parameters in C from their defauly value here
% ex: to change thresholds in pre-processing step =
% [C.th1l,C.th1u,C.th2l,C.th2u];

load Mihi_small;
Dtr1=out_struct;

datanum = '16'; % can choose between '15 and '16'
load(['Chewie_M1_CO_VR_BL_07',datanum,'2015.mat']);
Dte= out_struct;

C.delT=.04;
Data = preparedata_newchewie(Dtr1,Dte,C.delT);
Data2x = preparedata_newchewie(Dtr1,Dte,C.delT/2);

%%%%
removedir = [0,2,3,4,6,7];
testid=[]; trainid =[];
for i=1:length(removedir)
    testid = [testid; find(Data.Ttest==removedir(i))];
    trainid = [trainid; find(Data2x.Ttrain==removedir(i))];
end
Ytest = Data.Ytest; Ytest(testid,:)=[];
Xtest = Data.Xtest; Xtest(testid,:)=[];
Ttest = Data.Ttest; Ttest(testid)=[];
Ttrain = Data2x.Ttrain; Ttrain(trainid)=[];
Xtrain = Data2x.Xtrain; Xtrain(trainid,:)=[];


C.th1l = 1; C.th1u = Inf;
C.th2l = 1; C.th2u = Inf;
Results = DAD(Ytest,Xtrain,C,Xtest,Ttest,Ttrain);

% plot original data
figure; colorData2014(Data.Xtest, Data.Ttest)

figure; colorData2014(Results.YrKLMat, Data.Ttest)



