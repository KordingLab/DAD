function Pcorr = evalTargetErr(Xrec,Xtr,Ttr)

out = knnsearch(Xrec,Xtr,'K',5);
Trec = Ttr(out);
Pcorr = 1 - sum(Ttr~=mode(Trec,2))./length(Ttr);

end