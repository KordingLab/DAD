function dMat=getDist(X,Y)

dszX=size(X,1);
dszY=size(Y,1);
VY=ones(dszY,1);
VX=ones(1,dszX);
dMat=VY*sum(X'.^2)-2*Y*X'+sum(Y.^2,2)*VX;

return;