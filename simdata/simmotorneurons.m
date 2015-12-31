function [Y,TC] = simmotorneurons(X,N)
% X is a T x 2 matrix

T = size(X,1);
magV = norms(X')';
theta_dir = atan2(X(:,2),X(:,1));

pref_dir = 2*pi*rand(N,1);
x0 = abs(randn(N,1)*0.18);
amod = randn(N,1)*0.09;

FRates = zeros(T,N);
Y = zeros(T,N);
for i=1:N
    FRates(:,i) = exp(x0(i) + amod(i)*magV.*cos(theta_dir - pref_dir(i)));
    Y(:,i) = poissrnd(FRates(:,i),T,1);
end

TC.amod = amod;
TC.x0 = x0;
TC.pref_dir = pref_dir;

end