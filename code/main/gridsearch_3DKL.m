function Yout = gridsearch_3DKL(Xtarget,Ysource,numA,numT)

nzvar = 0.1;
dist_metric = 'KL';
Ycurr = Ysource;
finegrid = 6; % grid to search for fine-scale translation

gridsz = numA;
[xx,yy,zz] = meshgrid(-1:2/(gridsz-1):1,-1:2/(gridsz-1):1,-1:2/(gridsz-1):1);
Fmat = [xx(:),yy(:),zz(:)];

id = find(norms(Fmat')<0.1);
Fmat(id,:)=[];
Fmat = [[0 0 1]; Fmat];

if numT>1
    tvec = [ [0,0,0]; randn(numT,3)*5];
else
    tvec = [0,0,0];
end
    
if strcmp(dist_metric,'KL')
    bsz = 50;
    numsamp=5e5;
    %k0=round(size(Xtarget,2)^(1/3));
    %k1=round(size(Ysource,2)^(1/3));
    k0=5; k1=5; % fixed k0, k1 for now 
    sample_loc = sample_from_3Dgrid(bsz,numsamp);
    p_train=prob1( sample_loc , normal(Xtarget) , k0 );
end
    
dists=zeros(size(Fmat,1),numT);
for i=1:size(Fmat,1)
    an0 = Fmat(i,:);
    r = vrrotvec([0,0,1],an0);
    m = vrrotvec2mat(r);
    Yrot = Ycurr*m;
    
    %remove mean
    mnY = mean(Yrot);
    Yrot = Yrot - repmat(mnY,size(Yrot,1),1);
    
    for j=1:numT
        Yrot2 = Yrot + repmat(tvec(j,:),size(Yrot,1),1);
        %dists(i,j) = rand_eval_KL(Xtarget,Yrot2,sample_loc);
        
        if strcmp(dist_metric,'KL')
            p_rot=prob1( sample_loc , normal(Yrot2) , k1 );
            dists(i,j) = p_rot'*log(p_rot./p_train);
        else
            [~,dvec] = knnsearch(Yrot2,Xtarget);
            dists(i,j) = mean(dvec);
            %dists(i,j) = trimmean(dvec,0.1);
            %dists(i,j) = max(dvec);
        end
    end
    i,
%     close all, 
%     figure,
%     plot3(Yrot(:,1),Yrot(:,2),Yrot(:,3),'o')
%     hold on, plot3(Xtarget(:,1),Xtarget(:,2),Xtarget(:,3),'rx'),
%     title(['KL dist = ', num2str(dists(i,j),2)])
%     %pause,
end

%% select best angle (rotation)
[val,id] = min(dists');
[~,idd] = min(val);

if numT>1
    tID = id(idd);
    [~,angID] = min(dists(:,tID));
else
    angID = id;
end

an0 = Fmat(angID,:);
r = vrrotvec([0,0,1],an0);
m = vrrotvec2mat(r);
Yrot = Ycurr*m;
Ycurr = Yrot;

if numT>1
    tcurr = tvec(tID,:);
else
    tcurr = [0 0 0];
end

%% find translation
tvec2 = randn(finegrid^3,3)*nzvar+repmat(tcurr,finegrid^3,1);

dists2= zeros(size(tvec,1),1);
for j=1:size(tvec2,1)
    Yrot2 = Ycurr + repmat(tvec2(j,:),size(Ycurr,1),1);
    [~,dvec] = knnsearch(Xtarget,Yrot2);
    dists2(j) = mean(dvec);
end

[~,id3] = min(dists2);
Yout = Yrot + repmat(tvec2(id3,:),size(Yrot,1),1);
%Ycurr = Yout;

%% final rotation (fine alignment)
% numsamp = 100;
% dists2 = zeros(numsamp,1);
% avecs = repmat(an0',1,numsamp) + randn(3,numsamp)*0.005;
% for i=1:numsamp
%     r = vrrotvec([0,0,1],avecs(:,i));
%     m = vrrotvec2mat(r);
%     Yrot = Ycurr*m;
%     
%     %remove mean
%     mnY = mean(Yrot);
%     Yrot = Yrot - repmat(mnY,size(Yrot,1),1);
%     
%     p_rot=prob1( sample_loc , normal(Yrot) , k1 );
%     dists2(i) = p_rot'*log(p_rot./p_train);
% end
% 
% [~,idd] = min(dists2);
% r = vrrotvec([0,0,1],avecs(:,idd));
% m = vrrotvec2mat(r);
% Yrot = Ycurr*m;
% mnY = mean(Yrot);
% Yout = Yrot - repmat(mnY,size(Yrot,1),1);






end


