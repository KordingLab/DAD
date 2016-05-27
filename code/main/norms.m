function y = norms( x, p, dim )

%NORMS   Computation of multiple vector norms.
%   NORMS( X ) provides a means to compute the norms of multiple vectors
%   packed into a matrix or N-D array. This is useful for performing
%   max-of-norms or sum-of-norms calculations.
%
%   All of the vector norms, including the false "-inf" norm, supported
%   by NORM() have been implemented in the NORMS() command.
%     NORMS(X,P)           = sum(abs(X).^P).^(1/P)
%     NORMS(X)             = NORMS(X,2).
%     NORMS(X,inf)         = max(abs(X)).
%     NORMS(X,-inf)        = min(abs(X)).
%   If X is a vector, these computations are completely identical to
%   their NORM equivalents. If X is a matrix, a row vector is returned
%   of the norms of each column of X. If X is an N-D matrix, the norms
%   are computed along the first non-singleton dimension.
%
%   NORMS( X, [], DIM ) or NORMS( X, 2, DIM ) computes Euclidean norms
%   along the dimension DIM. NORMS( X, P, DIM ) computes its norms
%   along the dimension DIM.

if nargin<2
    p = 2;
    dim = 1;
end

if nargin<3
    dim=1;
end

switch p,
    case 1,
        y = sum( abs( x ), dim );
    case 2,
        y = sqrt( sum( x .* conj( x ), dim ) );
    case Inf,
        y = max( abs( x ), [], dim );
    otherwise,
        y = sum( abs( x ) .^ p, dim ) .^ ( 1 / p );
end

% if dim==1
%     out = x./repmat(y,size(x,1),1);
% else
%     out = x./repmat(y,1,size(x,2));
% end

