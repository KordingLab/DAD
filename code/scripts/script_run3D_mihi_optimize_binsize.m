%%%% Fixed Parameters %%%%
numS = 40; % use all of samples
numD = 0; % no delay in sampling from go cue
k = 3; % 3D search
check2D = 1; % if 1, then check 2D projections in addn to output of 3D search (select min KL solution)
nzvar = 0.3; % add some noise to data to avoid ill-conditioned data covariance (for FA)
numang_steps = 8; % decrease to search over fewer angles in 3D search
%removedir = [1, 3, 7];
removedir = [0, 3, 7]; %min KL solution = R2 = 0.4978, max = 0.5142

%% Parameters to optimize
sfac = [0, 1, 2, 3, 4, 5, 6]; % temporal smoothing of firing rates (sfac=0)
binsz = [0.18, 0.19, 0.2, 0.21, 0.22, 0.23, 0.24];
M1{1} = 'FA'; % dimensionality reduction technique
%M1{2} = 'Isomap'; % dimensionality reduction technique
%M1{1} = 'PCA'; % dimensionality reduction technique

R2_vals = zeros(length(binsz),length(sfac),length(M1));
R2_vals3D = zeros(length(binsz),length(sfac),length(M1));
minKL = zeros(length(binsz),length(sfac),length(M1));
minKL3D = zeros(length(binsz),length(sfac),length(M1));
yKLM = cell(length(binsz),length(sfac),length(M1));
Xrec_all = cell(length(binsz),length(sfac),length(M1));
Tte_all = cell(length(binsz),length(sfac),length(M1));
Xte_all = cell(length(binsz),length(sfac),length(M1));

numiter=numel(R2_vals);
display(['Number of iterations = ',int2str(numiter)]);

count=0;
for ii=1:length(binsz)
    tstart = tic;
    Data = prepare_superviseddata(binsz(ii),'chewie1','mihi',[],0);
    
    for jj=1:length(sfac)
        [Xte,Yte,Tte,Xtr,Ytr,Ttr,Nte,Ntr] = removedirdata(Data,removedir,numS,numD);
        Yte2 = downsamp_nd(Yte,sfac(jj)); % temporal smoothing
        Yr = remove_constcols(Yte2);
        Yr = Yr + nzvar*randn(size(Yr));
        
        for kk=1:length(M1)
            drmethod{1} = M1{kk};
            [V,Methods,~] = computeV(Yr, k, drmethod);
            Vcurr = V{1}(:,1:k); 
            Xn = normal(mapX3D(Xtr));
           
            [xrec,vout,~,yKL,minKL3D(ii,jj,kk)] = DAD_3Dsearch(Xn,Vcurr,numang_steps,0,check2D);
        
            R2_vals(ii,jj,kk) = evalR2(Xte(:,1:2),xrec);
            R2_vals3D(ii,jj,kk) = evalR2(mapX3D(Xte),vout);
            minKL(ii,jj,kk) = min(yKL);
            yKLM{ii,jj,kk} = yKL;
            display(['R2 = ', num2str(R2_vals(ii,jj,kk),3), ' Ts = ', num2str(binsz(ii),2), ...
                     ' KL = ', num2str(minKL(ii,jj,kk),2), ' KL 3D = ', num2str(minKL3D(ii,jj,kk),2)])
            Xrec_all{ii,jj,kk} = xrec;
            Tte_all{ii,jj,kk} = Tte; 
            Xte_all{ii,jj,kk} = Xte;
            count=count+1;
            display(['Number iterations remaining = ',int2str(numiter-count)])
        end
    end
    telapsed = toc(tstart);
    display(['Amount of time remaining = ',int2str(telapsed*(length(binsz)-ii))])
end

%%%% minimum KL solution
[~,idd]=min(minKL(:));
[imin,jmin,kmin] = ind2sub(size(R2_vals),idd);
BinSize_min = binsz(imin);
SmoothFac_min = sfac(jmin);
DRMethod_min = M1{kmin};
R2val_KLmin = R2_vals(imin,jmin,kmin);

%%%%%% SMoothed KL solution
Vals = smooth(minKL(:));
[~,id] = min(Vals);
tmp1=id-2:id+2; 
[~,idd] = min(minKL(tmp1)); 
minID = tmp1(idd);

[i1,i2,i3] = ind2sub(size(R2_vals),minID);
binsz_smooth = binsz(i1);
sfac_smooth = sfac(i2);
drmethod_smooth = M1(i3);
R2val_smooth = R2_vals(i1,i2,i3); % final R2 for best solution (min KL)


save results_script_run3D_mihi_optimize_binsize_june_30_2017

%%%% manual method
%[Xrec,R2val_final,ii,jj,kk] = select_model_manually(minKL,Xrec_all,Xte_all,Tte_all,10);
%BinSize_final = binsz(ii);
%SmoothFac_final = sfac(jj);
%DRMethod_final = M1{kk};



