%Data = preparedata_chewiemihi(0.2,[1,2,5,7]);


std_thresh=1;
iterNum =50;
X=normal(Data.Xtest);
Y=Data.Ytest;
stdY=std(Y);
dsz= size(X,1);

Ys= Y(:, stdY>0);
stdYs=std(Ys);
mstdYs=mean(stdYs);
Ys = Ys(:, stdYs>std_thresh*mstdYs);
mYs=mean(Ys);
Ysn= Ys./(repmat(mYs,dsz,1));

Wsup=pinv(Ysn'*Ysn)*Ysn'*X;

Xsup=Ysn*Wsup;
Xsup= normal(Xsup);

k=ceil(dsz^0.3);
%X=X(1:4:end,:)


x_sz= size(X,2);
y_sz= size(Ysn,2);

[p1, XN]= prob_grid(Xsup);
 %KLD = evalKLDiv_grid(Wsup,Ysn,x_sz,p1);

%[~,sdMat]= knnsearch( Xsup, Xsup, 'K', k);
%imht=PlotDist(Xsup);


%rhoY=sdMat(:,end);




%fKL= @(W)evalKLDiv_mo(W, Ysn, Xsup, k);
%fKL= @(W)evalKLDiv_mo(W, Ysn, Xsup, k, rhoY);
fKL= @(W)evalKLDiv_grid(W, Ysn, x_sz, p1);


%p1=kde(Xsup',std(Xsup)'./10);
%p1 = ksize(p1, 'lcv');
%p1 = reduce(p1);
%fKL= @(W)evalKLKDE_mo(W, Ysn, x_sz, p1);


%[xhat_opt, f_xhat_opt, theta]=AdaCorrFunc(fKL, y_sz*x_sz, 1e4, 4);
%Fmin=1;
%for i=1:iterNum
%W0= (2*randn(y_sz,x_sz)-1)/ (y_sz^0.5);
options= optimoptions('fminunc','Algorithm','quasi-newton','GradObj','off','Display','iter-detailed', 'MaxFunEvals', 3e4);
[What, FVAL]= fminunc(fKL, W0, options);

display(FVAL)

%if FVAL<Fmin
% Wmin= What;
% Fmin= FVAL;
 colorData(normal(Ysn*Wmin),Data.Ttest)
 drawnow
%end;


end;

return;