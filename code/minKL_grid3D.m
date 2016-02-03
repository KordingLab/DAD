function Results = minKL_grid3D(V,X,angVals,sVals,method,k,numsol)
% minimize KL (rotation + scaling) over a normalized grid
% input = V >> test dataset
% input = X >> kinematics data (target distribution)
% input = angVals

%% Step 0. Set things up

% default options (if not specified)
if nargin<5
    method = 'KL';
    k=[];
end

if nargin<6
    k=[];
end


%% Step 1. 

% Normalize both target and source embeddings
Xn = normal(X); %Xn = correctCone(Xn);
Vn = normal(V);

[Vout,~] = conefit2(Xn,Vn,2); % random restarts for cone angle
   
% minKLgrid in 2D
Results = minKL_grid(Vout(:,1:2),Xn(:,1:2),angVals,sVals,method,k,numsol);
Results.Vicp = Vout;
Results.V = Vn;
%Results.nmdiff = nmdiff;


end % end main function



