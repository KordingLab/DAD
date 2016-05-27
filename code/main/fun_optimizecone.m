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
    % KL divergence
    bsz = 50;
    k0=ceil(size(X,1)^0.3);
    k1=ceil(size(Xout,1)^0.3);

    p_train = prob_grid3D(normal(X),bsz,k0);
    p_rot = prob_grid3D(normal(Xout),bsz,k1);
    y = p_rot'*log(p_rot./p_train);
else
    y = resid;
end
    
end