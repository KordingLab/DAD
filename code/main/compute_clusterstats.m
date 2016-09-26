function out = compute_clusterstats(Y,labels)

for i=1:length(unique(labels))
    tmp = Y(find(labels==i),:);
    out.mean(i) = mean(tmp(:));
    out.var(i) = var(tmp(:));
    out.size(i) = sum(labels==i)/size(Y,1);
end

end






