% MAIN DAD FUNCTION
% Yte = neural test data (to decode)
% Xtr = kinematics training data (target distribution for alignment)
% gridsz = number of 3D-angles to test in cone alignment

function Res = runDAD(Yte,Xtr,opts,Tte,Xte)

if isempty(opts)
    nzvar = 0.15;
    rfac = 5;
    numA = 20;
    finealign = 1;
    method = 'KL';
    gridsz = 3;
else
    if isfield(opts,'nzvar')
        nzvar = opts.nzvar;
    else
        nzvar = 0.15;
    end
    
    if isfield(opts,'rfac')
        rfac = opts.rfac;
    else
        rfac = 5;
    end
    
    if isfield(opts,'numA')
        numA = opts.numA;
    else
        numA = 20;
    end
    
    if isfield(opts,'finealign')
        finealign = opts.finealign;
    else
        finealign=1;
    end
    
    if isfield(opts,'method')
        method = opts.method;
    else
        method = 'KL';
    end
    
    if isfield(opts,'gridsz')
        gridsz = opts.gridsz;
    else
        gridsz = 3;
    end
end

spikethr = 20;

%nzvar = 0.15; % for DAD-M and DAD-C
%nzvar = 0.05; % for steph data

% if nargin<4
%     Tte=[];
%     finealign=0;
%     numA = 20;
% end
% 
% if nargin<7
%     finealign=0;
%     numA = 20;
%     rfac = 5; %for DAD-M and DAD-C (results in paper)
%     nzvar = 0.15; %for DAD-M and DAD-C (results in paper)
% end

% throw away neurons that dont fire (less than spikethr spikes)
Yr = Yte; Yr(:,sum(Yte)<spikethr)=[]; 

if nzvar~=0
    Xnew = repmat(Xtr,rfac,1) + randn(size(Xtr,1)*rfac,size(Xtr,2))*nzvar;
else
    Xnew = Xtr;
end

if size(Xtr,2)==2
    X3D = mapX3D(Xnew); % split (training set + extra chewie training for DAD)
    
elseif size(Xtr,2)==3
    X3D = Xnew;
else
    error('Source training data is not 2 or 3D!')
end
clear Xnew Xtr
            
% dimensionality reduction
M1{1} = 'FA'; 
[Vr,~] = computeV(Yr,3,M1);

Res = minKL_grid3D(Vr{1},normal(X3D),gridsz,method,finealign,numA);
Res.X3D = normal(X3D);

if ~isempty(Tte)
    Res.R2 = getR2fromRes(Xte,Res.V);
end

end