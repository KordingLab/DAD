function Err = heatmapfig(Xtrain,Xtest,Ttest,Xhat_sup,Xhat_init,Xhat_dad)

% compute relative L2-norm norm(xhat - xtest)./norm(xtest)
errmethod=1; %(set to 2 for R2 values)


% normalize kinematics est
Xtrain = normal(Xtrain);
Xhat_sup = normal(Xhat_sup);
Xhat_dad = normal(Xhat_dad);
Xhat_init = normal(Xhat_init);

% compute heatmaps
p_train = prob_grid(Xtrain);
p_sup = prob_grid(Xhat_sup);
p_dad = prob_grid(Xhat_dad);
p_init = prob_grid(Xhat_init);

Xtest2 = normal(Xtest);
Err.sup = norm(Xhat_sup(:)-Xtest2(:))./norm(Xtest2(:));
Err.dad = norm(Xhat_dad(:)-Xtest2(:))./norm(Xtest2(:));
Err.init = norm(Xhat_init(:)-Xtest2(:))./norm(Xtest2(:));

if errmethod==2
    Err.sup = evalR2(Xhat_sup,Xtest2);
    Err.dad = evalR2(Xhat_dad,Xtest2);
    Err.init = evalR2(Xhat_init,Xtest2);
end

figure;
subplot(3,3,2); imagesc(log(reshape(p_train,50,50))); axis off
colormap hot; title('Kinematics Prior');
subplot(3,3,4); imagesc(log(reshape(p_sup,50,50))); axis off
colormap hot; title(['Supervised Heat Map (Err = ',num2str(Err.sup,3),'%)']);
subplot(3,3,5); imagesc(log(reshape(p_init,50,50))); axis off
colormap hot; title(['Initial point (Err = ',num2str(Err.init,3),'%)']);
subplot(3,3,6); imagesc(log(reshape(p_dad,50,50))); axis off
colormap hot; title(['DAD Heat Map (Err = ',num2str(Err.dad,3),'%)']);

subplot(3,3,7); hold off; colorData2014(Xhat_sup,Ttest); 
axis([-3 3 -3 3]); title('Supervised')
subplot(3,3,8); hold off; colorData2014(Xhat_init,Ttest); 
axis([-3 3 -3 3]); title('Rotated Init') 
subplot(3,3,9); hold off; colorData2014(Xhat_dad,Ttest); 
axis([-3 3 -3 3]); title('DAD')

end