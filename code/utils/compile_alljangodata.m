function [Xtrain,Xtest,Ytest,Ttrain,Ttest] = compile_alljangodata(whichtest)

load('Jango_allRadData.mat')

if whichtest==1
    
    X1 = [allData.Xte.Jango_0801; 
        allData.Xte.Jango_0819; 
        allData.Xte.Jango_0901; 
        allData.Xte.Jango_0930];

    Xtrain = [X1; 
        allData.Xtr.Jango_0801; 
        allData.Xtr.Jango_0819; 
        allData.Xtr.Jango_0901; 
        allData.Xtr.Jango_0930];
    
    T1 = [allData.Tte.Jango_0801; 
        allData.Tte.Jango_0819; 
        allData.Tte.Jango_0901; 
        allData.Tte.Jango_0930];

    Ttrain = [T1; 
        allData.Ttr.Jango_0801; 
        allData.Ttr.Jango_0819; 
        allData.Ttr.Jango_0901; 
        allData.Ttr.Jango_0930];
    
    Xtest = [allData.Xte.Jango_0728];
    Ttest = [allData.Tte.Jango_0728];
    Ytest = [allData.Yte.Jango_0728];

elseif whichtest==2
    X1 = [allData.Xte.Jango_0728; 
        allData.Xte.Jango_0819; 
        allData.Xte.Jango_0901; 
        allData.Xte.Jango_0930];

    Xtrain = [X1; 
        allData.Xtr.Jango_0728; 
        allData.Xtr.Jango_0819; 
        allData.Xtr.Jango_0901; 
        allData.Xtr.Jango_0930];
    
    T1 = [allData.Tte.Jango_0728; 
        allData.Tte.Jango_0819; 
        allData.Tte.Jango_0901; 
        allData.Tte.Jango_0930];

    Ttrain = [T1; 
        allData.Ttr.Jango_0728; 
        allData.Ttr.Jango_0819; 
        allData.Ttr.Jango_0901; 
        allData.Ttr.Jango_0930];
    
    Xtest = [allData.Xte.Jango_0801];
    Ttest = [allData.Tte.Jango_0801];
    Ytest = [allData.Yte.Jango_0801];    
    
elseif whichtest==3
    X1 = [allData.Xte.Jango_0728; 
        allData.Xte.Jango_0819; 
        allData.Xte.Jango_0801; 
        allData.Xte.Jango_0930];

    Xtrain = [X1; 
        allData.Xtr.Jango_0728; 
        allData.Xtr.Jango_0819; 
        allData.Xtr.Jango_0801; 
        allData.Xtr.Jango_0930];
    
    T1 = [allData.Tte.Jango_0728; 
        allData.Tte.Jango_0819; 
        allData.Tte.Jango_0801; 
        allData.Tte.Jango_0930];

    Ttrain = [T1; 
        allData.Ttr.Jango_0728; 
        allData.Ttr.Jango_0819; 
        allData.Ttr.Jango_0801; 
        allData.Ttr.Jango_0930];
    
    Xtest = [allData.Xte.Jango_0901];
    Ttest = [allData.Tte.Jango_0901];
    Ytest = [allData.Yte.Jango_0901];
        
elseif whichtest==4
    X1 = [allData.Xte.Jango_0728; 
        allData.Xte.Jango_0801; 
        allData.Xte.Jango_0901; 
        allData.Xte.Jango_0819];

    Xtrain = [X1; 
        allData.Xtr.Jango_0728; 
        allData.Xtr.Jango_0801; 
        allData.Xtr.Jango_0901; 
        allData.Xtr.Jango_0819];
    
    T1 = [allData.Tte.Jango_0728; 
        allData.Tte.Jango_0801; 
        allData.Tte.Jango_0901; 
        allData.Tte.Jango_0819];

    Ttrain = [T1; 
        allData.Ttr.Jango_0728; 
        allData.Ttr.Jango_0801; 
        allData.Ttr.Jango_0901; 
        allData.Ttr.Jango_0819];
    
    %Xtest = [allData.Xte.Jango_0930; allData.Xtr.Jango_0930];
    %Ttest = [allData.Tte.Jango_0930; allData.Ttr.Jango_0930];
    %Ytest = [allData.Yte.Jango_0930; allData.Ytr.Jango_0930];
    
    Xtest = [allData.Xte.Jango_0930];
    Ttest = [allData.Tte.Jango_0930];
    Ytest = [allData.Yte.Jango_0930];
    
     
end
    
