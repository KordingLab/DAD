%%%%% Script to run DAD on Chewie and Mihi's data

% initialize parameters
C = setinputparams();

% Load neural (Y) and movement (X) datasets
load Chewie_12192013;
Dtr1= out_struct;

load Chewie_10032013;
Dtr2= out_struct;
load Mihi_small;
Dte=out_struct;

Data = preparedata_chewiemihi(Dtr1,Dtr2,Dte,C.delT);

Results = DAD(Data.Ytest,Data.Xtrain,C,Data.Xtest);

