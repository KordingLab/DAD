function Yout = gridsearch_3DKL(Xtarget,Ysource,numA,numT)

% parameters - fixed for now
meanwt = 0.7; % scale mean of samples of KL-div (make smaller to reduce search time)
KL_thr = 5; % initial threshold to determine whether to sample translations
nzvar1 = 0.5; % variance for translation sampling
nzvar2 = 0.5; % variance for finding translation at the end (after finding opt angle)
finegrid = 10; % grid to search for fine-scale translation at end
bsz = 50; % grid to evaluate KL divergence over 
numsamp = 5e5; % number of samples to eval KL for alignment
k0=5; k1=5; % fixed k0, k1 for now - used to compute NN density estimate 

gridsz = numA; 
[xx,yy,zz] = meshgrid(-1:2/(gridsz-1):1,-1:2/(gridsz-1):1,-1:2/(gridsz-1):1);
Fmat = [xx(:),yy(:),zz(:)];

id = find(norms(Fmat')<0.1);
Fmat(id,:)=[];
Fmat = [[0 0 1]; Fmat];

if numT>1
    tvec = [ [0,0,0]; randn(numT,3)*nzvar1];
else
    tvec = [0,0,0];
end

% draw random samples from a 3D grid to evaluate KL divergence over
sample_loc = sample_from_3Dgrid(bsz,numsamp);
p_train=prob1( sample_loc , normal(Xtarget) , k0 );
    
dists1=ones(size(Fmat,1),numT)*100;
for i=1:size(Fmat,1)
    an0 = Fmat(i,:);
    Yrot = normal(rotate_data(Ysource,an0));
    p_rot=prob1( sample_loc , normal(Yrot) , k1 );
    dists1(i,1) = p_rot'*log(p_rot./p_train);
    
    if (dists1(i,1)<KL_thr)&&(numT>1)
        for j=2:numT
            Yrot2 = Yrot + repmat(tvec(j,:),size(Yrot,1),1);
            p_rot=prob1( sample_loc , Yrot2 , k1 );
            dists1(i,j) = p_rot'*log(p_rot./p_train);
        end
        
        % heuristic to do smaller search when you find a good rotation 
        KL_thr = min(KL_thr,mean(dists1(find(dists1~=100)))*meanwt),
        i,
    end
    
    display(' ... ')
    
%     if min(dists1(i,:))<KL_thr
%         close all, 
%         figure,
%         plot3(Yrot(:,1),Yrot(:,2),Yrot(:,3),'o')
%         hold on, plot3(Xtarget(:,1),Xtarget(:,2),Xtarget(:,3),'rx'),
%         title(['KL div = ', num2str(min(dists1(i,:)),2), ', Iter = ', int2str(i)]),
%         pause,
%     end
end

%% select best angle (rotation)
[val,id] = min(dists1');
[~,idd] = min(val);

if numT>1
    tID = id(idd);
    [~,angID] = min(dists1(:,tID));
else
    angID = id;
end

an0 = Fmat(angID,:);
Ycurr = rotate_data(Ysource,an0);

if numT>1
    tcurr = tvec(tID,:);
else
    tcurr = [0 0 0];
end

%% Final translation
tvec2 = randn(finegrid^3,3)*nzvar2+repmat(tcurr,finegrid^3,1);

dists2= zeros(size(tvec,1),1);
for j=1:size(tvec2,1)
    Yrot2 = Ycurr + repmat(tvec2(j,:),size(Ycurr,1),1);
    [~,dvec] = knnsearch(Xtarget,Yrot2);
    dists2(j) = mean(dvec);
end

[~,id3] = min(dists2);
Yout = Ycurr + repmat(tvec2(id3,:),size(Ycurr,1),1);

end % end function


