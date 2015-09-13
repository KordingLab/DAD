function p1=prob1(X1,xt,k1)

 xsz1 = size(xt,2);
 x1sz = size(X1,1);
 d1= Getdist( xt,X1 );
 [sd1, sdInd1] = sort(d1);
 rhoX1=sd1(k1,:);
 p1 = k1./ (x1sz*rhoX1.^xsz1);
 
 return;
 
 