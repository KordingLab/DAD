function [Xr,Hinv] = LSoracle(Xte,Yte)
Xn = Xte;
%Xn = normal(Xte);
Hinv = Xn'*pinv(Yte)';
Xr = (Hinv*Yte')'; 

end
