function Results = runsynthexpt(Xtest,Ttest,Xtrain,avec,svec,k,N,model,linkfn,Ysim)

if nargin<8
    model = 'base'; % baseline only,  no modulation term
end

if nargin<9
    linkfn = 'exp'; % exponential link fn (poisson neurons)
end

if nargin<10
    Ysim = simmotorneurons(Xtest,N,model,linkfn);
end

%[V, ~, ~] = ExpFamPCA(Ysim,2);
[~, V, ~] = pca(Ysim);
V = V(:,1:2);

display = 0;
    
Results = minKL_grid(V,Xtrain,avec,svec,'KL',k);
%[YrKL, minVal, KLD, KLS, YLr, YLsc,RM,sconst] = minKL2(Y,X,C);
V = normal(Results.V);
rotData = normal(Results.Xrec);
rotDataf = normal(Results.Vflip);

% compute R2 (max R2 over solution and flip)
XteN = normal(Xtest);
Verr = evalR2(XteN(:),V(:));
errs = [evalR2(XteN(:),rotData(:)), evalR2(XteN(:),rotDataf(:))];
Results.R2val = max(errs);

if display==1
    figure;
    subplot(2,2,1); colorData2014(normal(Xtest),Ttest);
    title('Ground Truth');

    subplot(2,2,2); colorData2014(normal(V),Ttest); 
    title(['ExpPCA embedding (N = ', int2str(N), ', R2 = ',num2str(Verr,2),')']);

    subplot(2,2,3); colorData2014(rotDataf,Ttest); title(int2str(N));
    title(['Flipped solution (N = ', int2str(N), ', R2 = ',num2str(min(errs),2),')']);

    subplot(2,2,4); colorData2014(rotData,Ttest);
    title(['Final solution (N = ', int2str(N), ', R2 = ',num2str(Results.R2val,2),')']);
end

end