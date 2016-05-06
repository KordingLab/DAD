function Res = run3Dconematch(Xtrain,Ytrain,Ttrain,Ntrain,percent_samp,gridsz,numIter)


Res = cell(numIter,1); 
for nn = 1:numIter % random train/test split
    [Xtr,Ytr,~,Xte,Yte,~,~,~] = splitdataset(Xtrain,Ytrain,Ttrain,Ntrain,percent_samp); 
    
    %%%% supervised & least-squares
    fldnum=10; lamnum=500;
    [Wsup, ~, ~, ~]= crossVaL(Ytr, Xtr, Yte, lamnum, fldnum);
    Xsup = [Yte,ones(size(Yte,1),1)]*Wsup;
    r2sup = evalR2(Xte,Xsup);     
    
    % least squares error (best 2 dim projection)
    warning off, Wls = (Yte\Xte); r2ls = evalR2(Xte,Yte*Wls); 

    % throw away neurons that dont fire
    id2 = find(sum(Yte)<20); 
    Yr = Yte; Yr(:,id2)=[];

    % throw away neurons with nearly-constant firing rates
    id1 = find(sum(abs(diff(Yr)))<1e-3);
    Yr(:,id1)=[];

    Results = DADconematch(Yr,Xtr,gridsz);
    Xrec = Results.Vout;
    Rtmp = evalR2(Xrec(:,1:2),Xte);
    display(['DAD, R2 = ', num2str(Rtmp,3)])   
        
    Xave = (Xsup+Xrec)/2;
    r2ave = evalR2(Xte,Xave); 
            
    Res{nn}.R2Ave = r2ave;
    Res{nn}.R2X = Rtmp;
    Res{nn}.R2sup = r2sup; 
    Res{nn}.R2ls = r2ls;
            
    Results = DADconematch(Yr,[Xtr; XtrC],numInit);
    Xrec = Results.Vout;
    Rtmp = evalR2(Xrec,Xte);
    display(['DAD (MC), R2 = ', num2str(Rtmp,3)])   

    
    Xave = (Xsup+Xrec)/2;
    r2ave = evalR2(Xte,Xave); 
            
    Res{nn}.R2AveMC = r2ave;
    Res{nn}.R2XMC = Rtmp;
    Res{nn}.R2supMC = r2sup; 
    Res{nn}.R2lsMC = r2ls;

end

end