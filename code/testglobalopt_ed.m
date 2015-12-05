%% prepare data
Data = preparedata_chewiemihi(0.2,[1,2,5,7]);
Data2x = preparedata_chewiemihi(0.08,[1,2,5,7]);

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

%% supervised learning
fldnum=10;
lamnum=500;
[Wsup, ~, R2Max, lamc]= crossVaL(Ytrain, Xtrain, Ytest, lamnum, fldnum);

Xhat_sup =Ytest_ext*Wsup;
errSup= norm(Xhat_sup(:)-Xtest(:),2)./norm(Xtest(:));
p_sup = prob_grid(normal(Xhat_sup));

%% define KL function handle

%p_train = prob_grid(normal(Data2x.Xtrain));
%fKL= @(W)evalKLDiv_grid(W, Ytest_ext, x_sz, p_train);
%options= optimoptions('fminunc','Algorithm','quasi-newton',...
%    'GradObj','off','Display','iter-detailed', 'MaxFunEvals', 1.5e4);


%p_init = prob_grid(Xhat_init);
%Xtest2 = normal(Xtest);
%errPre = norm(Xhat_init(:)-Xtest2(:),2)./norm(Xtest2(:));

%% rotate then rescale/shear

R=rotmat(20);
What_init = Wsup*R;
Xhat_init = normal([Ytest, ones(size(Ytest,1),1)]*What_init);

% compute rotation + rescaling
numiter=10;
[What,FVAL,R2,R3] = rotate2KL(Xtrain,Ytest_ext,What_init,numiter);
Xhat_rot = Ytest_ext*What_init*R2;
Xhat_dad = Ytest_ext*What*R2*R3;

Errnew = heatmapfig(Xtrain,Xtest,Ttest,Xhat_sup,Xhat_init,Xhat_dad)


%% plot results






%% compute random initialization point
%What_init = Wsup + randn(size(Wsup))*0.08;
%Xhat_init = normal([Ytest, ones(size(Ytest,1),1)]*W_init);

for i=1:4
    R=rotmat(5*i);
    What_init = Wsup*R;
    Xhat_init = normal([Ytest, ones(size(Ytest,1),1)]*What_init);

    p_init = prob_grid(Xhat_init);
    Xtest2 = normal(Xtest);
    errPre(i)= norm(Xhat_init(:)-Xtest2(:),2)./norm(Xtest2(:));

    figure(i);
    subplot(2,3,1); imagesc(log(reshape(p_init,50,50))); colormap hot; 
    title('Initialization Point')
    subplot(2,3,2); imagesc(log(reshape(p_train,50,50))); colormap hot; 
    title('Training Data')
    subplot(2,3,4); colorData2014(normal(Xhat_init),Ttest)
    title('Initialization Point')
    subplot(2,3,5); colorData2014(normal(Xhat_sup), Ttest)
    title('Supervised Solution')
    pause,

    %% run dad
    % dad result
    %x = fmincon(fKL,What_init,[],[],[],[],-0.2*ones(size(Wsup)),0.2*ones(size(Wsup)));
    [What, FVAL]= fminunc(fKL, What_init, options);
    Results{i}.What = What;

    Xhat_dad =Ytest_ext*What;
    Xhat_dad = normal(Xhat_dad);
    p_dad = prob_grid([Ytest, ones(size(Ytest,1),1)]*What);

    subplot(2,3,6); colorData2014(normal(Xhat_dad),Ttest); title('DAD Solution')
    subplot(2,3,3); imagesc(log(reshape(p_dad,50,50))); colormap hot; title('DAD Solution')

    pause,
    Xtest2 = normal(Xtest);
    errPost(i)= norm(Xhat_dad(:)-Xtest2(:))./norm(Xtest2(:));

end


figure;
subplot(3,3,2); imagesc(log(reshape(p_train,50,50))); axis off
colormap hot; title('Kinematics Prior');
subplot(3,3,4); imagesc(log(reshape(p_sup,50,50))); axis off
colormap hot; title('Supervised Heat Map');
subplot(3,3,5); imagesc(log(reshape(p_init,50,50))); axis off
colormap hot; title('Rotated Heat Map (Winit)');
subplot(3,3,6); imagesc(log(reshape(p_dad,50,50))); axis off
colormap hot; title('Solution of DAD (Winit)');

subplot(3,3,7); hold off; colorData2014(normal(Xhat_sup),Ttest); 
axis([-3 3 -3 3]); title('Supervised')
subplot(3,3,8); hold off; colorData2014(normal(Xhat_init),Ttest); 
axis([-3 3 -3 3]); title('Rotated Init') 
subplot(3,3,9); hold off; colorData2014(normal(Xhat_dad),Ttest); 
axis([-3 3 -3 3]); title('DAD')


%% try alternating rotation + W search
for i=1:50
    fKL2= @(theta)evalKLDiv_gridwrot(What_init,theta,Ytest_ext, x_sz, p_train);
    [theta_hat(i),FVAL(i)] = fminunc(fKL2,randn(1)*60, options); 
end

[~,id] = min(FVAL);
R2 = rotmat(theta_hat(id));
Xrot = Ytest_ext*What_init*R2;
p_rot = prob_grid(Xrot);

figure; 
subplot(1,2,1); imagesc(log(reshape(p_rot,50,50))); axis off; colormap hot
subplot(1,2,2); colorData2014(Xrot,Ttest)

fKL3= @(W)evalKLDiv_gridwrot(W,theta_hat(id),Ytest_ext, x_sz, p_train);
[What3, FVAL3]= fminunc(fKL3, What_init, options);



fKL2= @(W)evalKLDiv_gridwrot(W,theta_hat(id),Ytest_ext, x_sz, p_train);
[What2, FVAL]= fminunc(fKL2, What_init, options);

Xhat_dadrot =[Ytest, ones(size(Ytest,1),1)]*What2;
Xhat_dadrot = normal(Xhat_dadrot);
p_dadrot = prob_grid(Xhat_dadrot);


figure;
subplot(3,3,2); imagesc(log(reshape(p_train,50,50))); axis off
colormap hot; title('Kinematics Prior');
subplot(3,3,4); imagesc(log(reshape(p_sup,50,50))); axis off
colormap hot; title('Supervised Heat Map');
subplot(3,3,5); imagesc(log(reshape(p_init,50,50))); axis off
colormap hot; title('Rotated Heat Map (Winit)');
subplot(3,3,6); imagesc(log(reshape(p_dadrot,50,50))); axis off
colormap hot; title('Solution of DAD w Rot Matrix');

subplot(3,3,7); hold off; colorData2014(normal(Xhat_sup),Ttest); 
axis([-3 3 -3 3]); title('Supervised')
subplot(3,3,8); hold off; colorData2014(normal(Xhat_init),Ttest); 
axis([-3 3 -3 3]); title('Rotated Init') 
subplot(3,3,9); hold off; colorData2014(normal(Xhat_dadrot),Ttest); 
axis([-3 3 -3 3]); title('Solution of DAD w Rot Matrix');



Xtest2 = normal(Xtest);
Errs = [norm(Xhat_dad(:)-Xtest2(:))./norm(Xtest2(:));...
    norm(Xhat_dadrot(:)-Xtest2(:))./norm(Xtest2(:));
    norm(Xhat_sup(:)-Xtest2(:))./norm(Xtest2(:));
    norm(Xhat_init(:)-Xtest2(:))./norm(Xtest2(:))]


%%

fKL2= @(W)evalKLDiv_grid(What_init, Ytest_ext, x_sz, p_train);
[What2, FVAL]= fminunc(fKL2, What_init, options);





