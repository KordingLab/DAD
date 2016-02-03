function out = evalL2err(X,Xrec)

out =sum(sum((Xrec - X).^2))./sum(sum(X.^2));


end