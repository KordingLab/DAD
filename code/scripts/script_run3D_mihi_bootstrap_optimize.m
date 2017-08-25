%%

param_savename = 'optimal_parameters_mihi_optimize_D1_1';
savename= 'results_script_run3D_mihi_bootstrap_optimize_D1_1';

monkey = 'mihi';
numS = 50; % use all of samples
numD = 0; % no delay in sampling from go cue
removedir = [0,1,2,6];
numbootsamp = 500; % number of data points to use in bootstrap sample

% 3d search parameters
numT = 1; % if > 1, then search over 3d translations
k = 3; % 3D search
check2D = 1; % if 1, then check 2D projections in addn to output of 3D search (select min KL solution)
nzvar = 0.3; % add some noise to data to avoid ill-conditioned data covariance (for FA)
numang_steps = 6; % decrease to search over fewer angles in 3D search (search size = sz^3)
Iter = 1; % number of times to resample (bootstrap), if 1, dont sample
    
%% Parameters to optimize

SmoothingFac = [0, 2, 4, 6]; % temporal smoothing of firing rates (sfac=0)
binsz = [0.18, 0.2, 0.22, 0.24];
M1{1} = 'FA'; % dimensionality reduction technique
%M1{2} = 'Isomap'; % dimensionality reduction technique
%M1{3} = 'PCA'; % dimensionality reduction technique

minKL = zeros(length(binsz),length(SmoothingFac),length(M1),Iter);
minKL3D = zeros(length(binsz),length(SmoothingFac),length(M1),Iter);
yKLM = cell(length(binsz),length(SmoothingFac),length(M1),Iter);
Xrec_all = cell(length(binsz),length(SmoothingFac),length(M1),Iter);
Tte_all = cell(length(binsz),length(SmoothingFac));
Xte_all = cell(length(binsz),length(SmoothingFac));
Yr_all = cell(length(binsz),length(SmoothingFac));

numiter=numel(minKL);
display(['Number of iterations = ',int2str(numiter)]);


%% Run DAD for all possible models

count=0;
for ii=1:length(binsz)
    tstart = tic;
    Data = prepare_superviseddata(binsz(ii),'chewie1','mihi',[],0);
    
    for jj=1:length(SmoothingFac)
        [Xte,Yte,Tte,Xtr,Ytr,Ttr,Nte,Ntr] = removedirdata(Data,removedir,numD,numS);
        Yte2 = downsamp_nd(Yte,SmoothingFac(jj)); % temporal smoothing
        Yr = remove_constcols(Yte2);
        
        Yr_all{ii,jj,1,1} = Yr;
        Yr = Yr + nzvar*randn(size(Yr));
        
        for kk=1:length(M1)
            drmethod{1} = M1{kk};
            [V,Methods,~] = computeV(Yr, k, drmethod);
            Vcurr = V{1}(:,1:k); 
            Xn = normal(mapX3D(Xtr));
            
            if Iter>1
                for mm = 1:Iter
                    tmpidx=randi(size(Vcurr,1),min(numbootsamp,size(Vcurr,1)),1);
                    Vnew=Vcurr(tmpidx,:);
                    [~,~,~,yKL,minKL3D(ii,jj,kk,mm)] = DAD_3Dsearch(Xn,Vnew,numang_steps,numT,check2D);
                    minKL(ii,jj,kk,mm) = min(yKL);
                    yKLM{ii,jj,kk,mm} = yKL;
                end            
                [xrec,vout,~,yKL,minKL3D(ii,jj,kk,mm)] = DAD_3Dsearch(Xn,Vcurr,numang_steps,numT,check2D);       
            else
                [xrec,~,~,yKL,minKL3D(ii,jj,kk)] = DAD_3Dsearch(Xn,Vcurr,numang_steps,numT,check2D);
                 minKL(ii,jj,kk) = min(yKL);
                 yKLM{ii,jj,kk} = yKL; 
            end
            
            Xrec_all{ii,jj,kk} = xrec;
            display([' KL = ', num2str(minKL(ii,jj,kk),2), ' KL 3D = ', num2str(minKL3D(ii,jj,kk),2)])
            
            Tte_all{ii,jj,kk} = Tte; 
            Xte_all{ii,jj,kk} = Xte;
            count=count+1;
            display(['Number iterations remaining = ',int2str(numiter-count)])
        end
    end
    telapsed = toc(tstart);
    display(['Minutes remaining = ',int2str(telapsed*(length(binsz)-ii)/60)])

    save(savename)
    
end

if Iter>1
    minKL0 = minKL;
    minKL=median(minKL0,4);
else
    minKL0 = minKL;
end

%% Model select

Params.minKL = minKL;
Params.binsz = binsz;
Params.SmoothingFac = SmoothingFac;
Params.M1 = M1;
Params.Xtr = Xtr;
Params.Ttr = Ttr;
Params.monkey = 'mihi';

Results = model_select(Xrec_all, Xte_all, Tte_all, Params);

%%
Results.Xrec_all = Xrec_all;  
Results.Xte_all = Xte_all;  
Results.Tte_all = Tte_all;
Results.Yr_all = Yr_all;
Results.Xtr = Xtr;
Results.Ttr = Ttr;
Results.removedir = removedir;
Results.monkey = Params.monkey;
Results.whichtest = 1;
Results.whichopt = 1;
Results.whichtrain = 'chewie';

%% Save to mat files

save(param_savename,'Results','Params')
save(savename)                                       

%% Visualize and compare with supervised methods

script_compileDADresults


%removedir = [0, 1, 2];
%removedir = [0, 3, 7]; %min KL solution = R2 = 0.4978, max = 0.5142

