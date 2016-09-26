% Minimize KL (rotation + scaling) over a normalized grid
% V = test dataset
% X = kinematics data (target distribution)
% gridsz = number of 3D angles to search over (initialization)
% method = to compute deviation between point clouds 
%          (if 'KL' then 3D KL, if other, then L2 between matched point clouds)
function Results = minKL_grid3D(V,X,gridsz,method,finealign,numA)

%% Step 1. 

if nargin<5
    finealign=0;
end

% Normalize both target and source embeddings
Xn = normal(X);
Vn = normal(V);

[Vout,resid] = conefit(Xn,Vn,gridsz,method,numA); % random restarts for cone angle
if finealign==1
   [Results.Xrec,Results.Vflip] = rotated_KLmin(Vout(:,1:2),Xn(:,1:2),90);
end
Results.V = Vout; 
Results.resid = resid;


end % end main function



