function Results = minKL_grid3D(V,X,gridsz,method,finealign)
% minimize KL (rotation + scaling) over a normalized grid
% input = V >> test dataset
% input = X >> kinematics data (target distribution)
% gridsz = number of 3D angles to search over (initialization)
% method = to compute deviation between point clouds 
%          (if 'KL' then 3D KL, if other, then L2 between matched point clouds)

%% Step 1. 

if nargin<5
    finealign=0;
end

% Normalize both target and source embeddings
Xn = normal(X);
Vn = normal(V);

% Add "blur" to target data (now this is done in runDAD.m)
% nums=50; nzvar = 0.1;
% Ntmp = size(X,1)*nums;
% X2 = zeros(Ntmp,3);
% for i=1:size(X,1)
%     X2((i-1)*nums+1:i*nums,:) = repmat(Xn(i,:),nums,1)+randn(nums,3)*nzvar;
% end
% Xn = normal(X2);

[Vout,resid] = conefit(Xn,Vn,gridsz,method); % random restarts for cone angle

if finealign==1
    Results = minKL_grid(Vout(:,1:2),Xn(:,1:2),linspace(0,360,180),linspace(0.8,1.2,10),'KL',5,5);
end
Results.V = Vout;   
Results.resid = resid;


end % end main function



