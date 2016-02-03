function Results = DADExpPCA(Ytest,Xtrain,Xtest,C,Ttest,Ttrain)

% need Xtest to compute errors
display=1;
k = 10; % FIX THIS LATER!
if nargin<4
    Xtest = 0;
end

X0 = normal(Xtrain);

whichnan = isnan(Ytest);
Ytest(whichnan)=0;
Y0 = Ytest;

[V, ~, ~] = ExpFamPCA(Y0,2);
YLo2=   normal(V);

if display==1
    figure;
    subplot(1,3,1); colorData2014(Xtest,Ttest); 
    subplot(1,3,2); colorData2014(V,Ttest); 
end

Results = minKL_grid(YLo2,X0,C.pig,C.scg,'L2',k);

if display==1
    figure; 
    subplot(1,3,3); 
    colorData2014(Results.Xrec,Ttest)
    title(['R2 = ', num2str(evalR2(Xtest,Results.Xrec),3)])
end

if Xtest~=0
    XteN = normal(Xtest); % ground truth (labels for Ytest)
    Results.sstot = sum( var( XteN ) );
    Results.ssKL = sum( mean(( XteN - Results.Xrec ).^2) ); %XteN real kinematics
    Results.R2KL = 1- Results.ssKL/Results.sstot;
else
    % cant compute errors without labels
    Results.sstot = 0;
    Results.ssKL = 0;
end

Results.YLoMat = YLo2; % low -dimensional projection 
Results.thMat = [C.th1l , C.th1u , C.th2l , C.th2u]; % thresholds used to preprocess data

end

