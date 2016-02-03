function V = removemin(V)

V = V - repmat(min(V),size(V,1),1);

end