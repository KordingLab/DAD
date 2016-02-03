function V = removemean(V)

V = V - repmat(mean(V),size(V,1),1);

end