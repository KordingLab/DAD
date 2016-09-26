function W = compute_clusterangles(Y,labels)

k = length(unique(labels));
W = zeros(k);
for i=1:k
    tmp = Y(find(labels==i),:);
    tmp2 = trimmean(tmp,0.3);
    for j=1:i
        tmp3 = Y(find(labels==j),:);
        tmp4 = trimmean(tmp3,0.3);
        W(i,j) = (tmp2./norm(tmp2))*(tmp4./norm(tmp4))';
    end
end
   
W = W + W';


end






