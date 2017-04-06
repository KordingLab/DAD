function Xr = LSoracle(Xte,Yte)

Xn = normal(Xte);
Hinv = Xn(:,1:2)'*pinv(Yte)';
Xr = (Hinv*Yte')'; 

end
