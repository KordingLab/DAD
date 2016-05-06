function [p1,gridsz]= prob_grid3D(X,bsz,k)
%%input a 2-d dataset
%%The denisty function of dataset  using KNN smoothing

wsz=1; % size of boundary around data (amount to zero pad around image)

if nargin<2
    bsz=50;
end

if isempty(k)
    dsz=size(X,1);
    k=round(dsz^0.3);
end

XN=normal(X);

xmax= max(XN(:,1))+wsz;
xmin= min(XN(:,1))-wsz;
ymax= max(XN(:,2))+wsz;
ymin= min(XN(:,2))-wsz;
zmax= max(XN(:,3))+wsz;
zmin= min(XN(:,3))-wsz;

if xmax>ymax
    ymax = xmax;
else
    xmax = ymax;
end

if xmin<ymin
    ymin = xmin;
else
    xmin = ymin;
end

%xmax = 4+wsz;
%xmin = -4-wsz;
%ymax = 4+wsz;
%ymin = -4-wsz;

gridsz = [(xmax-xmin)./(bsz-1),(ymax-ymin)./(bsz-1),(zmax-zmin)./(bsz-1)];

%XN(:,1)= (XN(:,1)-xmin)/(xmax-xmin);
%XN(:,2)= (XN(:,2)-ymin)/(ymax-ymin);

if nargin<3
    dsz=size(XN,1);
    k=round(dsz^0.3);
end

% imh=zeros(bsz);
% [row,col]=find(imh==0);
% rowsc= (row-1)/(bsz-1);
% colsc= (col-1)/(bsz-1);
% %xt=[colsc,rowsc];
% xt=[rowsc,colsc];

[x1,y1,z1] = meshgrid(ymin:(ymax-ymin)/(bsz-1):ymax,...
                   xmin:(xmax-xmin)/(bsz-1):xmax,zmin:(zmax-zmin)/(bsz-1):zmax);
xt = [x1(:),y1(:),z1(:)];               

p1=prob1(xt , XN , k );


% figure; imagesc(log(reshape(p1,50,50))); colormap hot;
