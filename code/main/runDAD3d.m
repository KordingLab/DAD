function [Xrec,Vflip,Vr,minKL,mean_resid] = runDAD3d(Xtr,Yte,dimred_method,numT)

if nargin<=3
    numT=1;
end

k = 3; % align in 3 dimensions
gridsz = 5; % grid size for angle search (3D) => sz^3 angles (change back to 10)

if (k==3)&&(size(Xtr,2)==2)
    Xtr = mapX3D(Xtr);
end

Xn = normal(Xtr);
Yr = remove_constcols(Yte);

if length(dimred_method)>1
    M1{1} = dimred_method;
    [Vr,~] = computeV(Yr,k,M1);
    Vr = Vr{1};
    [Xrec,~,Vflip,minKL] = DAD_3Dsearch(Xn,normal(Vr),gridsz,numT);
    mean_resid=0;
else
    [Vr,~,mean_resid] = computeV(Yr,k,[]);
    T = length(Vr);
    Xrec = cell(T,1);
    Vflip = cell(T,1);
    minKL = cell(T,1);
    for i=1:T
        [Xrec{i},~,tmp,minKL{i}] = DAD_3Dsearch(Xn,normal(Vr{i}),sz,1);
        Vflip{i} = tmp;
    end
end

    
end