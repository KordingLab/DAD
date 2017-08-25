
%%%%% script to test DAD for different hyperparameters %%%%%
% script to create Fig. 3E panel (Chewie results)

monkey='chewie'; % 10 ms time bins
param_savename = 'optimal_parameters_chewie_optimize_D3_50ms_2';
savename='results_script_run2D_chewie_bootstrap_optimize_D3_50ms_2';
whichopt = 3; % optimize parameters for this dataset
whichtest = 3; % test on this dataset after model selection (in last step)
whichtrain = 1; % use dataset 1 as training kinematics (1-3)
dsamp = 5; % 50 ms time bins

removedir = [0,1,2,4];
numS0 = 30; numD0 = 20; 
whichtarg = setdiff(0:7,removedir);

if whichtrain==1
    trfile = '~/Documents/repos/DAD/data/Chewie/Chewie_CO_VR_2016_10_06.mat';       
elseif whichtrain==2
    trfile = '~/Documents/repos/DAD/data/Chewie/Chewie_CO_FF_2016_10_07.mat';
elseif whichtrain==3
    trfile = '~/Documents/repos/DAD/data/Chewie/Chewie_CO_FF_2016_10_11.mat';
end

if whichtest==1
    tefile = '~/Documents/repos/DAD/data/Chewie/Chewie_CO_VR_2016_10_06.mat';       
elseif whichtest==2
    tefile = '~/Documents/repos/DAD/data/Chewie/Chewie_CO_FF_2016_10_07.mat';
elseif whichtest==3
    tefile = '~/Documents/repos/DAD/data/Chewie/Chewie_CO_FF_2016_10_11.mat';
end

load(trfile)
[Ytr,~,Ttr,~,Xtr,~,~,~] = compile_reaching_data(trial_data,numD0,numS0,'go',whichtarg,dsamp); 

%%
numDelays = [5, 10, 15, 20, 25];
numSamples = [10, 20, 30, 40, 50];

%numDelays=20;
%numSamples=30;

% fix smoothing factor and dim red method
SmoothingFac = [0, 2, 4, 6];  %SmoothingFac = 8; % optimized through finding min-KL
clear M1
M1{1} = 'PCA'; 
M1{2} = 'Isomap';
M1{3} = 'FA';

numDR = length(M1);
numParams = length(numDelays)*length(numSamples)*length(SmoothingFac)*numDR;
numIter=1;

% search over hyperparameters
minKL = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR);
Xrec_all = cell(length(numDelays),length(numSamples),length(SmoothingFac),numDR);
Xte_all = cell(length(numDelays),length(numSamples),length(SmoothingFac),numDR);
Tte_all = cell(length(numDelays),length(numSamples),length(SmoothingFac),numDR);
Yr_all = cell(length(numDelays),length(numSamples),length(SmoothingFac),numDR);

%%
load(tefile) % load file for test data
count=0;
for k1=1:length(numDelays)
    numD=numDelays(k1);
    
    for k2=1:length(numSamples)
        numS=numSamples(k2);
        
        % found 300-500 ms was optimal for numD to minimize KL divergence (unsupervised)
        [Y1,~,T1,~,Vel,~,~,~] = compile_reaching_data(trial_data,numD,numS,'go',whichtarg,dsamp);
        
        for i=1:length(SmoothingFac)
            sfac = SmoothingFac(i);
            Yr = smooth_neuraldata(Y1,sfac);
            [V,Methods,~] = computeV(Yr, 3,M1);
            
            Yr_all{k1,k2,i,1} = Yr;
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
Params.monkey = 'chewie';

Results = model_select(Xrec_all, Xte_all, Tte_all, Params);
Results.Xrec_all = Xrec_all;  
Results.Xte_all = Xte_all;  
Results.Tte_all = Tte_all; 
Results.Xtr = Xtr;
Results.Ttr = Ttr;
Results.removedir = removedir;
Results.monkey = monkey;
Results.whichtest = whichtest;
Results.whichopt = whichopt;
Results.dsamp = dsamp;

%%

save(param_savename,'Results')
save(savename)                                       
     
%%

script_compileDADresults

