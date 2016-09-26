function y = eval_KL(X,Xout,k)

% Input
% x = initial angle to rotate source data (target cone is in canonical pose)
% Vcurr = projected neural data (source distribution)
% X = target distribution (already blurred slightly)
% method = metric used for distribution alignment
%          if 'KL' then use 3D KL to align source/target
%          if other, then use L2 distance between point clouds (icp)        
%%%%

bsz = 50;

if nargin<3
    k0=round(size(X,2)^(1/3));
    k1=round(size(Xout,2)^(1/3));
else
    k0 = k;
    k1= k;
end

if size(X,2)==3
    p_train = prob_grid3D(normal(X),bsz,k0);
    p_rot = prob_grid3D(normal(Xout),bsz,k1);
elseif size(X,2)==2
    p_train = prob_grid(normal(X),bsz,k0);
    p_rot = prob_grid(normal(Xout),bsz,k1);
end

y = error_nocenter(log(p_train),log(p_rot),size(X,2));

%y = p_rot'*log(p_rot./p_train);
%y = norm(log(p_rot(:))-log(p_train(:)));

end