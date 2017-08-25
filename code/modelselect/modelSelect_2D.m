function Results = modelSelect_2D(trial_data,Xtr,removedir,numDelays,numSamples,SmoothingFac,remove_dir)

Vel0 = Xtr;
if nargin==3
    % set of hyperparameters used to analyze Chewie dataset
    % (Chewie_CO_FF_2016-10-11.mat')
    numDelays = [5, 10, 15, 20, 25];
    numSamples = [10, 15, 20, 25, 30, 35, 40];
    SmoothingFac = [4, 8];
end

M1{1} = 'PCA'; 
M1{2} = 'Isomap';
M1{3} = 'FA';
numDR = length(M1);

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
        [Y1,~,T1,Pos,Vel,~,~,~] = compile_reaching_data(trial_data,numD,numS,'go',removedir);
        
        for i=1:length(SmoothingFac)
            sfac = SmoothingFac(i);
            Yr = remove_constcols(Y1);
            [V,Methods,~] = computeV(downsamp_nd(Yr,sfac), 3, M1);
    
            for j=1:numDR
                Vcurr = V{j}(:,1:2);
                tic,
                [Vout,~, yKL, flipInd] = rotated_KLmin(Vcurr,Vel0,90);
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
        end % end i
    end % end k2
end % end k1


%%%%% Now, optimize ~ Select model parameters sequentially %%%%%

% 1. first select dim reduction method
tmpvar = zeros(numDR,1);
for i=1:numDR
    tmp= KLmin(:,:,:,i);
    tmpvar(i) = median(tmp(:));
end
[~,id1] = min(tmpvar);
Results.drmethod_final = M1{id1};

% 2. now select a smoothing factor
tmpvar = zeros(length(SmoothingFac),1);
for i=1:length(SmoothingFac)
    tmp= KLmin(:,:,i,id1);
    tmpvar(i) = median(tmp(:));
end
[~,id2] = min(tmpvar);
Results.sfacfinal = SmoothingFac(id2);

% 3. now select the number of samples after go cue
tmpvar = zeros(length(numSamples),1);
for i=1:length(numSamples)
    tmp= KLmin(:,i,id2,id1);
    tmpvar(i) = median(tmp(:));
end
[~,id3] = min(tmpvar);
Results.numSfinal = numSamples(id3);

% 4. now select length of delay after go cue
tmpvar = KLmin(:,id3,id2,id1);
[~,id4] = min(tmpvar);
Results.numDfinal = numDelays(id4);

%%%%
[Y1,~,T1,~,Vel,~,~,~] = compile_reaching_data(trial_data,Results.numDfinal,Results.numSfinal,'go',removedir);
Y2= downsamp_nd(Y1,Results.sfacfinal);
Mfinal{1} = Results.drmethod_final; 
[V,~,~] = computeV(Y2, 3, Mfinal);
Vcurr = V{1}(:,1:2); 
[Vout,~, ~, ~] = rotated_KLmin(Vcurr,Vel0,90);

if strcmp(Results.drmethod_final,'Isomap')
    W = pinv(Results.Yte)*Results.Xrec;
    Results.Xrec_linear = Results.Yte*W;
else
    Results.Xrec_linear =[];
end

Results.KLmin = Klmin;
Results.Yte = Y2;
Results.Tte = T1;
Results.Vel = Vel;
Results.Xrec = Vout;
Results.Pos = Pos;

end


%%%
% taking the minimum is too noisy!
%[~,idd] = min(KLmin(:));
%[i1,i2,i3,i4] = ind2sub(size(tmp),idd);
%Results.numDfinal = numDelays(i1);
%Results.numSfinal = numSamples(i2);
%Results.sfacfinal = SmoothingFac(i3);
%Results.drmethod_final = M1(i4);
%Results.R2val_hat = R2val(i1,i2,i3,i4); % final R2 for best solution (min KL)
