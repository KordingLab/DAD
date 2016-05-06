function y = computeKL(X,Xout)

% KL divergence
    bsz = 50;
    k0=ceil(size(X,1)^0.3);
    k1=ceil(size(Xout,1)^0.3);
    
    p_train = prob_grid3D(normal(X),bsz,k0);
    p_rot = prob_grid3D(normal(Xout),bsz,k1);
    %y = p_rot'*log(p_rot./p_train);
    y = norm(p_rot(:)-p_train(:));
    
end