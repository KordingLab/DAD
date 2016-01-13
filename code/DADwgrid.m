function Results = DADwgrid(Ytest,Xtrain,C,Xtest,Ttest,k)

% need Xtest to compute errors
Results=[];
if nargin<4
    Xtest = 0;
end

X0 = Xtrain;
Y0 = Ytest;

% (Step 1) Preprocessing 
[ Yter , idx1, idx2] = preprocess( Y0 , C.th1l , C.th1u , C.th2l , C.th2u, C.winsz);

C.dASz = size(X0,1);
C.ySz = size(Yter,2);
C.dSzE = size(Y0,1);
C.dszt = size(Yter,1);

[~,~, LP] = pca(Yter);

if length(idx1)>1 && length(idx2)>1 && min(LP)>C.EigRatio*max(LP)

% (Step 2) Dimensionality Reduction 
my=mean(Yter);
myV=ones(size(Yter,1),1)*my;
YterZ=Yter-myV;
[~,~,~,~,F]  = factoran(YterZ,2);

figure; 
subplot(2,2,1); colorData2014(Xtest,Ttest); title('Test Kinematics (Truth)')
subplot(2,2,2); colorData2014(normal(F),Ttest(idx2)); title('FA Output')

%%%%%%% Compute YLo
v1=ones(C.dszt,1);
v1L=ones(C.dSzE,1);
Yreg=[Y0(idx2,:),v1];
YteL=[Y0,v1L];     
lam=    2*norm(Yreg'*Yreg);
What=   pinv(Yreg'*Yreg+ lam*eye(size(Yreg,2)))*Yreg'*F;
YLoAll= YteL*What;
YLo2=   normal(YLoAll);

subplot(2,2,3); colorData2014(YLo2,Ttest); title('Embedded Data')

% (Step 2) Correcting the rotation and scaling       %%%%%%%%%

%[YrKL, ~, KLD,~, ~,~,~] = minKL2(YLo2,normal(Xtrain),C);
Results = minKL_grid(YLo2,normal(Xtrain),C.pig,C.scg,'L2',k);

subplot(2,2,4); colorData2014(normal(Results.Xrec),Ttest); title('Final Solution')


XteN = normal(Xtest); % ground truth (labels for Ytest)
Results.sstot = sum( var( XteN ) );
Results.ssKL = sum( mean(( XteN - normal(Results.Xrec) ).^2) ); %XteN real kinematics
Results.R2KL = 1- Results.ssKL/Results.sstot;

Results.W0 = What; %predicted kinematics
Results.What = What; %predicted kinematics
Results.whichrows = idx1; % rows used for training decoder
Results.whichcols = idx2; % cols used for training decoder
Results.thMat = [C.th1l , C.th1u , C.th2l , C.th2u]; % thresholds used to preprocess data

end

end % end main function


