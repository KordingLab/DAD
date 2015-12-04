function [p1, XN]= prob_grid(X)
%%input a 2-d dataset
%%The denisity function of dataset  using KNN smoothing

bsz=35;
XN=normal(X);

%if nargin==1
%xMax=max(abs(XN(:,1)));
%yMax=max(abs(XN(:,2)));
%end;
xmax= max(XN(:,1));
xmin= min(XN(:,1));
ymax= max(XN(:,2));
ymin= min(XN(:,2));


XN(:,1)= (XN(:,1)-xmin)/(xmax-xmin);
XN(:,2)= (XN(:,2)-ymin)/(ymax-ymin);



dsz=size(XN,1);
k=round(dsz^0.3);
imh=zeros(bsz);
[row,col]=find(imh==0);
rowsc= (row-1)/(bsz-1);
colsc= (col-1)/(bsz-1);
xt=[rowsc,colsc];
p1=prob1(XN , xt , k );


