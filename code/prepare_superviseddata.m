function Data = prepare_superviseddata(delT,monkeytr,monkeyte,removelabel,percent_split)

if nargin<4
    removelabel = [];
    percent_split = 0.5;
end

if nargin<5
    percent_split = 0.5;
end
    

[Y1,X1,T1, N1] =  getdata(monkeytr,delT);
    
if strcmp(monkeytr,monkeyte) % split dataset
    
    %percent_split = 0.4;
    
    Y1(:,find(sum(Y1)==0))=[];
    szY = size(Y1,1);
    
    if percent_split>0
    
        numsplit1 = ceil(percent_split*szY);
        permz = randperm(szY);
        split1 = permz(1:numsplit1);
        split2 = permz(numsplit1+1:end);
    
    else
        split1 = 1:szY;
        split2 = [];
    end
   
    Xtr= X1(split1,:);
    Xte = X1(split2,:);

    Ytr= Y1(split1,:);
    Yte = Y1(split2,:);

    Ttr= T1(split1,:);
    Tte = T1(split2,:);
    
    Ntr= N1(split1,:);
    Nte = N1(split2,:);
    
else
    
    [Y2,X2,T2, N2] =  getdata(monkeyte,delT);
    Ytr = Y1;
    Xtr = X1;
    Ttr = T1;
    Ntr = N1;
    
    Yte = Y2;
    Xte = X2;
    Tte = T2;
    Nte = N2;
end   

% remove certain reach directions
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

%Data.permutation = permz;

end


function [Y1, X1, T1, N1] =  getdata(whichmonkey,delT)

if strcmp(whichmonkey,'mihi')
    load Mihi_small
    Dtr1=out_struct;
    
elseif strcmp(whichmonkey,'chewie1')
     load('Chewie_10032013.mat')
      Dtr1=out_struct;
        
elseif strcmp(whichmonkey,'chewie2')
    load('Chewie_12192013.mat')
    Dtr1=out_struct;
    
elseif strcmp(whichmonkey,'chewie3')
    load('Chewie_M1_CO_VR_BL_07152015.mat')
    Dtr1=out_struct;
    
elseif strcmp(whichmonkey,'chewie4')
    load('Chewie_M1_CO_VR_BL_07162015.mat')
    Dtr1=out_struct;
else
    display('Specify which dataset you wish me to prepare!')
end

tttr1  = ff_trial_table_co(Dtr1);
[Y1   , X1 ,  T1,  N1]  =  getFR_overlap(Dtr1,  delT,  tttr1 , delT/2);
clear Dtr1

end
