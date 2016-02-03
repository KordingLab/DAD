function Res = computesplitstats(Xte,Xtr,Tte,Ttr)

numdir_te = zeros(8,1);
numdir_tr = zeros(8,1);
for i=1:8
    numdir_te(i) = sum(Tte==i);
    numdir_tr(i) = sum(Ttr==i);
end

[p,D] = kstest2d(Xte,Xtr);

Res.p = p;
Res.D = D;
Res.numdir_te = numdir_te;
Res.numdir_tr = numdir_tr;

end


