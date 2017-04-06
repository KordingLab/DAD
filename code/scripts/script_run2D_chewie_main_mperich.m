%%%%% script to test DAD for different hyperparameters %%%%%

load('~/Downloads/Chewie_CO_FF_2016-10-07.mat')
remove_dir = [0,4,6,7];
[~,~,T0,Pos0,Vel0,~,~,~] = compile_reaching_data(trial_data,20,30,'go',remove_dir); 

% script to run new data (chewie)
load('~/Downloads/Chewie_CO_FF_2016-10-11.mat')

% define hyper parameters
numDelays = [0, 5, 10, 15, 20];
numSamples = [10, 20, 30, 40];

% fix smoothing factor and dim red method
%SmoothingFac = [4, 8];
SmoothingFac = 8; % optimized through finding min-KL
clear M1
%M1{1} = 'PCA'; M1{2} = 'Isomap';
M1{1} = 'Isomap';

numDR = length(M1);
numParams = length(numDelays)*length(numSamples)*length(SmoothingFac)*numDR;

% search over hyperparameters
R2val = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR);
Pcorr_vel = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR);
Pcorr_pos = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR);
KLmin = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR);
KLmedian = zeros(length(numDelays),length(numSamples),length(SmoothingFac),numDR);

for k1=1:length(numDelays)
    numD=numDelays(k1);
    
    for k2=1:length(numSamples)
        numS=numSamples(k2);
        
        % found 300-500 ms was optimal for numD to minimize KL divergence (unsupervised)
        [Y1,~,T1,Pos,Vel,~,~,~] = compile_reaching_data(trial_data,numD,numS,'go',remove_dir);
        
        for i=1:length(SmoothingFac)
            sfac = SmoothingFac(i);
            [V,Methods,~] = computeV(downsamp_nd(Y1,sfac), 3,M1);
    
            for j=1:numDR
                Vcurr = V{j}(:,1:2);
                tic,
                [Vout,Vflip, yKL, flipInd] = rotated_KLmin(Vcurr,Vel0,90);
                toc
                R2val(k1,k2,i,j) = evalR2(Vel(:,1:2),Vout(:,1:2));
                Pcorr_vel(k1,k2,i,j) = evalTargetErr(normal(Vout),normal(Vel),T1);
                Pcorr_pos(k1,k2,i,j) = evalTargetErr(normal(Vout),normal(Pos),T1);
                KLmin(k1,k2,i,j) = min(yKL);
                KLmedian(k1,k2,i,j) = median(yKL(flipInd));
                display(['numD = ', int2str(numD),...
                         ', numS = ', int2str(numS), ...
                         ', winsz = ', int2str(sfac),...
                         ', Method = ', Methods{j},...
                         ', KL div = ', num2str(KLmin(k1,k2,i,j),2), ...
                         ', R2 = ', num2str(R2val(k1,k2,i,j),2), ...
                         ', Pcorr_vel = ', num2str(Pcorr_vel(k1,k2,i,j),2), ...
                         ', Pcorr_pos = ', num2str(Pcorr_pos(k1,k2,i,j),2)])
            end % end j
            i,
        end % end i
    end % end k2
end % end k1

tmp = KLmin;
[~,idd] = min(tmp(:));
[i1,i2,i3,i4] = ind2sub(size(tmp),idd);

numDhat = numDelays(i1);
numShat = numSamples(i2);
sfachat = SmoothingFac(i3);
drmethod_hat = M1(i4);
R2val_hat = R2val(i1,i2,i3,i4); % final R2 for best solution (min KL)


%%%% RESULTS
% [Y1,~,T1,Pos,Vel,~,~,~] = compile_reaching_data(trial_data,40,50,[0,4,6,7]);
% R2 = 0.5465, Pcorr_vel = 0.9830
