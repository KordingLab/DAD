function [Xrec,Vflip,Vout,Vr,minKL,mean_resid] = runDAD3d(Xtr,Yte,opts)
k = 3; % align in 3 dimensions (unless otherwise specified)

% default parameters
gridsz=5;
dimred_method= 'PCA';
numT = 1;
check2D = 0; % dont check 2D embedding

if nargin>2
    if isfield(opts,'gridsz')
        gridsz = opts.gridsz;
    end
    
    if isfield(opts,'dimred_method')
        dimred_method = opts.dimred_method;
    end
    
    if isfield(opts,'numT')
        numT = opts.numT;
    end
        
    if isfield(opts,'check2D')
        check2D = opts.check2D;
    end
end

if (k==3)&&(size(Xtr,2)==2)
    Xtr = mapX3D(Xtr);
end

Xn = normal(Xtr);
Yr = remove_constcols(Yte);

if length(dimred_method)>1
    M1{1} = dimred_method;
    tstart = tic; 
   
    [Vr,~] = computeV(Yr,k,M1);
    telapsed = toc(tstart);
    
    display(['Finished computing the low-d embedding in ',num2str(telapsed/60,4),' minutes...'])
    Vr = Vr{1};
    
    % run 3D DAD alignment method
    [Xrec,Vout,Vflip,minKL] = DAD_3Dsearch(Xn,normal(Vr),gridsz,numT,check2D);
    mean_resid=0;
else
    tstart = tic; 
    [Vr,~,mean_resid] = computeV(Yr,k,[]);
    telapsed = toc(tstart);
    display(['Finished computing the low-d embedding in ',num2str(telapsed/60,4),' minutes...'])
    T = length(Vr);
    Xrec = cell(T,1);
    Vflip = cell(T,1);
    minKL = cell(T,1);
    for i=1:T
        [Xrec{i},Vout{i},tmp,minKL{i}] = DAD_3Dsearch(Xn,normal(Vr{i}),sz,check2D);
        Vflip{i} = tmp;
    end
end

    
end