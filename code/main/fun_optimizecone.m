% Function to evaluate the distance between two point clouds (Vcurr and X), 
% given an initial (3D) rotation angle x. 
function y = fun_optimizecone(x,Vcurr,X,method)
% Input
% x = initial angle to rotate source data (target cone is in canonical pose)
% Vcurr = projected neural data (source distribution)
% X = target distribution (already blurred slightly)
% method = metric used for distribution alignment
%          if 'KL' then use 3D KL to align source/target
%          if other, then use L2 distance between point clouds (icp)        
%%%%
if nargin<4
    method='KL';
end

[Xout,resid] = compute_coneresid(Vcurr,X,x); 

if strcmp(method,'KL')
    y = eval_KL(X,Xout);
elseif strcmp(method,'SubAng')
    vec0 = [0,0,1]; % z-axis
    [~,ctrs] = kmeans(Xout,3);
    out = pdist2(vec0,ctrs,'cosine');
    
    [~,ctrs] = kmeans(X,3);
    out2 = pdist2(vec0,ctrs,'cosine');
    
    y = abs(max(out)-max(out2)) + abs(min(out)-min(out2));
    
elseif strcmp(method,'MaxDist')
    [~,val] = knnsearch(X,Xout);
    y = max(val);

%     vec0 = [0,0,1]; % z-axis
%     [~,ctrs] = kmeans(Xout,3);
%     out = pdist2(vec0,ctrs,'cosine');
%     
%     [~,ctrs] = kmeans(X,3);
%     out2 = pdist2(vec0,ctrs,'cosine');
%     
%     vals = sort(out);
%     vals2 = sort(out2);
% 
%     y = norm(vals-vals2)*0.1 + y1;

else
    y = resid;
end
    
end