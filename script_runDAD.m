%%%% script to run 3D alignment (run DAD on real datasets)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1. Setup experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

setuppath
numA = 90; %every 2 deg
Ts=.20;
percent_test = 1;
numsteps=length(percent_test);
randseed = randi(100,1);
rng(randseed)
removedir = [0, 1, 2];
Ntot = 1027;
numIter = 2;
M1{1} = 'FA'; % dont need dr toolbox for factor analysis 

% parameters for DAD
opts.gridsz = 3;
opts.method = 'KL';
opts.nzvar=0;
opts.rfac=0;

%%%%% user input
percent_samp = input('Amount to train on (scalar between 0,1): ');
supmethod = input('Enter 1 if you want to run the supervised method: '); 

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2. Prepare training and test datasets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute firing rates and remove directions 
Data0 = prepare_superviseddata(Ts,'chewie1','mihi',[]);
Data = prepare_superviseddata(Ts,'mihi','mihi',[],0);
[~,~,~,XtrC,~,~,~,~] = removedirdata(Data0,removedir);
[~,~,~,Xtrain,Ytrain,Ttrain,~,Ntrain] = removedirdata(Data,removedir);
clear Data Data0

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 3. Run DAD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize variables
R2M = zeros(1,numIter);
R2C = zeros(1,numIter);
R2MC = zeros(1,numIter);

R2Sup = zeros(2,numIter);
R2Ave = zeros(3,numIter);
 
for nn = 1:numIter 
          
        % split dataset into train/test sets
        [Xtr,Ytr,Ttr,Xte,Yte,Tte,trainid,testid] = splitdataset(Xtrain,Ytrain,Ttrain,Ntrain,percent_samp); 
        numte = size(Yte,1);
        permzte = randperm(numte);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Step 3A. Run 3D DAD (M)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ResM = runDAD(Yte,Xtr,opts,Tte,Xte);
        R2M(nn) = ResM.R2;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Step 3B. Run 3D DAD (MC)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% now for augmented training
        opts.method = method;
        ResMC = runDAD(Yte,[Xtr; XtrC],opts,Tte,Xte);
        R2MC(nn) = ResMC.R2;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Step 3C. Run 3D DAD (C)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % now chewie training only
        ResC = runDAD(Yte,XtrC,opts,Tte,Xte);
        R2C(nn) = ResC.R2;
        
        %%%% supervised & least-squares
        if supmethod==1
            fldnum=10; lamnum=500;
            [Wsup, ~, ~, ~]= crossVaL(Ytr, Xtr, Yte, lamnum, fldnum);
            Xsup = [Yte,ones(size(Yte,1),1)]*Wsup;
            r2sup = evalR2(mapX3D(Xte),mapX3D(Xsup));     
            warning off, Wls = (Yte\Xte); Xls = Yte*Wls;
            r2ls = evalR2(mapX3D(Xte),mapX3D(Yte*Wls)); 
            R2Sup(:,nn) = [r2sup,r2ls];
        
            % compute average of DAD + Sup
            Xave = normal((ResM.V + mapX3D(Xsup))/2);
            r2avem = evalR2(mapX3D(Xte),Xave); 
            Xave = normal((ResMC.V + mapX3D(Xsup))/2);
            r2avemc = evalR2(mapX3D(Xte),Xave); 
            Xave = normal((ResC.V + mapX3D(Xsup))/2);
            r2avec = evalR2(mapX3D(Xte),Xave); 
            
            r2avetot = [r2avem,r2avemc,r2avec]; 
            
            display(['DAD (Sup), R2 = ', num2str(r2sup,3)])
            display(['DAD (LS), R2 = ', num2str(r2ls,3)])
            display(['DAD (Ave), R2 = ', num2str(max(r2avetot),3)])
            
            R2Ave(:,nn) = r2avetot; 
        end
        
        display(['DAD (M), R2 = ', num2str(ResM.R2,3)])   
        display(['DAD (MC), R2 = ', num2str(ResMC.R2,3)])    
        display(['DAD (C), R2 = ', num2str(ResC.R2,3)])
        
        display('***~~~~~~++++~+~+~+~+~++~+~+~***')  
               
end

% Figure (1) - boxplot comparison of DAD and supervised approach
if numIter>1
    figure; boxplot([R2M; R2MC; R2C; R2Sup(1,:); R2Ave(1,:); R2Sup(2,:)]');
    title([int2str(percent_samp*100), '% train, ', num2str((1-percent_samp)*100), '% test'])
else
    figure; 
    plot([R2M; R2MC; R2C; R2Sup(1,:); R2Ave(1,:); R2Sup(2,:)],...
        'o','MarkerSize',8); 
    title(['DAD(M)           ',...
           'DAD(MC)           ',...
           'DAD(C)                   ',...
           'Sup               ',...
           'Sup+DAD             ',...
           'Oracle             ']);
end 

T3D = repmat(Ttr,ceil(size(ResM.X3D,1)/length(Ttr)),1);

% Figure (2) - Visualization of 3D decoding (if supervised)

if supmethod==1
    figure; 
    subplot(3,3,1); colorData(Xte,Tte); title('Ground truth')
    subplot(3,3,2); colorData(Xtr,Ttr); title('Training kinematics (before)')
    subplot(3,3,3); colorData(ResM.X3D,T3D); title('Training kinematics (after)')

    subplot(3,3,7); colorData(Xsup,Tte); title('Supervised')
    subplot(3,3,8); colorData(Xave,Tte); title('Averaged (DAD+Sup)')
    subplot(3,3,9); colorData(Xls,Tte); title('Oracle')

    subplot(3,3,4); colorData(ResM.V,Tte); title('DAD (Within-subject)')
    subplot(3,3,5); colorData(ResMC.V,Tte); title('DAD (Combined-subject)')
    subplot(3,3,6); colorData(ResC.V,Tte); title('DAD (Across-subject)')
end

% Figure (3) - Visualization of 2D Rotation Aligment
figure; 
subplot(3,3,1); colorData(Xte,Tte); title('Ground truth')
subplot(3,3,2); colorData(ResM.X3D,T3D); title('Training kinematics (after)')
warning off, Wls = (Yte\Xte); Xls = Yte*Wls;
subplot(3,3,3); colorData(Xls,Tte); title('Oracle')
subplot(3,3,4); colorData(ResM.V,Tte); title('DAD (Within-subject)')
subplot(3,3,5); colorData(ResMC.V,Tte); title('DAD (Combined-subject)')
subplot(3,3,6); colorData(ResC.V,Tte); title('DAD (Across-subject)')
subplot(3,3,7); colorData(ResM.Xrec,Tte); title('DAD+RotKL (Within-subject)')
subplot(3,3,8); colorData(ResMC.Xrec,Tte); title('DAD+RotKL (Combined-subject)')
subplot(3,3,9); colorData(ResC.Xrec,Tte); title('DAD+RotKL (Across-subject)')


%%%%%%%%%% end script 
% output =  ResM.V (results of DAD-M)
%           ResMC.V (results of DAD-MC)
%           ResC.V (results of DAD-C)
%           Xsup (supervised)
%           Xave (DAD+Sup)
%           Xls (Oracle)
%%%%%%%%%%

