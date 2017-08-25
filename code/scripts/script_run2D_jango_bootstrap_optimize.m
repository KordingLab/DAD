%%%%% script to test DAD for different hyperparameters %%%%%
% script to create Fig. 3E panel (Chewie results)

monkey = 'jango';
param_savename = 'optimal_parameters_jango_opt_d3_test';
savename='results_script_run2D_jango_bootstrap_opt_d3_test';
train_savename = 'jango_training_d3_test';
whichopt = 3; % optimize parameters for this dataset
whichtrain = 1; % train on this dataset
whichtest = 3; % test on this dataset after model selection

removedir = [0,1,2,4];
numD0 = 5; numS0 = 8;  % for training kinematics dataset
whichtarg = setdiff(0:7,removedir);

if whichtrain==1
    whichdata='0801';
elseif whichtrain==2
    whichdata='0807';
elseif whichtrain==3
    whichdata='0819';
else
    whichdata='0901';
end

%%%%% Training Data
tfilenm=['~/Documents/repos/DAD/data/Jango/binnedData_',whichdata,'.mat'];
[~,Ttr,Xtr] = compile_jango_neuraldata(whichtarg,numD0,numS0,tfilenm);        
save(train_savename,'Xtr','Ttr')

if whichopt==1
    whichdata='0801';
elseif whichopt==2
    whichdata='0807';
elseif whichopt==3
    whichdata='0819';
else
    whichdata='0901';
end

%%
% define hyper parameters
numDelays = 0:8;
numSamples = 5:12;
SmoothingFac = [0, 2, 4];
clear M1,
%M1{1} = 'PCA'; 
M1{1} = 'Isomap';
%M1{2} = 'FA';

numDR = length(M1);
numParams = length(numDelays)*length(numSamples)*length(SmoothingFac)*numDR;
numIter=1;

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
        
        % get data
        whichfile = ['~/Documents/repos/DAD/data/Jango/binnedData_',whichdata,'.mat'];
        [Y1,T1,Vel] = compile_jango_neuraldata(whichtarg,numD,numS,whichfile);

        for i=1:length(SmoothingFac)
            
            % smoothing
            sfac = SmoothingFac(i);
            Yr = smooth_neuraldata(Y1,sfac);
            
            % dimensionality reduction (for all dr methods)
            [V,Methods,~] = computeV(Yr, 3, M1);

            % record X, T for this expt
            Xte_all{k1,k2,i,1}=Vel;
            Tte_all{k1,k2,i,1}=T1;
            
            for j=1:numDR
                
                % 2D alignment
                Vcurr = V{j}(:,1:2);
                [Vout,~, yKL, ~] = rotated_KLmin(Vcurr,Xtr(:,1:2),90);
                
                % record KL etc
                minKL(k1,k2,i,j) = min(yKL);
                Xrec_all{k1,k2,i,j}=Vout;
                display(['numD = ', int2str(numD),...
                         ', numS = ', int2str(numS), ...
                         ', Smoothing = ', int2str(sfac),...
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
Params.monkey = monkey;
Params.Xtr = Xtr;
Params.Ttr = Ttr;

Results = model_select(Xrec_all, Xte_all, Tte_all, Params);

%%
Results.Xrec_all = Xrec_all;  
Results.Xte_all = Xte_all;  
Results.Tte_all = Tte_all;  
Results.Xtr = Xtr;
Results.Ttr = Ttr;
Results.removedir = removedir;
Results.monkey = monkey;
Results.whichtest = whichtest;
Results.whichopt = whichopt;

%%

save(param_savename,'Results')
save(savename)                                       
     
%%

script_compileDADresults % make sure to comment out param_savename

