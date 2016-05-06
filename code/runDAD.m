function Res = runDAD(Yte,Xtr,gridsz,Tte,Xte)
% LATEST MAIN DAD FUNCTION
% Yte = neural test data (to decode)
% Xtr = kinematics training data (target distribution for alignment)
% gridsz = number of 3D-angles to test in cone alignment

if nargin<4
    Tte=[];
end

% throw away neurons that dont fire
Yr = Yte; Yr(:,sum(Yte)<20)=[]; 

X3D = mapX3D(Xtr); % split (training set + extra chewie training for DAD)
            
% dimensionality reduction
M1{1} = 'FA'; 
[Vr,~] = computeV(Yr,3,M1);

Res = minKL_grid3D(Vr{1},normal(X3D),gridsz);

if ~isempty(Tte)
    Res.R2 = evalR2(Res.Xrec,Xte);
end

end