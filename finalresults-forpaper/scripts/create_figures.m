figure; 

% create before and after plot
figure; subplot(1,2,1); 
plot3(Vr{6}(:,1), Vr{6}(:,2), Vr{6}(:,3),'*'); 
hold on; Xn = normal(X3D); plot3(Xn(:,1), Xn(:,2), Xn(:,3),'o');
subplot(1,2,2); plot3(Res{6}.Vout(:,1), Res{6}.Vout(:,2), Res{6}.Vout(:,3),'*'); 
hold on; Xn = normal(X3D); plot3(Xn(:,1), Xn(:,2), Xn(:,3),'o');

% create plot with different embeddings
figure;
subplot(2,3,1); colorData2014(Xte,Tte); title('Ground truth (R2 = 0.85)')
subplot(2,3,2); colorData2014(Res{6}.Xrec,Tte); title('Final Solution (R2 = 0.627)')
subplot(2,3,3); colorData2014(Res{6}.Vflip,Tte); title('Flipped solution')
subplot(2,3,4); colorData2014(X3D,Ttr); title('Target distribution (3D)')
subplot(2,3,5); colorData2014(Vr{6},Tte); title('Output of FA (3D)')
subplot(2,3,6); colorData2014(Res{6}.Vicp,Tte); title('Output of cone matching (2D)')

% Results 
% numA = 180 , k = 9 , Method = PCA, R2 = 0.266
% numA = 180 , k = 9 , Method = MDS, R2 = 0.266
% numA = 180 , k = 9 , Method = GPLVM, R2 = 0.266
% numA = 180 , k = 9 , Method = ProbPCA, R2 = 0.259
% numA = 180 , k = 9 , Method = Isomap, R2 = -0.552
% numA = 180 , k = 9 , Method = FA, R2 = 0.627


