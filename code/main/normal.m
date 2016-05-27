function [XN, cX, MXMat]=normal(X)

xsz=size(X,1);
MX=mean(X);
MXMat=ones(xsz,1)*MX;
cX=cov(X);
XN=(X-MXMat)/cX^0.5;
return;