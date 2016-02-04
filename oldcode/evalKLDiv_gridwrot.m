function KLD = evalKLDiv_gridwrot(W,theta,ps,Y,ydim,p1,bsz)

if nargin<7
    bsz = 50;
end
% input = Y
% output = KL Divergence between p1 and p2 (dist of Y*W*rot(theta))

R = rotmat(theta);
xdim = size(Y, 2);

WMat= reshape(W, xdim, ydim);
Xhat = normal(Y*WMat*[ps,0;0,1]*R);

p2=prob_grid(Xhat,bsz);

KLD = norm(log(p1(:))-log(p2(:)))./norm(log(p1(:)));

end