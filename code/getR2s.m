%% For computing R2s, CI and p-values for Figure 4a, and testing the assumption of independence for the use of bootstrap
clc, clear

%% Example output:
%load supervised data...
%load withinDAD data...
%-------------------------
%prepare data...
%-------------------------
%Checking for temporal correlation in the residuals...
%SUP: r = -0.004, p-value = 0.91101549
%DAD: r = 0.067, p-value = 0.06444398
%AVE: r = -0.012, p-value = 0.74907277
%-------------------------
%define functions...
%-------------------------
%
%computing R2s...

%...Supervised data model: 0.657, with 95-percent CI=[0.609, 0.700]
%...............DAD model: 0.624, with 95-percent CI=[0.584, 0.662]
%...........Average model: 0.679, with 95-percent CI=[0.638, 0.716]
%-------------------------
%
%differences in R2s...
%
%........Supervised - DAD: 0.034, with 95-percent CI=[-0.002, 0.068]
%...........Average - Sup: 0.022, with 95-percent CI=[0.005, 0.040]
%...........Average - DAD: 0.056, with 95-percent CI=[0.038, 0.073]
%
%-------------------------
%getting the p-values
%........Supervised - DAD for alpha = 0.056: CI=[-0.00069, 0.06779]
%........Supervised - DAD for alpha = 0.057: CI=[-0.00103, 0.06692]
%........Supervised - DAD for alpha = 0.058: CI=[0.00015, 0.06659]
%
%...........Average - Sup for alpha = 0.015: CI=[0.00043, 0.04542]
%...........Average - Sup for alpha = 0.014: CI=[0.00050, 0.04564]
%...........Average - Sup for alpha = 0.013: CI=[0.00044, 0.04627]
%
%...........Average - DAD for alpha = 0.001: CI=[0.02844, 0.08623]


%% load data

%load supervised results
fprintf('load supervised data...\n')
load('./data_final/ResMihiSupWithFeb11.mat')

withinDAD = 1; %set to zero to get the CI on across-DAD

if withinDAD    
    %load within-DAD results
    fprintf('load withinDAD data...\n')
    load('./data_final/ResMihiFAWithFeb11.mat')
else
    %load across-DAD results
    fprintf('load acrossDAD data...\n')
    load('./data_final/ResMihiFAAcc23rdFeb13.mat')
end

fprintf('-------------------------\n')

%% arrange data
fprintf('prepare data...\n')

weight_DAD=0.5; % weight of within-DAD model in the model average with the supervised model

% ground truth
DATA_SUP(:,1:2) = normal(Xte);          %true kinematics on test data 380 vx,vy data points of SupModel
DATA_DAD(:,1:2) = normal(Xte);          %true kinematics on test data 380 vx,vy data points of SupModel
DATA_AVE(:,1:2) = normal(Xte);   

% predicted
Xhat = XhatN;
DATA_SUP(:,3:4) = normal(Xhat);     %predicted kinematics on test data of supervized model
DATA_DAD(:,3:4) = YrKLMat{1};       %predicted kinematics on test data of DAD
DATA_AVE(:,3:4) = (weight_DAD*YrKLMat{1}+(1-weight_DAD)*normal(Xhat)); %predicted kinematics on test data of DAD

DATA_SUPvsDAD = [normal(Xte) normal(Xhat) normal(Xte), YrKLMat{1}]; %is Sup better than withinDAD?
DATA_AVEvsSUP = [normal(Xte) (weight_DAD*YrKLMat{1}+(1-weight_DAD)*normal(Xhat)) normal(Xte), normal(Xhat)]; %is Average better than Supervised?
DATA_AVEvsDAD = [normal(Xte) (weight_DAD*YrKLMat{1}+(1-weight_DAD)*normal(Xhat)) normal(Xte), YrKLMat{1}]; %is Average better than withinDAD?

fprintf('-------------------------\n')


%% Test for temporal correlation in the residues
fprintf('Checking for temporal correlation in the residuals...\n')

DATA_SUPRES = DATA_SUP(:,1:2)-DATA_SUP(:,3:4);
[a,b]=corrcoef(DATA_SUPRES(1:end-1,1:2),DATA_SUPRES(1+1:end,1:2)); 
fprintf('SUP: r = %2.3f, p-value = %2.8f\n', a(2), b(2))

DATA_DADRES = DATA_DAD(:,1:2)-DATA_DAD(:,3:4);
[a,b]=corrcoef(DATA_DADRES(1:end-1,1:2),DATA_DADRES(1+1:end,1:2)); 
fprintf('DAD: r = %2.3f, p-value = %2.8f\n', a(2), b(2))

DATA_AVERES = DATA_AVE(:,1:2)-DATA_AVE(:,3:4);
[a,b]=corrcoef(DATA_AVERES(1:end-1,1:2),DATA_AVERES(1+1:end,1:2)); 
fprintf('AVE: r = %2.3f, p-value = %2.8f\n', a(2), b(2))

fprintf('-------------------------\n')
%% define functions to compute R2 and difference of R2s
fprintf('define functions...\n')

R2 = @(x)(1-(sum(sum((x(:,1:2)-x(:,3:4)).^2)))./sum(sum((x(:,1:2)-repmat(mean(x(:,1:2)),size(x,1),1)).^2)));
diffR2 = @(x)(R2(x(:,1:4))-R2(x(:,5:8)));

fprintf('-------------------------\n')
%% Compute R2s
fprintf('\ncomputing R2s...\n\n')
%confidence interval (100*(1-alpha)% confidence interval)
alpha = 0.05; %significance level;

