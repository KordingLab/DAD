function Results = DADExpPCA(Ytest,Xtrain,Xtest,C,Ttest,Ttrain)

% need Xtest to compute errors
Results=[];
if nargin<4
    Xtest = 0;
end

X0 = normal(Xtrain);
Y0 = Ytest;

% (Step 1) Preprocessing 
[ Yter , idx1, idx2] = preprocess( Y0 , C.th1l , C.th1u , C.th2l , C.th2u, C.winsz);


[V, ~, ~] = ExpFamPCA(Y0,2);
YLo2=   normal(V);

[YrKL, ~, KLD,~, ~,~,~] = minKL2(YLo2,X0,C);

figure; 
subplot(1,3,1); colorData2014(Xtest,Ttest); 
subplot(1,3,2); colorData2014(V,Ttest); 
subplot(1,3,3); colorData2014(YrKL,Ttest)

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
Results.thMat = [C.th1l , C.th1u , C.th2l , C.th2u]; % thresholds used to preprocess data

end

