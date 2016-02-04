function [R2,L2err,minVal,se] = run3Ddad_bootstrap(X,Y,numIter)

Nsamp = 5000; % number of bootstrap samples
R2 = zeros(8,numIter);
for nn = 1:numIter
    % supply optional args (Xtest,Ttest) to display embedding results
    N = size(Ytrain,1);
    permz = randperm(N);
    
    numselect = ceil(N*percent_samp);
    Xtr = X(permz(1:numselect),:);
    Ytr = Y(permz(1:numselect),:);
    
    Xte = X(permz(numselect+1:end),:);
    Yte = Y(permz(numselect+1:end),:);
    
    X3D = mapX3D(Xtr);

    % throw away neurons that dont fire
    Yr = Yte; 
    Yr(:,sum(Yte)<20)=[];

    [Vr,Methods] = computeV(Yr,3,[]); 

    % compute V (low-dim embeddings with factor analysis)
    M1{1} = 'FA'; tmp = computeV(Yr,3,M1); 
    tn = length(Vr); Vr{tn+1} = tmp{1}; Methods{tn+1} = 'FA'; 

    % 3d DAD
    [r2val,minval,Res] = calcR2_minKL3Dgrid(Vr,X3D,Xte,A,[],Methods); % input Methods is optional

    l2val = zeros(length(Res),1);
    for i = 1:length(Res)
        l2val(i) = evalL2err(Xte,Res{i}.Xrec);
    end
    
    R2(1:6,nn) = squeeze(r2val);
    minVal(1:6,nn) = squeeze(minval);
    L2err(1:6,nn) = l2val;

    % supervised decoder
    fldnum=10; lamnum=500;
    [Wsup, ~, ~, ~]= crossVaL(Ytr, Xtr, Yte, lamnum, fldnum);

    r2sup = evalR2(Xte,[Yte,ones(size(Yte,1),1)]*Wsup);
    display(['Supervised decoder, R2 = ', num2str(r2sup,3)])    
    R2(7,nn) = r2sup;    
    L2err(7,nn) = evalL2err(Xte,[Yte,ones(size(Yte,1),1)]*Wsup);
    
    % least squares error (best 2 dim projection)
    warning off, Wls = (Yte\Xte); r2ls = evalR2(Xte,Yte*Wls);
    display(['Least-squares Projection, R2 = ', num2str(r2ls,3)])
    R2(8,nn) = r2ls;
    L2err(8,nn) = evalL2err(Xte,Yte*Wls);
    display(['Iterations left = ', int2str(numIter -nn)])
end

% bootstrap sampling to get standard error
r2boot = bootstrp(Nsamp,@median,R2');
l2boot = bootstrp(Nsamp,@median,L2err');
minvalboot = bootstrp(Nsamp,@median,minVal');
se = [std(r2boot), std(l2boot), std(minvalboot)];

end