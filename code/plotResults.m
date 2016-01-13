function plotResults(Results)
figure; 
subplot(1,3,1); imagesc(Results.Itrain); axis square off; colormap hot; title('Training'); 
subplot(1,3,2); imagesc(Results.Irot); title('Init Rot'); axis square off; colormap hot; 
subplot(1,3,3); imagesc(Results.Iout); title('After rescaling'); axis square off; colormap hot; 

end