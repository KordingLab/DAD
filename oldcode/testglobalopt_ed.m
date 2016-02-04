%% (STEP 1) PREPARE DATA
trsz = 250;
yTs = 0.2;
xTs = 0.08;
Data = preparedata_chewiemihi(yTs);
Data2x = preparedata_chewiemihi(xTs);

% remove directions
removedir = [0,2,7];
[Xtest,Ytest,Ttest,Xtrain,~,Ttrain] = removedirdata(Data,removedir);
[Xtest2x,Ytest2x,Ttest2x,Xtrain2x,~,Ttrain2x] = removedirdata(Data,removedir);

%% (STEP 2) SUPERVISED LEARNING
[Wsup,trainset,testset] = supdecoder(Xtest,Ytest,trsz);
Yt2 = Ytest(testset,:);
Ytest_ext = [Yt2, ones(size(Yt2,1),1)];
Xhat_sup =Ytest_ext*Wsup;
p_train = prob_grid(normal(Xtrain));

Xt2 = Xtest(testset,:);
errSup= norm(Xhat_sup(:)-Xt2(:),2)./norm(Xt2(:));
p_sup = prob_grid(normal(Xhat_sup));

%% (STEP 3) DAD - DISTRIBUTION ALIGNMENT DECODING

C = setinputparams(); 
C.th1l = 1;
C.th1u = inf;
C.th2l = 1;
C.th2u = inf;

ResultsDAD = DAD2(Yt2,Xtrain2x,C,Xtest,Ttest,Ttrain);
Xhat_dad = ResultsDAD.YrKLMat;
p_dad = prob_grid(normal(Xhat_dad));

Xtest2 = normal(Xtest(testset,:));
Err.sup = norm(Xhat_sup(:)-Xtest2(:))./norm(Xtest2(:));
Err.dad = norm(Xhat_dad(:)-Xtest2(:))./norm(Xtest2(:));

figure;
subplot(1,3,1); imagesc(log(reshape(p_train,50,50)));
axis off; colormap hot; title('Training Kinematics')
subplot(1,3,2); imagesc(log(reshape(p_sup,50,50)));
axis off; colormap hot; title(['Supervised Heatmap (', num2str(Err.sup,2),')'])
subplot(1,3,3); imagesc(log(reshape(p_dad,50,50)));
axis off; colormap hot; title(['DAD Heatmap (', num2str(Err.dad,2),')'])

%% (STEP 4) APPLY KL++ TO OUTPUT OF DAD
numiter = 5; numouter = 3;
Wdad = pinv([Yt2, ones(size(Yt2,1),1)])*ResultsDAD.YrKLMat;

[What_rotdad,ResultsKL] = rotate2KL(Xtrain,Ytest_ext,Wdad,numiter,numouter);
Xhat_rotdad = Ytest_ext*ResultsKL.What{3}*ResultsKL.R{3};
p_rotdad = prob_grid(normal(Xhat_rotdad));
Err.rotdad = norm(Xhat_rotdad(:)-Xtest2(:))./norm(Xtest2(:));

Errnew = heatmapfig(Xtrain,Xtest(testset,:),Ttest(testset),Xhat_sup,Xhat_rotdad,Xhat_dad)

%%
numiter = 5; numouter = 1;
Wdad = pinv([Yt2, ones(size(Yt2,1),1)])*ResultsDAD.YLoMat;
[What_rotdad,ResultsKL2] = rotate2KL(Xtrain,Ytest_ext,Wdad,numiter,numouter,bsz);
Xhat_rotdad2 = Ytest_ext*ResultsKL2.What{3}*ResultsKL2.R{3};

p_rotdad2 = prob_grid(normal(Xhat_rotdad),bsz);
Err.rotdad2 = norm(Xhat_rotdad2(:)-Xtest2(:))./norm(Xtest2(:));




%% rotate then rescale/shear

R=rotmat(40);
What_init = Wsup*R;
Xhat_init = normal([Ytest, ones(size(Ytest,1),1)]*What_init);

% compute rotation + rescaling
numiter=5;
[What,Results] = rotate2KL(Xtrain,Ytest_ext,What_init,numiter);
Xhat_rot = Ytest_ext*Results.What{1}*Results.R{1};
Xhat_dad = Ytest_ext*Results.What{2}*Results.R{2};

% plot results, compute error
Errnew = heatmapfig(Xtrain,Xtest,Ttest,Xhat_sup,Xhat_init,Xhat_dad)
randbeep % plays random beep at end!

%





%% define KL function handle

%p_train = prob_grid(normal(Data2x.Xtrain));
%fKL= @(W)evalKLDiv_grid(W, Ytest_ext, x_sz, p_train);
%options= optimoptions('fminunc','Algorithm','quasi-newton',...
%    'GradObj','off','Display','iter-detailed', 'MaxFunEvals', 1.5e4);


%p_init = prob_grid(Xhat_init);
%Xtest2 = normal(Xtest);
%errPre = norm(Xhat_init(:)-Xtest2(:),2)./norm(Xtest2(:));


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





