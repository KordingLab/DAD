function [Xout,res1,Fmat] = conefit(X,V,gridsz,method)
if nargin<4
    method = 'KL';
end

% target (X) and source (V) data
Xn = normal(X); % target

[~, ~, Vr,~] = icp(Xn',V'); % align source to target
Vcurr = Vr'; % align point clouds first

% grid search over 3D space
[xx,yy,zz] = meshgrid(-1:2/(gridsz-1):1,-1:2/(gridsz-1):1,-1:2/(gridsz-1):1);
Fmat = [xx(:),yy(:),zz(:)];

% remove grid points with small norm, e.g., (0,0,0) vec
id = find(norms(Fmat')<0.1);
Fmat(id,:)=[];
numA = size(Fmat,1);

% Rotate Vcurr by angle in Fmat (grid points), align sets (with icp), and
% evaluate KL divergence between 3D distributions
fx = @(x)fun_optimizecone(x,Vcurr,Xn,method);
res1 = zeros(numA,1);
for i=1:numA  
    res1(i) = fx(Fmat(i,:));
end

[~,id2] = min(res1);
afinal = Fmat(id2,:); 
[Xout,~] = compute_coneresid(Vcurr,Xn,afinal); % final alignment (min KL)

    
end % end main function

