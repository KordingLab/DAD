function [Xout,res1,Fmat] = conefit3(X,V,gridsz)
% target (X) and source (V) data
Xn = normal(X); % target

[~, ~, Vr,~] = icp(Xn',V'); % align source to target
Vcurr = Vr'; % align point clouds first

nmtol = 1e-4;
oldval = 1;

% grid search
[xx,yy,zz] = meshgrid(-1:2/(gridsz-1):1,-1:2/(gridsz-1):1,-1:2/(gridsz-1):1);
Fmat = [xx(:),yy(:),zz(:)];
    
id = find(norms(Fmat')<0.3);
Fmat(id,:)=[];
numA = size(Fmat,1);

fx = @(x)fun_optimizecone(x,Vcurr,Xn);
res1 = zeros(numA,1);
for i=1:numA  
    res1(i) = fx(Fmat(i,:));
end

%    subplot(5,5,i); plot3(Xout(:,1),Xout(:,2),Xout(:,3),'*')
% hold on; plot3(X(:,1),X(:,2),X(:,3),'ro'); title(num2str(y,4))

[~,id2] = min(res1);
afinal = Fmat(id2,:); 
[Xout,~] = compute_coneresid(Vcurr,Xn,afinal);

    
end % end main function

