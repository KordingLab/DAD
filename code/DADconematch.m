function Results = DADconematch(Y,X,gridsz)
% minimize KL (rotation + scaling) over a normalized grid
% input = V >> test dataset
% input = X >> kinematics data (target distribution)
% input = angVals

%% Step 1. 
M1{1} = 'FA';
X3D = mapX3D(X); % augment training kinematics

idd = find(sum(abs(diff(Y)))<0.001);
Y(:,idd)=[]; [Vr,~] = computeV(Y,3,M1);
V = Vr{1};

% Normalize both target and source embeddings
Xn = normal(X3D);
Vn = normal(V);

% Add "blur" to target data
nums=50; nzvar = 0.1;
Ntmp = size(X,1)*nums;
X2 = zeros(Ntmp,3);
for i=1:size(X,1)
    X2((i-1)*nums+1:i*nums,:) = repmat(Xn(i,:),nums,1)+randn(nums,3)*nzvar;
end
Xn = normal(X2);

%[Vout,resid] = conefit2(Xn,Vn,1,numInit); % random restarts for cone angle
[Vout,res1,Fmat] = conefit3(Xn,Vn,gridsz); %5x5x5 

% minKLgrid in 2D
Results = minKL_grid(Vout(:,1:2),Xn(:,1:2),180,0.6:0.6/19:1.2,'KL',5,0);
%Results.Vicp = Vout;
%Results.V = Vn;
%Results.nmdiff = nmdiff;
Results.Vout = Vout;
Results.resid = resid;



end % end main function



