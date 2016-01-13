function R2 = evalR2(X,Y)

Y = normal(Y);
X= normal(X);
sstot = sum( var(Y) );
ssKL = sum( mean((Y - X).^2) );
R2 =   1 - ssKL/sstot;

end