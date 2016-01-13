function R2 = R2val(X,Y)
% X is ground truth
% Y is test data

YN = normal(Y);
XN = normal(X); % ground truth (labels for Ytest)
sstot = sum( var( XN ) );
ssKL = sum( mean(( XN - YN ).^2) ); %XteN real kinematics
R2 = 1- ssKL/sstot;

end