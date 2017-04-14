function [Vals,Xrec,Xsup,Xr] = compare_dimreduction_methods(Xtr,Xte,Yte,Tte,opts)

opts.dimred_method='FA';
[Xrec1,~,~,tmp] = runDAD3d(Xtr,Yte,opts);
R2valDAD(1) = evalR2(Xrec1,Xte);
PcorrDAD(1) = evalTargetErr(Xrec1,Xte,Tte);
minKLDAD(1) = min(tmp);

opts.dimred_method='PCA';
[Xrec2,~,~,tmp] = runDAD3d(Xtr,Yte,opts);
R2valDAD(2) = evalR2(Xrec2,Xte);
PcorrDAD(2) = evalTargetErr(Xrec2,Xte,Tte);
minKLDAD(2) = min(tmp);

opts.dimred_method='Isomap';
[Xrec3,~,~,tmp] = runDAD3d(Xtr,Yte,opts);
R2valDAD(3) = evalR2(Xrec3,Xte);
PcorrDAD(3) = evalTargetErr(Xrec3,Xte,Tte);
minKLDAD(3) = min(tmp);

[~,idd] = min(minKLDAD);
if idd==1
    Xrec = Xrec1;
elseif  idd==2
    Xrec = Xrec2;
else
    Xrec = Xrec3;
end

%%%% Supervised methods (run oracle and kalman filter)
Xr = LSoracle(Xte,Yte);
R2Oracle = evalR2(Xr,Xte);  
PcorrOracle = evalTargetErr(Xr,Xte,Tte);

[~,~,tmp,~] = rotated_KLmin(Xr,Xtr,90);
minKLOracle = min(tmp);

[~, Xsup, ~, ~]= crossVaL(Yte, Xte, 500, 100);
R2Sup = evalR2(Xsup,Xte); 
PcorrSup = evalTargetErr(Xsup,Xte,Tte);

[~,~,tmp,~] = rotated_KLmin(Xsup,Xtr,90);
minKLSup = min(tmp);

Vals = [[R2Oracle, R2Sup, R2valDAD]; [PcorrOracle, PcorrSup, PcorrDAD]; [minKLOracle, minKLSup, minKLDAD]]'; 

end