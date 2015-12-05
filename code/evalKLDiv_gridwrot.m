function KLD = evalKLDiv_gridwrot(W,theta,Y,ydim,p1)
% input = Y
% output = KL Divergence between p1 and p2 (dist of Y*W*rot(theta))

R = rotmat(theta);
xdim = size(Y, 2);

WMat= reshape(W, xdim, ydim);
Xhat = normal(Y*WMat*R);

p2=prob_grid(Xhat);

KLD = norm(log(p1(:))-log(p2(:)))./norm(log(p1(:)));

end