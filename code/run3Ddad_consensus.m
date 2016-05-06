function [Xrec,Fmat] = run3Ddad_consensus(Yr,Xtr,Xgt,M1,numsol,Nrsamp,numInit)
% Xtr = 2 x T (training kinematics data)
% Xte = 2 x T (test)
method='reg';
if nargin<6
    Nrsamp = 10;
end

T = size(Yr,1);
X3D = mapX3D(Xtr); % augment training kinematics
           

% run 3D DAD Nrsamp times (different bootstrap samples)
for i=1:Nrsamp
    Idx(:,i) = randi(T,T,1);
    idx = Idx(:,i);
    Ynew = Yr(idx,:);
    
    idd = find(sum(abs(diff(Ynew)))<0.001);
    Ynew(:,idd)=[];
    [Vr,Methods] = computeV(Ynew,3,M1);
    
    if ~isempty(Xgt)
        Xnew = Xgt(idx,:);
    else
        Xnew = [];
    end
    
    [~, Res] = run3Ddad(X3D,Vr,Xnew,360,Methods,numsol,numInit); % grid search every 2 degrees (A = 180 angles)
    vtmp = Res.Vicp(:,1:2);
    vtmp = vtmp(:);
    vtmp = [vtmp, Res.Xrec(:)];
    
    if numsol>0
        for j=3:length(Res.Vflip)+2
            vtmp(:,j) = Res.Vflip{j-2}(:);
        end
    end
    
    Fmat(:,:,i) = vtmp;
Nrsamp-i
end

for i=1:size(Fmat,2)
    for j=1:size(Fmat,3)
        ftmp(:,:,i,j) = reshape(Fmat(:,i,j),size(Fmat,1)/2,2);
    end
end % end reshaping

px = zeros(size(ftmp,3)*size(ftmp,4),size(ftmp,1));
for i=1:size(ftmp,1)
    xt = reshape(squeeze(ftmp(i,:,:,:)),size(ftmp,2),size(ftmp,3)*size(ftmp,4));
    px(:,i) = prob1(xt',xt',3);
end

scores = sum(px');
[~,idd] = max(scores);
[rr,cc] = ind2sub([size(ftmp,3),size(ftmp,4)],idd);

Xrec = ftmp(:,:,rr,cc);


%%
% if strcmp(method,'scores')
% % compute histograms
% numbins = 10;
% px = zeros(numbins,T);
% py = zeros(numbins,T);
% binsx = zeros(numbins,T);
% binsy = zeros(numbins,T);
% for i=1:T
%     [whichr,whichc] = find(Idx==i);
%     for j=1:length(whichr)
%         Vals{i,j} = ftmp(whichr(j),:,:,whichc(j)); 
%     end
% end
%     
%     [N,binsx(:,i)] = hist(tmpval(1,:),numbins);
%     px(:,i) = N./sum(N);
%     [N,binsy(:,i)] = hist(tmpval(2,:),numbins);
%     py(:,i) = N./sum(N);
% %end % end for loop over time points
% 
% % now compute the scores for each prediction
%     scores = zeros(size(ftmp,3),size(ftmp,3));
%     for i=1:size(ftmp,3)
%         for j=1:size(ftmp,4)
%             s1 = zeros(size(ftmp,1),1);
%             for k = 1:size(ftmp,1)
%                 [~,id] = min(abs(binsx(:,k)-ftmp(k,1,i,j)));
%                 tmppx = log(px(id,k)+0.01);
% 
%                 [~,id] = min(abs(binsy(:,k)-ftmp(k,2,i,j)));
%                 tmppy = log(py(id,k)+0.01);
% 
%                 s1(k) = tmppx+tmppy;
%             end
%             scores(i,j) = sum(s1);
%         end
%     end
% 
%     [~,id] = max(sum(scores));
%     [~,id2] = max(scores(:,id));
%     Xrec = ftmp(:,:,id2,id);
% end

%[rr,cc] = ind2sub([size(ftmp,3),size(ftmp,4)],id2);
%Xrec = ftmp(:,:,rr,cc);

end % end main function