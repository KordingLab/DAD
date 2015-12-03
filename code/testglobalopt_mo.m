

Data = preparedata_chewiemihi(0.2,[1,2,5,7]);


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

%X=X(1:4:end,:)


x_sz= size(X,2)
y_sz= size(Ysn,2)
k=ceil(dsz^0.5);


%Wgd=2*rand(2,2)-1

%Y= X*Wgd;

% tic
% [~,sdMat]= knnsearch(X, X, 'K', k, 'NSMethod', 'kdtree');
% rhoY=sdMat(:,end);
% toc
% 
% 
% 
% fKL = @(W)evalKLDiv_mo(W,Ysn,X,k,rhoY);


tic
[~,sdMat]= knnsearch(Xsup, Xsup, 'K', k, 'NSMethod', 'kdtree');
rhoY=sdMat(:,end);
toc



fKL = @(W)evalKLDiv_mo(W,Ysn,Xsup,k,rhoY);





%[xhat_opt, f_xhat_opt, theta]=AdaCorrFunc(fKL, 4, 1e4, 2);
Fmin=1;
for i=1:iterNum
W0= 2*rand(y_sz,x_sz)-1;
options = optimoptions('fminunc','Algorithm','quasi-newton','GradObj','off','Display','iter-detailed', 'MaxFunEvals', 1e5);
[What,FVAL] = fminunc(fKL,W0,options);

display(FVAL)

if FVAL<Fmin
 Wmin= What;
 Fmin= FVAL;
 colorData(Ysn*Wmin,Data.Ttest)
end;

end;


return;