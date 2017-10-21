%% 1. Prepare data and compute firing rates

% bin size = 200 ms, chewie1 for training kinematics, mihi for neural test
Data = prepare_superviseddata(0.2,'chewie1','mihi',[],0); 

% subsample the kinematics and neural data
removedir = [0,1,2,6]; 
[Xte,Yte,Tte,Xtr,Ytr,Ttr,Nte,Ntr] = removedirdata(Data,removedir);

disp('Finished computing firing rates...')

%% 2. Run DAD w/ factor analysis for dimensionality reduction
% opts.dimred_method = 'PCA'; % to apply PCA

opts.dimred_method = 'FA'; % use factor analysis to reduce the dimensionality
Xrec = runDAD3d(Xtr,Yte,opts);
R2valDAD = evalR2(Xrec,Xte); % compute the R2
disp('Finished running DAD...')

%%

figure,
subplot(1,3,1),
colorData(Xtr,Ttr), title('Training')
subplot(1,3,2),
colorData(Xte,Tte), title('Test')
subplot(1,3,3),
colorData(Xrec,Tte), title(['DAD (R2 = ', num2str(R2valDAD,2), ')'])
