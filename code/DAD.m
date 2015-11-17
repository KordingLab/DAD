function Results = DAD(Ytest,Xtrain,C,Xtest)
% need Xtest to compute errors

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

[~, ~, LP]= pca(Yter);

if length(idx1)>1 && length(idx2)>1 && min(LP)>C.EigRatio*max(LP)

% (Step 2) Dimensionality Reduction 
my=mean(Yter);
myV=ones(length(idx2),1)*my;
YterZ=Yter-myV;
[~,~,~,~,F]  = factoran(YterZ,2);

v1=ones(C.dszt,1);
v1L=ones(C.dSzE,1);
Yreg=[Y0(idx2,:),v1];
YteL=[Y0,v1L];     
lam=    2*norm(Yreg'*Yreg);
What=   pinv(Yreg'*Yreg+ lam*eye(size(Yreg,2)))*Yreg'*F;
YLoAll= YteL*What;
YLo2=   normal(YLoAll);

% (Step 2) Correcting the rotation and scaling       %%%%%%%%%
[YrKL, ~, KLD, ~, ~, ~] = minKL(YLo2, X0, C);

if Xtest~=0
    XteN = normal(Xtest); % ground truth (labels for Ytest)
    Results.sstot = sum( var( XteN ) );
    Results.ssKL = sum( mean(( XteN - YrKL ).^2) ); %XteN real kinematics
    Results.R2KL = 1- Results.ssKL/Results.sstot;
else
    % cant compute errors without labels
    Results.sstot = 0;
    Results.ssKL = 0;
end


Results.vKL = min(KLD);
Results.YrKLMat = YrKL; %predicted kinematics
Results.YLoMat = YLo2; % low -dimensional projection 
Results.idx1Mat = idx1; % rows used for training decoder
Results.idx2Mat = idx2; % cols used for training decoder
Results.Wcell = What; % decoding matrix
Results.mMat = my; % mean vector
Results.thMat = [C.th1l , C.th1u , C.th2l , C.th2u]; % thresholds used to preprocess data

end