fprintf('...Supervised data model:')
r2_SUP = R2(DATA_SUP);
r2_CI_SUP = bootci(9999,{R2,DATA_SUP},'alpha',0.05);
fprintf(' %2.3f, with 95-percent CI=[%2.3f, %2.3f]\n',r2_SUP,r2_CI_SUP(1),r2_CI_SUP(2))

fprintf('...............DAD model:')
r2_DAD = R2(DATA_DAD);
r2_CI_DAD = bootci(9999,{R2,DATA_DAD},'alpha',0.05);
fprintf(' %2.3f, with 95-percent CI=[%2.3f, %2.3f]\n',r2_DAD,r2_CI_DAD(1),r2_CI_DAD(2))

fprintf('...........Average model:')
r2_AVE = R2(DATA_AVE);
r2_CI_AVE = bootci(9999,{R2,DATA_AVE},'alpha',0.05);
fprintf(' %2.3f, with 95-percent CI=[%2.3f, %2.3f]\n',r2_AVE,r2_CI_AVE(1),r2_CI_AVE(2))

fprintf('-------------------------\n')
%% Compute difference in R2s
fprintf('\ndifferences in R2s...\n\n')

fprintf('........Supervised - DAD:')
diff_r2_SUPvsDAD = diffR2(DATA_SUPvsDAD);
diff_r2_CI_SUPvsDAD = bootci(9999,{diffR2,DATA_SUPvsDAD},'alpha',0.05);
fprintf(' %2.3f, with 95-percent CI=[%2.3f, %2.3f]\n',diff_r2_SUPvsDAD,diff_r2_CI_SUPvsDAD(1),diff_r2_CI_SUPvsDAD(2))

fprintf('...........Average - Sup:')
diff_r2_AVEvsSUP = diffR2(DATA_AVEvsSUP);
diff_r2_CI_AVEvsSUP = bootci(9999,{diffR2,DATA_AVEvsSUP},'alpha',0.05);
fprintf(' %2.3f, with 95-percent CI=[%2.3f, %2.3f]\n',diff_r2_AVEvsSUP,diff_r2_CI_AVEvsSUP(1),diff_r2_CI_AVEvsSUP(2))

fprintf('...........Average - DAD:')
diff_r2_AVEvsDAD = diffR2(DATA_AVEvsDAD);
diff_r2_CI_AVEvsDAD = bootci(9999,{diffR2,DATA_AVEvsDAD},'alpha',0.05);
fprintf(' %2.3f, with 95-percent CI=[%2.3f, %2.3f]\n',diff_r2_AVEvsDAD,diff_r2_CI_AVEvsDAD(1),diff_r2_CI_AVEvsDAD(2))

%% p-values
fprintf('\n-------------------------\n')

fprintf('getting the p-values\n')

alpha = 0.056;
fprintf('........Supervised - DAD for alpha = %2.3f:', alpha)
diff_r2_CI_SUPvsDAD = bootci(9999,{diffR2,DATA_SUPvsDAD},'alpha',alpha);
fprintf(' CI=[%2.5f, %2.5f]\n',diff_r2_CI_SUPvsDAD(1),diff_r2_CI_SUPvsDAD(2))

alpha = 0.057;
fprintf('........Supervised - DAD for alpha = %2.3f:', alpha)
diff_r2_CI_SUPvsDAD = bootci(9999,{diffR2,DATA_SUPvsDAD},'alpha',alpha);
fprintf(' CI=[%2.5f, %2.5f]\n',diff_r2_CI_SUPvsDAD(1),diff_r2_CI_SUPvsDAD(2))

alpha = 0.058;
fprintf('........Supervised - DAD for alpha = %2.3f:', alpha)
diff_r2_CI_SUPvsDAD = bootci(9999,{diffR2,DATA_SUPvsDAD},'alpha',alpha);
fprintf(' CI=[%2.5f, %2.5f]\n',diff_r2_CI_SUPvsDAD(1),diff_r2_CI_SUPvsDAD(2))


%%%%%%%%%%%%%%%%%
fprintf('\n')

alpha = 0.015;
fprintf('...........Average - Sup for alpha = %2.3f:', alpha)
diff_r2_CI_AVEvsSUP = bootci(9999,{diffR2,DATA_AVEvsSUP},'alpha',alpha);
fprintf(' CI=[%2.5f, %2.5f]\n',diff_r2_CI_AVEvsSUP(1),diff_r2_CI_AVEvsSUP(2))

alpha = 0.014;
fprintf('...........Average - Sup for alpha = %2.3f:', alpha)
diff_r2_CI_AVEvsSUP = bootci(9999,{diffR2,DATA_AVEvsSUP},'alpha',alpha);
fprintf(' CI=[%2.5f, %2.5f]\n',diff_r2_CI_AVEvsSUP(1),diff_r2_CI_AVEvsSUP(2))

alpha = 0.013;
fprintf('...........Average - Sup for alpha = %2.3f:', alpha)
diff_r2_CI_AVEvsSUP = bootci(9999,{diffR2,DATA_AVEvsSUP},'alpha',alpha);
fprintf(' CI=[%2.5f, %2.5f]\n',diff_r2_CI_AVEvsSUP(1),diff_r2_CI_AVEvsSUP(2))

%%%%%%%%%%%%%%
fprintf('\n')

alpha = 0.001;
fprintf('...........Average - DAD for alpha = %2.3f:', alpha)
diff_r2_CI_AVEvsDAD = bootci(9999,{diffR2,DATA_AVEvsDAD},'alpha',alpha);
fprintf(' CI=[%2.5f, %2.5f]\n',diff_r2_CI_AVEvsDAD(1),diff_r2_CI_AVEvsDAD(2))
