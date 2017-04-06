function Xt = sample_from_3Dgrid(bsz,numsamp,xmin,xmax,ymin,ymax,zmin,zmax)

% assume normalized data
if nargin<3
    xmin = -4;
    ymin = -4;
    zmin = -4;
    xmax = 4;
    ymax = 4;
    zmax = 4;
end

[x1,y1,z1] = meshgrid(ymin:(ymax-ymin)/(bsz-1):ymax,...
                   xmin:(xmax-xmin)/(bsz-1):xmax,zmin:(zmax-zmin)/(bsz-1):zmax);
xt = [x1(:),y1(:),z1(:)];   
N = size(xt,1);
permz=randperm(N);
Xt = xt( permz(1:min(numsamp,N)),:);

end