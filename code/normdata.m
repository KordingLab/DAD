function Xnm = normdata(X)

Xnm = normc(X-repmat(mean(X),size(X,1),1));

end