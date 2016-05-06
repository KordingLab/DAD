function [Xout,res1,an0] = conefit4(X,V,maxIter)

% target (X) and source (V) data
Xn = normal(X); % target

[~, ~, Vout,~] = icp(Xn',V'); % align source to target
Vcurr = Vout'; % align point clouds first

nmtol = 1e-4;

if nargin<3
    maxIter = 1;
    numA = 1;
end

if nargin<4
    numA = 1;
end

oldval = 1;

% grid search
nums=50; 
[xx,yy,zz] = meshgrid(-1:2/(nums-1):1,-1:2/(nums-1):1,-1:2/(nums-1):1);
Fmat = [xx(:),yy(:),zz(:)];
numA = size(Fmat,1);
    
for nn=1:maxIter
    
    an0 = [randn(numA-3,3); 0,0,1; 0,1,0; 1,0,0];
    fx1 = @(x)fun_optimizecone(x,Vcurr,Xn);
    
    res1 = zeros(numA,1);
    for i=1:numA    
        % canonicalvec = [0,0,1]; % wont rotate
        options = optimoptions('fminunc','TolX', 0.01, 'MaxIter', 500);
        [~,res1(i)] = fminunc(fx1,an0(i,:)./norm(an0(i,:)),options); 
    end
    
    [~,id2] = min(res1);
    afinal = an0(id2,:)./norm(an0(id2,:)); % normalize or no?
    
    [Xout,newval] = compute_coneresid(Vcurr,Xn,afinal);

    nmdiff = norm(oldval-newval);
    
    if (nmdiff<nmtol)
        return
    end
    
    oldval = newval;
    
    Vcurr = Xout'; % align point clouds first
    
end


end
