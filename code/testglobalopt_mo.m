%Data = preparedata_chewiemihi(0.2,[1,2,5,7]);


std_thresh=1;
iterNum =50;
X=Data.Xtest;
Y=Data.Ytest;
stdY=std(Y);
dsz= size(X,1);

Ys= Y(:, stdY>0);
stdYs=std(Ys);
mstdYs=mean(stdYs);
Ys = Ys(:, stdYs>std_thresh*mstdYs);
mYs=mean(Ys);
Ysn= Ys./(repmat(mYs,dsz,1));


x_sz= size(X,2);
y_sz= size(Ysn,2);

trsz=round(dsz/2);
Ytrain= Ysn(1:trsz,:);
Ytrain_ext=[Ytrain,ones(trsz,1)];
Xtrain=normal(X(1:trsz,:));
Ttrain=Data.Ttest(1:trsz,:);
Ytest= Ysn(trsz+1:end,:);
Ytest_ext=[Ytest,ones(dsz-trsz,1)];
Xtest=normal(X(trsz+1:end,:));
Ttest=Data.Ttest(trsz+1:end);

fldnum=10;
lamnum=500;
[Wsup, Xhat, R2Max, lamc]= crossVaL(Ytrain, Xtrain, Ytest, lamnum, fldnum);



%Wsup=pinv(Ytrain_ext'*Ytrain_ext+lamc*eye(y_sz))*Ytrain_ext'*X;

%Xsup=Ysn*Wsup;
%Xsup= normal(Xsup);

%k=ceil(dsz^0.3);
%X=X(1:4:end,:)




%[p1, XN]= prob_grid(Xsup);
[p1, XN]= prob_grid(Xtrain);
 %KLD = evalKLDiv_grid(Wsup,Ysn,x_sz,p1);

%[~,sdMat]= knnsearch( Xsup, Xsup, 'K', k);
%imht=PlotDist(Xsup);


%rhoY=sdMat(:,end);




%fKL= @(W)evalKLDiv_mo(W, Ysn, Xsup, k);
%fKL= @(W)evalKLDiv_mo(W, Ysn, Xsup, k, rhoY);
fKL= @(W)evalKLDiv_grid(W, Ytest_ext, x_sz, p1);


%p1=kde(Xsup',std(Xsup)'./10);
%p1 = ksize(p1, 'lcv');
%p1 = reduce(p1);
%fKL= @(W)evalKLKDE_mo(W, Ysn, x_sz, p1);


%[xhat_opt, f_xhat_opt, theta]=AdaCorrFunc(fKL, y_sz*x_sz, 1e4, 4);
% Fmin=1;
% for i=1:iterNum
%W0= (2*randn(y_sz,x_sz)-1)/ (y_sz^0.5);
options= optimoptions('fminunc','Algorithm','quasi-newton','GradObj','off','Display','iter-detailed', 'MaxFunEvals', 1.5e4);
%[What, FVAL]= fminunc(fKL, W0, options);
errPre= norm(Xhat-Xtest,2);
[What, FVAL]= fminunc(fKL, Wsup, options);
Xhat_post=normal(Ytest_ext*What); 
colorData(Xhat_post, Ttest)
errPost= norm(Xhat_post-Xtest,2);
% display(FVAL)
% 
% if FVAL<Fmin
%  Wmin= What;
%  Fmin= FVAL;

%  drawnow
% end;



return;