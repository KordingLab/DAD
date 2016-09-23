function Res = runDAD_newdata(Yte,Xtr,gridsz,Tte,Xte,method,finealign)
% MAIN DAD FUNCTION
% Yte = neural test data (to decode)
% Xtr = kinematics training data (target distribution for alignment)
% gridsz = number of 3D-angles to test in cone alignment

rfac = 5;
nzvar = 0.15;

if nargin<4
    Tte=[];
end

if nargin<7
    finealign=0;
end

% throw away neurons that dont fire (less than 20 spikes)
Yr = Yte; Yr(:,sum(Yte)<20)=[]; 

% add noise to training data (blur training)
Xnew = repmat(Xtr,rfac,1) + randn(size(Xtr,1)*rfac,2)*nzvar;
X3D = mapX3D(Xnew); % split (training set + extra chewie training for DAD)
            
% dimensionality reduction
M1{1} = 'FA'; 
[Vr,~] = computeV(Yr,3,M1);

Res = minKL_grid3D(Vr{1},normal(X3D),gridsz,method,finealign);
Res.X3D = normal(X3D);

if ~isempty(Tte)
    Res.R2 = evalR2(Res.V,mapX3D(Xte));
    if finealign==1
        Res.R2 = evalR2(mapX3D(Res.Xrec),mapX3D(Xte));
    end
end

end