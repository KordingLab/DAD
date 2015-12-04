function imht=PlotDist(X)
%%input a 2-d dataset
%%The denisity function of dataset  using KNN smoothing

bsz=80;
XN=normal(X);
xMax=max(abs(XN(:,1)));
yMax=max(abs(XN(:,2)));

dsz=size(XN,1);
k=round(dsz^0.3);
imh=zeros(bsz);
[row,col]=find(imh==0);
rowsc= xMax*( 2*row/bsz-1);
colsc= yMax*(2*col/bsz-1);
xt=[rowsc,colsc];
p1=prob1(XN , xt , k );

for i=1:length(p1)
imh(row(i),col(i))=p1(i);
end;
%figure,
imht=log(10*imh+1);
xGrid=linspace(-1,1,bsz);


figure,
colormap hot
imagesc(xGrid,xGrid,imht);
