function MSA = evalMSE(X,Y)



%Y = normal(Y);

%X= normal(X);

%MSA = norm(X(:)) + norm(Y(:)) - 2*X'*Y;



MSA = 2*abs(X(:)'*Y(:))./(norm(X(:)) + norm(Y(:)));

% accuracy not error



end