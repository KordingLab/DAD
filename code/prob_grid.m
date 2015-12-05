function [p1, XN]= prob_grid(X)
%%input a 2-d dataset
%%The denisity function of dataset  using KNN smoothing

bsz=50;
XN=normal(X);

%if nargin==1
%xMax=max(abs(XN(:,1)));
%yMax=max(abs(XN(:,2)));
%end;
wsz=0.8;
xmax= max(XN(:,1))+wsz;
xmin= min(XN(:,1))-wsz;
ymax= max(XN(:,2))+wsz;
ymin= min(XN(:,2))-wsz;


XN(:,1)= (XN(:,1)-xmin)/(xmax-xmin);
XN(:,2)= (XN(:,2)-ymin)/(ymax-ymin);



dsz=size(XN,1);
k=round(dsz^0.3);
imh=zeros(bsz);
[row,col]=find(imh==0);
rowsc= (row-1)/(bsz-1);
colsc= (col-1)/(bsz-1);
xt=[rowsc,colsc];
p1=prob1(xt , XN , k );

% figure; imagesc(log(reshape(p1,50,50))); colormap hot;
