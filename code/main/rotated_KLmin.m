function [Vout,Vflip,y, flipInd] = rotated_KLmin(V,Xtr,numA)
k=3;
if size(V,2) ~= size(Xtr)
    error('target and test set are not same dimension!')
end

angVals = linspace(0,360,numA);
cosg = cosd(angVals);
sing  = sind(angVals);

VLr = cell(2*numA,1);
y = zeros(2*numA,1);
for p=1:2*numA
    pm = mod(p-1,numA)+1;
    ps = 2*floor((p-1)/numA)-1;
    rm = [ps,0;0,1]*[cosg(pm),-sing(pm);sing(pm),cosg(pm)];
    
    ys=zeros(20,1);
    count=1;
    VLrs = cell(20,1);
    sx = 0.2+ 0.2*[1:7];
    sy = 0.2+ 0.2*[1:7];
    for s1 = 1:length(sx)
        for s2 = 1:length(sy)
            smat = [0.4*sx(s1),0;0,0.2*sy(s2)];
            VLrs{count} = normal( V * rm * smat);
            ys(count) = eval_KL(VLrs{count},Xtr,k);
            count = count+1;
        end
    end
    [y(p),idd] = min(ys);
    VLr{p} = VLrs{idd};
    
%     figure, plot(Xtr(:,1),Xtr(:,2),'rx'), hold on,
%     plot(VLr{p}(:,1),VLr{p}(:,2),'o')
%     title(['Ang = ' int2str(angVals(pm)), ' Flip sign = ', ...
%         int2str(ps), ' KL = ', num2str(y(p),3),])
%   
%     pause,
    p,
end

[~,minid] = min(y);
Vout = VLr{minid};

[pks,KLid] = findpeaks(-y);
[~,id] = sort(pks,'descend');
for i=1:5
    flipInd(i) = KLid(id(i));
    Vflip{i}  = VLr{flipInd(i)}; % flipped version
end


end