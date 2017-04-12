function [Vout,Vflip,y,flipInd] = rotated_KLmin(V,Xtr,numA,fitskew)

if nargin<4
    fitskew=0;
end

k=3;
numpeaks = 10;

if size(V,2) ~= size(Xtr)
    error('target and test set are not same dimension!')
end

angVals = linspace(0,180,numA);
cosg = cosd(angVals);
sing  = sind(angVals);

VLr = cell(2*numA,1);
y = zeros(2*numA,1);
for p=1:2*numA
    pm = mod(p-1,numA)+1;
    ps = 2*floor((p-1)/numA)-1;
    rm = [ps,0;0,1]*[cosg(pm),-sing(pm);sing(pm),cosg(pm)];
    
    if fitskew~=0
        sx = 0.2+ 0.2*(1:7);
        sy = 0.2+ 0.2*(1:7);
    
        ys=zeros(length(sx)*length(sy),1);
        VLrs = cell(length(sx)*length(sy),1);
        count=1;
        for s1 = 1:length(sx)
            for s2 = 1:length(sy)
                smat = [sx(s1),0;0,sy(s2)];
                VLrs{count} = normal( V * rm * smat);
                ys(count) = eval_KL(VLrs{count},Xtr,k);
                count = count+1;
            end
        end
        [y(p),idd] = min(ys);
        VLr{p} = VLrs{idd};
    else
        VLr{p} = normal( V * rm);
        ys = eval_KL(VLr{p},Xtr,k);
        [y(p),~] = min(ys);
    end
end

[~,minid] = min(y);
Vout = VLr{minid};

[pks,KLid] = findpeaks(-y);
[~,id] = sort(pks,'descend');
Vflip = cell(min(numpeaks,length(KLid)),1);
flipInd = zeros(min(numpeaks,length(KLid)),1);
for i=1:min(numpeaks,length(KLid))
    flipInd(i) = KLid(id(i));
    Vflip{i}  = VLr{flipInd(i)}; % flipped version
end

end