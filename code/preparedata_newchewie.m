function Data = preparedata_newchewie(delT,removelabel,subsamp)

if nargin<2
    removelabel=[];
    subsamp =[];
end

if nargin<3
   subsamp =[];
end
    
% kinematics (MIHI)
load Mihi_small;
Dtr1=out_struct;

% neural data (CHEWIE)
datanum = '16'; % can choose between '15 and '16'
load(['Chewie_M1_CO_VR_BL_07',datanum,'2015.mat']);
Dte= out_struct;

tttr1  = ff_trial_table_co(Dtr1);
ttte  =  ff_trial_table_co(Dte);

[Y1   , X1 ,  T1,  N1]  =  getFR_overlap(Dtr1,  delT,  tttr1 , delT/2);
[Y3   , X3 ,  T3,  N3]  =  getFR_overlap(Dte,   delT,  ttte, delT/2);

clear Dtr1
clear Dte

%XN1=normal(X1);
Xtr= X1;
Ytr= Y1;
Ttr= T1;
Ntr= N1;

if subsamp==1
    dsz=size(Y3,1);
    dsz1=round(dsz/3);
    Yte=Y3(dsz1+1:end, :);
    Xte=X3(dsz1+1:end, :);
    Tte=T3(dsz1+1:end, :);
    Nte=N3(dsz1+1:end, :);
else
    Yte=Y3;
    Xte=X3;
    Tte=T3;
    Nte=N3;
end

tindte = [];
tindtr = [];
if ~isempty(removelabel)
    for i=1:length(removelabel)
        tindte= [tindte, find(Tte == removelabel(i))'];
        tindtr= [tindtr, find(Ttr == removelabel(i))'];
    end
end
tindte = setdiff(1:length(Tte),tindte);
tindtr = setdiff(1:length(Ttr),tindtr);

Data.Xtrain = Xtr(tindtr,:);
Data.Ytrain = Ytr(tindtr,:);
Data.Ttrain = Ttr(tindtr,:);
Data.Ntrain = Ntr(tindtr,:);

Data.Xtest = Xte(tindte,:);
Data.Ytest = Yte(tindte,:);
Data.Ttest = Tte(tindte,:);
Data.Ntest = Nte(tindte,:);

end
