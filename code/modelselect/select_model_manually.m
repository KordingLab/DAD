function [Xrec,R2val,ii,jj,kk] = select_model_manually(minKL,Xrec_all,Xte_all,Tte_all,K)

[v1,v2,~] = findpeaks(-minKL(:));
[~,idd] = sort(v1,'descend');
newK = min(K,length(idd));
whichid=v2(idd(1:newK));

% manual - tagging good solutions
figure,
numplots=ceil(newK/2);
subplot(3,numplots,ceil(numplots/2)),
colorData(Xte_all{end,end},Tte_all{end,end})

for i=1:newK
    subplot(3,numplots,numplots+i),
    [ii,jj] = ind2sub(size(squeeze(minKL)),whichid(i));
    %test=normal(Xte_all{end,end});
    %plot(test(:,1),test(:,2),'ro'), title(['Solution # ',int2str(i)])
    %hold on,
    test=Xrec_all{ii,jj};
    plot(test(:,1),test(:,2),'x'), title(['Solution # ',int2str(i)])
end

whichSolution = input('Which solution looks best? Enter a number from above:  ');
[ii,jj,kk] = ind2sub(size(minKL),whichid(whichSolution)); 

Xrec = Xrec_all{ii,jj,kk};
R2val=evalR2(Xrec,Xte_all{ii,jj,kk});
figure, 
subplot(1,2,1), colorData(Xte_all{ii,jj,kk},Tte_all{ii,jj,kk}),
subplot(1,2,2), colorData(Xrec,Tte_all{ii,jj,kk}),
title(['R2 = ',num2str(R2val,2),...
    ', KL = ',num2str(minKL(ii,jj,kk),3)])

end
