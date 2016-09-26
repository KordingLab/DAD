function [Xout,res1,Fmat] = conefit(X,V,gridsz,method,numA)

if nargin<5
    numA = 20;
end

if nargin<4
    numA = 20;
    method = 'KL';
end

% target (X) and source (V) data
Xn = normal(X); % target

[~, ~, Vr,~] = icp(Xn',V'); % align source to target
Vcurr = Vr'; % align point clouds first

% grid search over 3D space
dim = size(X,2);

if dim==3
    [xx,yy,zz] = meshgrid(-1:2/(gridsz-1):1,-1:2/(gridsz-1):1,-1:2/(gridsz-1):1);
    Fmat = [xx(:),yy(:),zz(:)];
elseif dim==2
    [xx,yy] = meshgrid(-1:2/(gridsz-1):1,-1:2/(gridsz-1):1);
    Fmat = [xx(:),yy(:)];
end
    

% remove grid points with small norm, e.g., (0,0,0) vec
id = find(norms(Fmat')<0.1);
Fmat(id,:)=[];

Fmat= Fmat(randperm(size(Fmat,1)),:); % chose same number of points as target

% Rotate Vcurr by angle in Fmat (grid points), align sets (with icp), and
% evaluate KL divergence between 3D distributions
fx = @(x)fun_optimizecone(x,Vcurr,Xn,method);
res1 = zeros(min(size(Fmat,1),numA),1);
for i=1:min(size(Fmat,1),numA)  
    tic, res1(i) = fx(Fmat(i,:)); toc
end

[~,id2] = min(res1);
afinal = Fmat(id2,:); 
[Xout,~] = compute_coneresid(Vcurr,Xn,afinal); % final alignment (min KL)

    
end % end main function

