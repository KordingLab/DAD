function y = fun_optimizecone(x,Vcurr,X,method)

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