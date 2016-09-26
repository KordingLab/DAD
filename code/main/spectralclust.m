function [labels,vec,V,D] = spectralclust(C,numclusters)





% perform spectral clustering

D = diag(sum(C));

L = D - C; % LaPlacian matrix



%Lnm = inv(D)*L;

num=length(L);

[V,D] = eigs(L);



d = diag(D); id = find(abs(d)>1e-5); 

[~,idx] = min(d(id));



if length(setdiff([1:length(d)],id))==2



    if length(find(V(:,2)<1e-5))>(num/2)

        vec = V(:,id(idx));

    else

        vec = V(:,2);

    end



else

    vec = V(:,id(idx));

end





% labels obtained via spectral clustering

labels = kmeans(vec,numclusters,'EmptyAction', 'singleton');



end

