
%%%%% script to test DAD for different hyperparameters %%%%%
% script to create Fig. 3E panel (Chewie results)

monkey='mihi2D'; % 50 ms time bins
param_savename = 'optimal_parameters_mihi2D_optimize_D1';
savename='results_script_run2D_mihi_bootstrap_optimize_D1';
whichopt = 1; % optimize parameters for this dataset
whichtest = 1; % test on this dataset after model selection (in last step)
whichtrain = 1; % use dataset 1 as training kinematics (1-3)

removedir = [0,1,2,4];
whichtarg = setdiff(0:7,removedir);

%%
numDelays = [5, 10, 15, 20, 25];
numSamples = [20, 25, 30, 35, 40, 45, 50];

% fix smoothing factor and dim red method
SmoothingFac = [0, 2, 4, 6, 8];  %SmoothingFac = 8; % optimized through finding min-KL
clear M1
M1{1} = 'PCA'; 
M1{2} = 'Isomap';
M1{3} = 'FA';

numDR = length(M1);
numParams = length(numDelays)*length(numSamples)*length(SmoothingFac)*numDR;
numIter=1;

Data = prepare_superviseddata(0.05,'chewie1','mihi',[],0); % 50 ms bins (same as jango)

numS0 = 30; numD0 = 10; % set visually to create good kinematic distribution
[~,~,~,Xtr,Ytr,Ttr,~,Ntr] = removedirdata(Data,removedir,numD0,numS0);
        

%%

% search over hyperparameters
minKL = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR);
Xrec_all = cell(length(numDelays),length(numSamples),length(SmoothingFac),numDR);
Xte_all = cell(length(numDelays),length(numSamples),length(SmoothingFac),numDR);
Tte_all = cell(length(numDelays),length(numSamples),length(SmoothingFac),numDR);

count=0;
for k1=1:length(numDelays)
    numD=numDelays(k1);
    
    for k2=1:length(numSamples)
        numS=numSamples(k2);
        
        [Vel,Y1,T1,~,~,~,~,~] = removedirdata(Data,removedir,numD,numS);
 
        for i=1:length(SmoothingFac)
            sfac = SmoothingFac(i);
            
            Yte2 = downsamp_nd(Y1,SmoothingFac(i)); % temporal smoothing
            Yr = remove_constcols(Yte2);
            
            [V,Methods,~] = computeV(Yr, 2, M1);
            
            Xte_all{k1,k2,i,1}=Vel;
            Tte_all{k1,k2,i,1}=T1;
            
            for j=1:numDR
                Vcurr = V{j}(:,1:2);
                tic,
                [Vout,~, yKL, ~] = rotated_KLmin(Vcurr,Xtr,90);
                toc
                minKL(k1,k2,i,j) = min(yKL);
                Xrec_all{k1,k2,i,j}=Vout;
                display(['numD = ', int2str(numD),...
                         ', numS = ', int2str(numS), ...
                         ', winsz = ', int2str(sfac),...
                         ', Method = ', Methods{j},...
                         ', KL div = ', num2str(minKL(k1,k2,i,j),2)])
                         count=count+1;
                display(['Number iterations left = ', int2str(numParams-count)])
            end % end j
        end % end i
    end % end k2
    save(savename)
end % end k1

save(savename)

%%  Model Selection

Params.minKL = minKL;
Params.numDelays = numDelays;
Params.numSamples = numSamples;
Params.SmoothingFac = SmoothingFac;
Params.M1 = M1;
Params.Xtr = Xtr;
Params.Ttr = Ttr;
Params.monkey = 'mihi2D';

Results = model_select(Xrec_all, Xte_all, Tte_all, Params);

%% compile results

Results.Xrec_all = Xrec_all;  
Results.Xte_all = Xte_all;  
Results.Tte_all = Tte_all; 
Results.Xtr = Xtr;
Results.Ttr = Ttr;
Results.removedir = removedir;
Results.monkey = monkey;
Results.whichtest = whichtest;
Results.whichopt = whichopt;
Results.monkey = monkey;

%% save parameters (models)

save(param_savename,'Results')
save(savename)                                       
     
%% compile results, evaluation metrics, visualize

script_compileDADresults

